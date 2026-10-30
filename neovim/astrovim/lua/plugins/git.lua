local config, cmd
local review, git, files, tree

config = {
  -- filetype of the tree buffer, how tree.find_window finds it
  tree_filetype = "GitReview",
  tree_width = 40,
  -- folder name prefix of worktrees edit creates (next to the repo), how delete finds them
  worktree_prefix = "nvim-git-review-",
  -- user facing notifications and prompts; %s is filled with string.format
  messages = {
    no_review = "no review in this tab",
    no_open_reviews = "no open%s reviews",
    no_worktrees = "no review worktrees to delete",
    no_merge_base = "no merge-base for %s",
    -- branch, worktree folder
    confirm_add_worktree = "create worktree %s in %s?",
    confirm_yes = "Yes",
    confirm_no = "No",
    -- review kind (checkout, worktree, local, remote), branch, path (worktrees only)
    compare_item = "%-8s  %s  %s",
    -- base, compare branch, review kind
    tab_name = "review %s...%s (%s)",
    pick_compare = "compare",
    pick_base = "base",
    pick_resume = "resume review",
    pick_close = "close review",
    pick_edit = "edit review",
    pick_delete = "delete worktree",
  },
  -- per git status letter (U for untracked): gitsigns colour, so the tree matches the
  -- change markers in the sign column, and astroui icon name
  status = {
    A = { hl = "GitSignsAdd", icon = "GitAdd" },
    M = { hl = "GitSignsChange", icon = "GitChange" },
    D = { hl = "GitSignsDelete", icon = "GitDelete" },
    R = { hl = "GitSignsChange", icon = "GitRenamed" },
    U = { hl = "GitSignsUntracked", icon = "GitUntracked" },
  },
}

cmd = {
  -- clear the quickfix list and gitsigns base, both global (works from any tab);
  -- tabs, windows, buffers and trees stay as they are
  reset = function()
    require("gitsigns").reset_base(true)
    vim.fn.setqflist({}, "r", { items = {} })
  end,

  -- pick base and compare (as git diff base...compare), then open the review in a new tab
  new = function()
    local items = {}
    local checked_out = {}
    -- checkout: the main worktree (listed first); worktree: linked ones. Both have real, editable files
    for i, line in ipairs(git.run { "worktree", "list" }) do
      local path, branch = line:match "^(%S+)%s+%S+%s+%[(.-)%]"
      if path then
        checked_out[branch] = true
        table.insert(items, { kind = i == 1 and "checkout" or "worktree", name = branch, path = path })
      end
    end
    -- local / remote: branches not checked out anywhere, reviewed as read-only git snapshots;
    -- skip remote HEAD pointers (refs/remotes/origin/HEAD shortens to "origin")
    local branches = {}
    for _, refname in ipairs(git.run { "for-each-ref", "--format=%(refname)", "refs/heads", "refs/remotes" }) do
      if not refname:match "/HEAD$" then
        local ref = refname:gsub("^refs/heads/", ""):gsub("^refs/remotes/", "")
        local kind = vim.startswith(refname, "refs/heads/") and "local" or "remote"
        table.insert(branches, { kind = kind, name = ref })
        if not checked_out[ref] then table.insert(items, { kind = kind, name = ref, ref = ref }) end
      end
    end
    -- local branches, then remote ones; origin's default branch first in each (branches is already local, then remote)
    local default = git.run({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })[1] or "origin/main"
    local default_local = default:gsub("^[^/]+/", "")
    local bases = {}
    for _, kind in ipairs { "local", "remote" } do
      local first = kind == "local" and default_local or default
      local kind_bases = vim.tbl_filter(function(b) return b.kind == kind and b.name ~= first end, branches)
      if kind == "remote" or vim.iter(branches):any(function(b) return b.kind == "local" and b.name == first end) then
        table.insert(kind_bases, 1, { kind = kind, name = first })
      end
      vim.list_extend(bases, kind_bases)
    end
    vim.ui.select(bases, {
      prompt = config.messages.pick_base,
      format_item = function(b) return config.messages.compare_item:format(b.kind, b.name, "") end,
    }, function(b)
      if not b then return end
      local base = b.name
      vim.ui.select(items, {
        prompt = config.messages.pick_compare,
        format_item = function(i)
          return config.messages.compare_item:format(i.kind, i.name, i.path and vim.fn.fnamemodify(i.path, ":~") or "")
        end,
      }, function(compare)
        if not compare then return end
        local mb = git.run({ "merge-base", base, compare.ref or "HEAD" }, compare.path)[1]
        if not mb then return vim.notify(config.messages.no_merge_base:format(base), vim.log.levels.ERROR) end
        vim.cmd.tabnew()
        review.open {
          base = base,
          mb = mb,
          kind = compare.kind,
          name = compare.name,
          ref = compare.ref,
          path = compare.path,
        }
      end)
    end)
  end,

  -- pick an open review tab (the current one first), then rebuild it from git: quickfix, gitsigns base and tree
  resume = function()
    review.pick(config.messages.pick_resume, function(tab)
      vim.api.nvim_set_current_tabpage(tab)
      review.open(vim.t.review)
    end)
  end,

  -- pick an open review tab, reset review state and close it
  close = function()
    review.pick(config.messages.pick_close, function(tab)
      cmd.reset()
      vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(tab))
    end)
  end,

  -- pick a local or remote review tab and review its branch in a new worktree instead (editable)
  edit = function()
    review.pick(config.messages.pick_edit, function(tab)
      vim.api.nvim_set_current_tabpage(tab)
      local r = vim.t.review
      git.add_worktree(
        r.ref,
        function(path, name) review.open { base = r.base, mb = r.mb, kind = "worktree", name = name, path = path } end
      )
    end, function(r) return not r.path end, " local or remote")
  end,

  -- pick a worktree edit created (config.worktree_prefix), remove it and close its review tabs
  delete = function()
    local worktrees = git.review_worktrees()
    if #worktrees == 0 then return vim.notify(config.messages.no_worktrees, vim.log.levels.WARN) end
    vim.ui.select(
      worktrees,
      { prompt = config.messages.pick_delete, format_item = function(w) return w.branch .. "  " .. w.path end },
      function(w)
        if not w then return end
        git.remove_worktree(w.path, w.repo, function()
          for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            local r = vim.t[tab].review
            if r and r.path == w.path then
              cmd.reset()
              vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(tab))
            end
          end
          -- drop buffers of the deleted files
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.startswith(vim.api.nvim_buf_get_name(buf), w.path .. "/") then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end)
      end
    )
  end,

  -- show or hide the current tab's review tree
  toggle_tree = function()
    if not vim.t.review then return vim.notify(config.messages.no_review, vim.log.levels.WARN) end
    if tree.find_window() then return tree.close() end
    tree.open()
  end,
}

review = {
  -- load review r into the current tab: quickfix (one entry per file), gitsigns base and tree
  load = function(r)
    local changed = git.changed_files(r)
    vim.t.review_files = changed -- the tree reads these
    -- replaces difftool's list; quickfixtextfunc before items, so an open quickfix window redraws with it
    vim.fn.setqflist({}, "r", { quickfixtextfunc = files.quickfix_text })
    vim.fn.setqflist({}, "r", {
      items = vim.tbl_map(
        function(f) return { bufnr = f.bufnr, module = f.path, text = f.status, valid = 1 } end,
        changed
      ),
    })
    require("gitsigns").change_base(r.mb, true)
    if not tree.find_window() then tree.open() end
    -- a fresh tab shows an empty buffer: open the first file instead
    if #changed > 0 and vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified then vim.cmd.cfirst() end
  end,

  -- pick an open review tab and pass it to cb; skips the picker when only one
  -- filter(r): only offer reviews it accepts; kind names them in the "none open" warning
  pick = function(prompt, cb, filter, kind)
    local tabs = vim.tbl_filter(function(tab)
      local r = vim.t[tab].review
      return r ~= nil and (not filter or filter(r))
    end, vim.api.nvim_list_tabpages())
    if #tabs == 0 then return vim.notify(config.messages.no_open_reviews:format(kind or ""), vim.log.levels.WARN) end
    -- current tab first, so picking the top entry acts on the review in front of you
    local current = vim.api.nvim_get_current_tabpage()
    if vim.tbl_contains(tabs, current) then
      tabs = vim.list_extend({ current }, vim.tbl_filter(function(tab) return tab ~= current end, tabs))
    end
    if #tabs == 1 then return cb(tabs[1]) end
    vim.ui.select(tabs, { prompt = prompt, format_item = function(tab) return vim.t[tab].name end }, function(tab)
      if tab then cb(tab) end
    end)
  end,

  -- fill the current tab with review r; checkout and worktree reviews (r.path) are editable, local and remote read-only
  open = function(r)
    vim.t.review = r
    vim.t.name = config.messages.tab_name:format(r.base, r.name, r.kind)
    if r.path then vim.cmd.tcd(vim.fn.fnameescape(r.path)) end
    tree.close()
    review.load(r)
  end,
}

git = {
  -- run git through fugitive in the repo containing path (default: cwd);
  -- returns the stdout lines ({} on failure) and fugitive's full result
  run = function(args, path)
    require("lazy").load { plugins = { "vim-fugitive" } } -- Fugitive* functions exist only once it is loaded
    local out = vim.fn.FugitiveExecute(args, vim.fn.FugitiveExtractGitDir(path or vim.fn.getcwd()))
    return out.exit_status == 0 and vim.tbl_filter(function(l) return l ~= "" end, out.stdout) or {}, out
  end,

  -- changed files of review r, in tree order: { status, path, bufnr }.
  -- fugitive's difftool computes the diff and its buffers (fugitive:// blobs, or worktree files);
  -- worktree reviews add untracked files as U, which diffs never list.
  changed_files = function(r)
    -- :Git uses the current buffer's repo (no -C), so run it from a scratch buffer pinned to the review's repo
    local buf = vim.api.nvim_create_buf(false, true)
    vim.b[buf].git_dir = vim.fn.FugitiveExtractGitDir(r.path or vim.fn.getcwd())
    vim.api.nvim_buf_call(buf, function()
      -- string form: Git is -nargs=?, so vim.cmd.Git { args = {...} } fails once fugitive is loaded
      vim.cmd("Git difftool --name-status " .. r.mb .. (r.ref and " " .. r.ref or ""))
    end)
    vim.api.nvim_buf_delete(buf, {})
    local changed = vim.tbl_map(function(item)
      -- module is "<ref>:<path>" for blobs, empty for worktree files (only in worktree reviews, r.path)
      local path = item.module:match ":(.+)$" or vim.fs.relpath(r.path, vim.api.nvim_buf_get_name(item.bufnr))
      return { status = item.text, path = path, bufnr = item.bufnr }
    end, vim.fn.getqflist())
    for _, path in ipairs(r.path and git.run({ "ls-files", "--others", "--exclude-standard" }, r.path) or {}) do
      table.insert(changed, { status = "U", path = path, bufnr = vim.fn.bufadd(r.path .. "/" .. path) })
    end
    table.sort(changed, function(a, b) return files.file_order(a.path, b.path) end)
    return changed
  end,

  -- ask prompt (yes/no picker), then run git args in the repo containing path; on_success
  -- runs only if git succeeds, otherwise git's error is shown
  confirm_run = function(prompt, args, path, on_success)
    local yes, no = config.messages.confirm_yes, config.messages.confirm_no
    vim.ui.select({ yes, no }, { prompt = prompt }, function(choice)
      if choice ~= yes then return end
      local _, out = git.run(args, path)
      if out.exit_status ~= 0 then return vim.notify(table.concat(out.stderr, "\n"), vim.log.levels.ERROR) end
      on_success()
    end)
  end,

  -- check ref out into a sibling worktree after confirming, then on_success(path, branch)
  add_worktree = function(ref, on_success)
    local root = git.run({ "rev-parse", "--show-toplevel" })[1]
    local local_branch = ref:match "^origin/(.+)$"
    local path = vim.fs.dirname(root) .. "/" .. config.worktree_prefix .. (local_branch or ref):gsub("/", "-")
    -- remote branch: create a local tracking branch, a worktree cannot check out origin/x itself
    local args = local_branch and { "worktree", "add", "--track", "-b", local_branch, path, ref }
      or { "worktree", "add", path, ref }
    local prompt = config.messages.confirm_add_worktree:format(local_branch or ref, vim.fn.fnamemodify(path, ":~"))
    git.confirm_run(prompt, args, nil, function() on_success(path, local_branch or ref) end)
  end,

  -- worktrees of the current repo that edit created (folder starts with config.worktree_prefix):
  -- { path, branch, repo }; repo is the main worktree (listed first), where remove_worktree runs git
  review_worktrees = function()
    local lines = git.run { "worktree", "list" }
    local repo = lines[1] and lines[1]:match "^%S+"
    local worktrees = {}
    for _, line in ipairs(vim.list_slice(lines, 2)) do
      local path, rest = line:match "^(%S+)%s+%S+%s*(.*)$"
      if path and vim.startswith(vim.fs.basename(path), config.worktree_prefix) then
        table.insert(worktrees, { path = path, branch = rest:match "%[(.-)%]" or rest, repo = repo })
      end
    end
    return worktrees
  end,

  -- remove the worktree at path (picking it in delete is the confirmation), running git from repo
  -- (git refuses to remove the worktree it runs in), then on_success(); git refuses on uncommitted changes
  remove_worktree = function(path, repo, on_success)
    local _, out = git.run({ "worktree", "remove", path }, repo)
    if out.exit_status ~= 0 then return vim.notify(table.concat(out.stderr, "\n"), vim.log.levels.ERROR) end
    on_success()
  end,
}

files = {
  -- { text, highlight } chunks for a folder: folder icon, name
  folder_chunks = function(name, open)
    local icon = require("astroui").get_icon(open and "FolderOpen" or "FolderClosed")
    return { { icon .. " ", "Directory" }, { name, "Directory" } }
  end,

  -- { text, highlight } chunks for a file: file icon, name, status icon
  file_chunks = function(name, status)
    local icon, icon_hl = require("mini.icons").get("file", name)
    local s = config.status[status] or {}
    local status_icon = s.icon and require("astroui").get_icon(s.icon) or status
    return { { icon .. " ", icon_hl }, { name, s.hl }, { " " .. status_icon, s.hl } }
  end,

  -- join chunks into plain text
  chunks_text = function(chunks)
    return table.concat(vim.tbl_map(function(chunk) return chunk[1] end, chunks))
  end,

  -- folders before files, then by name, at the first differing level
  file_order = function(a, b)
    local pa, pb = vim.split(a, "/"), vim.split(b, "/")
    for i = 1, math.min(#pa, #pb) do
      if pa[i] ~= pb[i] then
        local a_dir, b_dir = i < #pa, i < #pb
        if a_dir ~= b_dir then return a_dir end
        return pa[i] < pb[i]
      end
    end
    return #pa < #pb
  end,

  -- quickfix lines: file icon, repo-relative path, status icon
  quickfix_text = function(info)
    local items = vim.fn.getqflist({ id = info.id, items = 1 }).items or {}
    local lines = {}
    for _, item in ipairs(vim.list_slice(items, info.start_idx, info.end_idx)) do
      -- review.load stores the repo-relative path in module
      table.insert(lines, files.chunks_text(files.file_chunks(item.module, item.text)))
    end
    return lines
  end,
}

tree = {
  -- window showing the review file tree in tab (default: current), or nil
  find_window = function(tab)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab or 0)) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == config.tree_filetype then return win end
    end
  end,

  -- open the review file tree as a left sidebar in the current tab
  open = function()
    local changed = vim.t.review_files
    local NuiTree, NuiLine = require "nui.tree", require "nui.line"

    -- nest paths into folders; files arrive in tree order (git.changed_files sorts them), so keep insertion order
    local root, folders = {}, {}
    for _, file in ipairs(changed) do
      local children, prefix, parts = root, "", vim.split(file.path, "/")
      for i = 1, #parts - 1 do
        prefix = prefix .. parts[i] .. "/"
        if not folders[prefix] then
          folders[prefix] = { text = parts[i], children = {} }
          table.insert(children, folders[prefix])
        end
        children = folders[prefix].children
      end
      table.insert(children, { text = parts[#parts], file = file })
    end
    local function nodes(list)
      return vim.tbl_map(function(item)
        if item.file then return NuiTree.Node { text = item.text, file = item.file } end
        local node = NuiTree.Node({ text = item.text }, nodes(item.children))
        node:expand()
        return node
      end, list)
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, { split = "left", win = -1, width = config.tree_width })
    local wo = vim.wo[win][0]
    wo.cursorline = true -- marks the file shown in the review window
    wo.winfixwidth, wo.number, wo.relativenumber, wo.signcolumn, wo.foldcolumn = true, false, false, "no", "0"
    wo.winbar = " " .. vim.t.name:gsub("%%", "%%%%")

    local nui_tree = NuiTree {
      bufnr = buf,
      -- nui defaults bufhidden to "hide"; wipe frees the buffer when the tree closes
      buf_options = { bufhidden = "wipe", filetype = config.tree_filetype },
      nodes = nodes(root),
      prepare_node = function(node)
        local line = NuiLine()
        line:append(string.rep("  ", node:get_depth() - 1))
        local chunks = node.file and files.file_chunks(node.text, node.file.status)
          or files.folder_chunks(node.text, node:is_expanded())
        for _, chunk in ipairs(chunks) do
          line:append(chunk[1], chunk[2])
        end
        return line
      end,
    }
    nui_tree:render()

    local function activate()
      local node = nui_tree:get_node()
      if not node then return end
      if node.file then
        vim.cmd.wincmd "p"
        vim.cmd.buffer(node.file.bufnr)
      else
        if node:is_expanded() then
          node:collapse()
        else
          node:expand()
        end
        nui_tree:render()
      end
    end
    vim.keymap.set("n", "<CR>", activate, { buffer = buf, desc = "Open file / toggle directory" })
    -- nui only renders; mouse support is a mapping, double-click like neo-tree
    vim.keymap.set("n", "<2-LeftMouse>", activate, { buffer = buf, desc = "Open file / toggle directory" })
    vim.keymap.set("n", "l", activate, { buffer = buf, desc = "Open file / toggle directory" })
    vim.keymap.set("n", "h", function()
      local node = nui_tree:get_node()
      -- on an open folder fold it, otherwise fold the folder containing the cursor
      if node and (node.file or not node:is_expanded()) then
        local parent_id = node:get_parent_id()
        if not parent_id then return end
        local linenr
        node, linenr = nui_tree:get_node(parent_id)
        if linenr then vim.api.nvim_win_set_cursor(0, { linenr, 0 }) end
      end
      if not node then return end
      node:collapse()
      nui_tree:render()
    end, { buffer = buf, desc = "Close directory" })
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = buf, desc = "Close tree" })

    -- move the tree cursor to the file entered in this tab (]q, <CR>, ...); lives as long as the tree buffer
    local group = vim.api.nvim_create_augroup("git_review_tree_" .. buf, {})
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      callback = function(ev)
        if
          not vim.api.nvim_win_is_valid(win)
          or vim.api.nvim_win_get_tabpage(win) ~= vim.api.nvim_get_current_tabpage()
        then
          return
        end
        for linenr = 1, vim.api.nvim_buf_line_count(buf) do
          local node = nui_tree:get_node(linenr)
          if node and node.file and node.file.bufnr == ev.buf then
            return vim.api.nvim_win_set_cursor(win, { linenr, 0 })
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd(
      "BufWipeout",
      { buffer = buf, callback = function() vim.api.nvim_del_augroup_by_id(group) end }
    )
    vim.cmd.wincmd "p"
  end,

  -- close the review file tree in tab (default: current), if open
  close = function(tab)
    local win = tree.find_window(tab)
    if win then vim.api.nvim_win_close(win, true) end
  end,
}

---@type LazySpec
return {
  { "MunifTanjim/nui.nvim" },
  { "tpope/vim-fugitive" },
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        mappings = {
          n = {
            ["<Leader>g."] = { desc = "Git review" },
            ["<Leader>g.n"] = { cmd.new, desc = "New review" },
            ["<Leader>g.."] = { cmd.resume, desc = "Resume review" },
            ["<Leader>g.c"] = { cmd.close, desc = "Close review" },
            ["<Leader>g.e"] = { cmd.edit, desc = "Edit local or remote review in a worktree" },
            ["<Leader>g.d"] = { cmd.delete, desc = "Delete review worktree" },
            ["<Leader>g.r"] = { cmd.reset, desc = "Reset review state" },
            ["<Leader>g.-"] = { cmd.toggle_tree, desc = "Toggle review tree" },
          },
        },
      })
    end,
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      -- tab list shows t:name when set, else the tab number
      -- default tabline layout: https://docs.astronvim.com/recipes/status/ ([4][1] = make_tablist)
      opts.tabline[4][1] = require("astroui.status").heirline.make_tablist {
        provider = function(self) return " " .. (vim.t[self.tabpage].name or self.tabnr) .. " " end,
        hl = function(self)
          local status = require "astroui.status"
          return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true)
        end,
      }
    end,
  },
}
