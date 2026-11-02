-- config: settings, variable names and messages; fixed once loaded
-- state: what changes at runtime, kept in Lua between calls
-- cmd: the <Leader>g. commands
-- handlers: autocmd callbacks (buffer and tab switches, gitsigns updates, exit)
-- session: resession extension and hooks: save and restore review tabs, placeholders for missing worktrees
-- review: open a review in a tab, pick review tabs, find the file shown
-- worktree: take a removed worktree out of the editor: its review tabs, buffers and cwds
-- quickfix: the review list in the global quickfix history, swapped with the user's lists per tab
-- git: git through fugitive (merge-base, changed files, worktrees) and the gitsigns base per tab
-- files: how files and folders show (icons, colours, order) in the tree and quickfix
-- tree: the review file tree sidebar
local config, state, cmd, handlers, session, review, worktree, quickfix, git, files, tree

config = {
  -- file marking placeholder folders as ours, so a later nvim (after a load resession aborted) can still remove them
  placeholder_mark = ".git_review_placeholder",
  -- filetype of the tree buffer, how tree.find_window finds it
  tree_filetype = "GitReview",
  tree_width = 40,
  -- prefix of config.vars, augroups and the resession extension
  namespace = "git_review",
  -- prefix of the worktree folders edit creates (how delete finds them): __git_review__<repo>__<branch>
  worktree_prefix = "__git_review__",
  -- every variable a review keeps, by its key here: vim.t[config.vars.spec]; suffixes of namespace
  -- (prefixed below the table, a table cannot read its own fields while being built)
  vars = {
    -- tab: the review { base, kind, name, repo, ref?, path? }; marks a review tab, saved by the session.
    -- repo: the main worktree, the tab's cwd when there is no path (git runs there)
    spec = "_spec",
    -- buffer: kept for its unsaved edits when its worktree was removed, detached from gitsigns
    detached = "_detached",
    -- tab: changed files { status, path, bufnr }, in tree order; the tree and quickfix read them
    files = "_files",
    -- buffer: gitsigns base git.sync_base last set (nil: gitsigns' default); gitsigns does not expose it
    base = "_base",
  },
  -- user facing notifications and prompts; %s is filled with string.format
  messages = {
    no_review = "no review in this tab",
    no_open_reviews = "no open%s reviews",
    no_worktrees = "no review worktrees to delete",
    no_merge_base = "no merge-base for %s",
    -- branch
    missing_branch = "branch %s not found",
    wiped_buffer = "%s was wiped, resume the review to load it again",
    unsaved_buffers = "%s has unsaved buffers, write or discard them first",
    -- worktree folder
    cwd_inside = "nvim's working directory (:cd) is inside %s, :cd elsewhere first",
    -- review name, worktree folder
    missing_worktree = "%s: worktree %s no longer exists, closed the review",
    kept_modified = "kept %d modified buffers of the removed worktree: write them elsewhere or :bwipeout! them",
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
-- suffixes to full names, keys kept: config.vars.spec "_spec" → "git_review_spec" (vim.t[...] is t:git_review_spec);
-- the namespace keeps them clear of other plugins' variables
config.vars = vim.tbl_map(function(suffix) return config.namespace .. suffix end, config.vars)

state = {
  -- review tabs by tab handle: { mb, files, bufs = { [bufnr] = true } }; a plain Lua copy of the t: vars for
  -- the TabEnter and gitsigns autocmds, which run on every tab or buffer switch (reading a t: table copies it whole)
  active = {},
  -- reviews of the session being loaded (resession extension data), from on_pre_load until restore
  pending = nil,
  -- folders on_pre_load made for missing worktrees, until restore removes them
  placeholders = {},
  -- quickfix history position of the user's list that was current when a review tab took over (0: none);
  -- leaving the review tabs goes back to it
  qf_back = 0,
  -- buffers with a gitsigns change_base running (git.sync_base): true, or "again" to redo it when it ends
  changing = {},
}

cmd = {
  -- pick base and compare (as git diff base...compare), then open the review in a new tab
  new = function()
    local items = {}
    local checked_out = {}
    -- checkout: the main worktree (listed first); worktree: linked ones. Both have real, editable files
    local worktrees = git.worktrees()
    local repo = worktrees[1] and worktrees[1].path
    for i, w in ipairs(worktrees) do
      if w.branch then
        checked_out[w.branch] = true
        -- a worktree removed or moved outside git: nothing to review, and its branch cannot get a new one
        if i == 1 or vim.uv.fs_stat(w.path .. "/.git") then
          table.insert(items, { kind = i == 1 and "checkout" or "worktree", name = w.branch, path = w.path })
        end
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
      if vim.iter(branches):any(function(b) return b.kind == kind and b.name == first end) then
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
        local r =
          { base = base, kind = compare.kind, name = compare.name, repo = repo, ref = compare.ref, path = compare.path }
        if not git.merge_base(r) then return end
        vim.cmd.tabnew()
        review.open(r)
      end)
    end)
  end,

  -- pick an open review tab (the current one first), then rebuild it from git: merge-base, quickfix, gitsigns base and tree
  resume = function()
    review.pick(config.messages.pick_resume, function(tab)
      local r, current = vim.t[tab][config.vars.spec], review.current_file(tab)
      vim.api.nvim_set_current_tabpage(tab)
      -- TabEnter closed it (worktree removed outside nvim)
      if not vim.api.nvim_tabpage_is_valid(tab) then return end
      review.open(r, current)
    end)
  end,

  -- pick an open review tab and close it (TabClosed drops its state)
  close = function()
    review.pick(config.messages.pick_close, function(tab)
      local r = vim.t[tab][config.vars.spec]
      -- worktree removed outside nvim: also wipe its buffers and move tabs out of it
      if worktree.missing(r) then return worktree.close_missing(tab, r) end
      worktree.close_tab(tab)
    end)
  end,

  -- pick a local or remote review tab and review its branch in a new worktree instead (editable), after confirming
  edit = function()
    review.pick(config.messages.pick_edit, function(tab)
      vim.api.nvim_set_current_tabpage(tab)
      local r, current = vim.t[config.vars.spec], review.current_file(tab)
      local path, branch = git.worktree_folder(r.ref, r.kind == "remote")
      -- a placeholder left by an aborted session load would make git refuse the folder
      session.remove_placeholders { path }
      local yes, no = config.messages.confirm_yes, config.messages.confirm_no
      local prompt = config.messages.confirm_add_worktree:format(branch, vim.fn.fnamemodify(path, ":~"))
      vim.ui.select({ yes, no }, { prompt = prompt }, function(choice)
        if choice ~= yes or not git.add_worktree(r.ref, branch, path) then return end
        review.open({ base = r.base, kind = "worktree", name = branch, repo = r.repo, path = path }, current)
      end)
    end, function(r) return not r.path end, " local or remote")
  end,

  -- pick a worktree edit created (config.namespace), remove it and close its review tabs
  delete = function()
    local worktrees = git.review_worktrees()
    if #worktrees == 0 then return vim.notify(config.messages.no_worktrees, vim.log.levels.WARN) end
    vim.ui.select(
      worktrees,
      { prompt = config.messages.pick_delete, format_item = function(w) return w.branch .. "  " .. w.path end },
      function(w)
        if not w then return end
        -- deleting wipes its buffers, and git only sees what is on disk: refuse while any has unsaved edits
        local bufs = vim.tbl_filter(
          function(buf) return vim.startswith(vim.api.nvim_buf_get_name(buf), w.path .. "/") end,
          vim.api.nvim_list_bufs()
        )
        if vim.iter(bufs):any(function(buf) return vim.bo[buf].modified end) then
          return vim.notify(config.messages.unsaved_buffers:format(w.branch), vim.log.levels.ERROR)
        end
        -- the global cwd is not a review's (tab-local, moved by leave_folder): removing its folder leaves nvim
        -- without one, and close_tab's tcd to it fails
        if vim.startswith(vim.fn.getcwd(-1, -1) .. "/", w.path .. "/") then
          return vim.notify(config.messages.cwd_inside:format(vim.fn.fnamemodify(w.path, ":~")), vim.log.levels.ERROR)
        end
        git.remove_worktree(w.path, w.repo, function()
          local tabs = vim.tbl_filter(function(tab)
            local r = vim.t[tab][config.vars.spec]
            return r and r.path == w.path
          end, vim.api.nvim_list_tabpages())
          -- drop buffers of the deleted files first. git.sync_base must not touch them (deleting fires
          -- GitSignsUpdate): resetting their gitsigns base runs git in a folder that no longer exists, so
          -- forget their review and mark them as already on gitsigns' default base
          -- deleted files' blobs are read through the main repo (changed_files): wipe those no other review shows
          local blobs = {}
          for _, tab in ipairs(tabs) do
            for buf in pairs(state.active[tab] and state.active[tab].bufs or {}) do
              if vim.startswith(vim.api.nvim_buf_get_name(buf), "fugitive://") then blobs[buf] = true end
            end
            -- the spec too: close_tab fires handlers.tab_enter, which would take a later one for a worktree removed
            -- outside nvim (close_missing: warns)
            vim.t[tab][config.vars.spec], state.active[tab] = nil, nil
          end
          for _, a in pairs(state.active) do
            for buf in pairs(a.bufs) do
              blobs[buf] = nil
            end
          end
          for buf in pairs(blobs) do
            if vim.api.nvim_buf_is_valid(buf) and not vim.bo[buf].modified then
              vim.b[buf][config.vars.base] = nil
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
          worktree.wipe_buffers(w.path)
          for _, tab in ipairs(tabs) do
            worktree.close_tab(tab)
          end
          -- other tabs opened from a review tab inherited its cwd: move them out of the removed folder
          worktree.leave_folder(w.path, w.repo)
        end)
      end
    )
  end,

  -- show or hide the current tab's review tree
  toggle_tree = function()
    if not vim.t[config.vars.spec] then return vim.notify(config.messages.no_review, vim.log.levels.WARN) end
    if tree.find_window() then return tree.close() end
    tree.open()
  end,
}

handlers = {
  -- BufEnter: gitsigns base per tab (see git.sync_base); it returns at once when the base is unchanged, and also
  -- resets buffers after the last review closes
  buf_enter = function(ev) git.sync_base(ev.buf) end,

  -- User GitSignsUpdate: gitsigns ignores change_base on buffers it has not attached to yet (review files open
  -- lazily); its first update after attaching applies the base
  gitsigns_update = function(ev)
    -- buffers of other tabs get their base on TabEnter
    local buf = ev.data and ev.data.buffer
    if buf and vim.tbl_contains(vim.fn.tabpagebuflist(), buf) then git.sync_base(buf) end
  end,

  -- BufReadPost: a read makes gitsigns attach again with its default base
  buf_read_post = function(ev) vim.b[ev.buf][config.vars.base] = nil end,

  -- TabClosed: drop the state of closed review tabs
  tab_closed = function()
    for tab in pairs(state.active) do
      if not vim.api.nvim_tabpage_is_valid(tab) then state.active[tab] = nil end
    end
  end,

  -- TabEnter (also after closing a tab, and after a session load or save): the current tab was entered: give its
  -- buffers their gitsigns base; quickfix is global, so a review tab swaps in its list (no git) and other tabs clear
  -- a review list but keep any other list
  tab_enter = function()
    local tab = vim.api.nvim_get_current_tabpage()
    local r = vim.t[tab][config.vars.spec]
    -- worktree removed outside nvim while its tab was open: syncing would run git in it (async errors)
    if r and worktree.missing(r) then return worktree.close_missing(tab, r) end
    git.sync_tab()
    local a = state.active[tab]
    if a then
      quickfix.set(a.files)
    else
      quickfix.leave()
    end
  end,

  -- VimLeavePre: placeholders of a load resession aborted: remove them now, the next nvim may never load that session
  vim_leave_pre = function() session.remove_placeholders(state.placeholders) end,
}

-- by name (config.namespace) below; a callback returning true would delete its autocmd, the handlers return nothing
vim.api.nvim_create_augroup(config.namespace, {})
vim.api.nvim_create_autocmd("BufEnter", { group = config.namespace, callback = handlers.buf_enter })
vim.api.nvim_create_autocmd(
  "User",
  { group = config.namespace, pattern = "GitSignsUpdate", callback = handlers.gitsigns_update }
)
vim.api.nvim_create_autocmd("BufReadPost", { group = config.namespace, callback = handlers.buf_read_post })
vim.api.nvim_create_autocmd("TabClosed", { group = config.namespace, callback = handlers.tab_closed })
vim.api.nvim_create_autocmd("TabEnter", { group = config.namespace, callback = handlers.tab_enter })
vim.api.nvim_create_autocmd("VimLeavePre", { group = config.namespace, callback = handlers.vim_leave_pre })

session = {
  -- extension: resession restores each tab's cwd after this, and a worktree deleted outside nvim aborts the whole
  -- load (E344): create an empty folder in its place, restore closes the review and removes it.
  -- The rebuild waits for the post_load hook (restore): events are off until then, and fugitive reads blobs in
  -- BufReadCmd (they would show empty)
  on_pre_load = function(saved)
    state.pending = saved
    -- resession reuses the current tab for the session's first: forget the reviews open before the load
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      if vim.t[tab][config.vars.spec] then
        vim.t[tab][config.vars.spec], vim.t[tab][config.vars.files], vim.t[tab].name = nil, nil, nil
      end
      state.active[tab] = nil
    end
    for _, s in ipairs(saved) do
      if worktree.missing(s.review) then
        s.missing = true
        if vim.fn.isdirectory(s.review.path) == 0 then
          -- top: the first folder mkdir creates, recorded in the mark (its parents go with it)
          local top = s.review.path
          while vim.fn.isdirectory(vim.fs.dirname(top)) == 0 do
            top = vim.fs.dirname(top)
          end
          -- a file in its place (E739): resession's tcd aborts the load anyway
          s.created = pcall(vim.fn.mkdir, s.review.path, "p") and vim.fn.isdirectory(s.review.path) == 1
          if s.created then
            local ok, res = pcall(vim.fn.writefile, { top }, s.review.path .. "/" .. config.placeholder_mark)
            -- no mark, no way to tell it from a user's folder later: remove it now (resession's tcd aborts)
            if not ok or res ~= 0 then
              s.created = false
              local dir = s.review.path
              while vim.startswith(dir .. "/", top .. "/") and vim.fn.delete(dir, "d") == 0 do
                dir = vim.fs.dirname(dir)
              end
            end
          end
        else
          -- one of ours left by an earlier nvim
          s.created = vim.uv.fs_stat(s.review.path .. "/" .. config.placeholder_mark) ~= nil
        end
        if s.created then table.insert(state.placeholders, s.review.path) end
      end
    end
  end,

  -- post_load hook: end of a session load, events back on: tabs are recreated in saved order; rebuild each review
  -- (quickfix, gitsigns, tree) from git, or close it with its buffers when its worktree is gone (see on_pre_load)
  restore = function()
    if not state.pending then return end
    local saved, tabs, current = state.pending, vim.api.nvim_list_tabpages(), vim.api.nvim_get_current_tabpage()
    state.pending = nil
    local missing = vim.tbl_filter(function(s) return s.missing and tabs[s.tab] end, saved)
    -- cwds (tabs opened from its review tab, or the global one) in a missing worktree: its repo instead
    for _, s in ipairs(missing) do
      worktree.leave_folder(s.review.path, s.review.repo)
    end
    for _, s in ipairs(saved) do
      if not s.missing and tabs[s.tab] then
        vim.api.nvim_set_current_tabpage(tabs[s.tab])
        review.open(s.review, s.current)
      end
    end
    -- the saved current tab: resession cannot restore it when its window shows a review buffer (unlisted)
    local saved_current = vim.iter(saved):find(function(s) return s.current_tab and not s.missing and tabs[s.tab] end)
    -- review.open closes a review whose worktree went missing since on_pre_load
    local target = saved_current and tabs[saved_current.tab] or current
    if vim.api.nvim_tabpage_is_valid(target) then vim.api.nvim_set_current_tabpage(target) end
    local warned, created = {}, {}
    for _, s in ipairs(missing) do
      worktree.wipe_buffers(s.review.path)
      worktree.close_tab(tabs[s.tab])
      -- only the empty folder on_pre_load made, never one the user made
      if s.created then table.insert(created, s.review.path) end
      -- one warning per worktree, however many tabs reviewed it
      if not warned[s.review.path] then
        warned[s.review.path] = true
        local name = config.messages.tab_name:format(s.review.base, s.review.name, s.review.kind)
        vim.notify(config.messages.missing_worktree:format(name, s.review.path), vim.log.levels.WARN)
      end
    end
    session.remove_placeholders(created)
    state.placeholders = vim.tbl_filter(function(p) return not vim.tbl_contains(created, p) end, state.placeholders)
    handlers.tab_enter()
  end,

  -- extension: { tab = tab number in the session, review = vim.t[config.vars.spec], current = path of the review file
  -- shown }; a list, a sparse table breaks json. current: resession does not save fugitive blob windows
  on_save = function()
    local saved = {}
    for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
      if vim.t[tab][config.vars.spec] then
        table.insert(saved, {
          tab = i,
          review = vim.t[tab][config.vars.spec],
          current = review.current_file(tab),
          current_tab = tab == vim.api.nvim_get_current_tabpage() or nil,
        })
      end
    end
    return saved
  end,

  -- pre_load hook, before every load (tab sessions skip on_pre_load): drop what a load resession aborted left behind,
  -- else restore would act on its reviews; remove its placeholders if still empty
  pre_load = function()
    state.pending = nil
    session.remove_placeholders(state.placeholders)
    state.placeholders = {}
  end,

  -- remove placeholder folders on_pre_load made, only while one holds nothing but its mark, then the empty
  -- parents mkdir made for them (up to the top folder each mark records). All folders first, parents after:
  -- placeholders may share parents, in any order. cwds move out of each folder first (an exit autosave would
  -- store them, and loading that session fails: E344)
  remove_placeholders = function(paths)
    local tops = {}
    -- deepest first: a placeholder may sit inside another one
    paths = vim.list_extend({}, paths)
    table.sort(paths, function(a, b) return #a > #b end)
    for _, path in ipairs(paths) do
      -- readdir of a missing folder prints E484 (no error to catch): the usual case, from add_worktree
      local entries = vim.fn.isdirectory(path) == 1 and vim.fn.readdir(path) or {}
      local mark = path .. "/" .. config.placeholder_mark
      local top
      if #entries == 1 and entries[1] == config.placeholder_mark then
        -- unreadable mark (E484): deleting it only needs the folder writable
        local ok, lines = pcall(vim.fn.readfile, mark)
        top = ok and lines[1] or ""
        -- an empty or foreign top would let the walk climb out of what mkdir made
        if top == "" or not vim.startswith(path .. "/", top .. "/") then top = path end
        -- every folder up to top must be removable (itself and its parent writable): one left without its
        -- mark would pass for a user's folder forever; skipped now, a later load retries
        local dir = path
        while top and vim.startswith(dir .. "/", top .. "/") do
          if vim.fn.filewritable(dir) ~= 2 or vim.fn.filewritable(vim.fs.dirname(dir)) ~= 2 then top = nil end
          dir = vim.fs.dirname(dir)
        end
      end
      if top then
        worktree.leave_folder(path, vim.fs.dirname(path))
        vim.fn.delete(mark)
        vim.fn.delete(path, "d")
        tops[path] = top
      end
    end
    local dirs = {}
    for path, top in pairs(tops) do
      local dir = vim.fs.dirname(path)
      while vim.startswith(dir .. "/", top .. "/") do
        dirs[dir] = true
        dir = vim.fs.dirname(dir)
      end
    end
    dirs = vim.tbl_keys(dirs)
    -- deepest first: a folder empties only once every chain below it is gone
    table.sort(dirs, function(a, b) return #a > #b end)
    for _, dir in ipairs(dirs) do
      if vim.fn.isdirectory(dir) == 1 and #vim.fn.readdir(dir) == 0 then
        worktree.leave_folder(dir, vim.fs.dirname(dir))
        vim.fn.delete(dir, "d")
      end
    end
  end,
}

-- resession extension (AstroNvim sessions): keeps review tabs across restarts. resession requires
-- extensions as resession.extensions.<name>, so preload keeps it in this file
package.preload["resession.extensions." .. config.namespace] = function()
  return { on_pre_load = session.on_pre_load, on_save = session.on_save }
end

review = {
  -- fill the current tab with review r; checkout and worktree reviews (r.path) are editable, local and remote
  -- read-only. current: see review.load
  open = function(r, current)
    vim.t[config.vars.spec] = r
    vim.t.name = config.messages.tab_name:format(r.base, r.name, r.kind)
    -- always tcd: a tab opened from another review tab inherits that tab's cwd, maybe a removed worktree
    -- worktree removed outside nvim (resume): tcd would fail (E344)
    if worktree.missing(r) then return worktree.close_missing(vim.api.nvim_get_current_tabpage(), r) end
    local cwd = r.path or r.repo
    if cwd then vim.cmd.tcd(vim.fn.fnameescape(cwd)) end
    -- from git each time: base or compare may have moved since the review was opened (or saved)
    local mb = git.merge_base(r)
    if not mb then return end
    tree.close()
    review.load(r, mb, current)
  end,

  -- load review r into the current tab, diffed from merge-base mb: editor window, quickfix (one entry per
  -- file), gitsigns base and tree; current: path of the file to show (a restored session's), else the first
  load = function(r, mb, current)
    local changed = git.changed_files(r, mb)
    vim.t[config.vars.files] = changed -- the tree and quickfix.set read these
    local bufs = {}
    for _, f in ipairs(changed) do
      bufs[f.bufnr] = true
    end
    state.active[vim.api.nvim_get_current_tabpage()] = { mb = mb, files = changed, bufs = bufs }
    -- a session restores no editor window (it skips fugitive blobs), so make one above the quickfix window
    local editor = review.editor_window()
    if not editor then
      vim.cmd "topleft new"
      editor = vim.api.nvim_get_current_win()
    end
    vim.api.nvim_set_current_win(editor)
    -- show a review file in place of an empty buffer or a stale blob (edit turns a blob review into a worktree)
    local name = vim.api.nvim_buf_get_name(0)
    local blob = vim.startswith(name, "fugitive://") and vim.bo.filetype ~= "fugitive"
    if #changed > 0 and not vim.bo.modified and (name == "" or blob) then
      local file = vim.iter(changed):find(function(f) return f.path == current end) or changed[1]
      if vim.api.nvim_buf_is_valid(file.bufnr) then vim.cmd.buffer(file.bufnr) end
    end
    quickfix.set(changed)
    git.sync_tab()
    if not tree.find_window() then tree.open() end
  end,

  -- path of the review file shown in tab's editor window, or nil
  current_file = function(tab)
    local a = state.active[tab]
    if not a then return end
    local win = vim.api.nvim_win_call(vim.api.nvim_tabpage_get_win(tab), review.editor_window)
    local buf = win and vim.api.nvim_win_get_buf(win)
    local file = vim.iter(a.files):find(function(f) return f.bufnr == buf end)
    return file and file.path
  end,

  -- window of the current tab that shows files (not the tree, quickfix or a float), the previous one if it
  -- does, or nil
  editor_window = function()
    local function editor(win)
      return vim.api.nvim_win_is_valid(win)
        and vim.api.nvim_win_get_config(win).relative == ""
        and vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= config.tree_filetype
        and not vim.tbl_contains({ "quickfix", "terminal", "help" }, vim.bo[vim.api.nvim_win_get_buf(win)].buftype)
    end
    local previous = vim.fn.win_getid(vim.fn.winnr "#")
    if previous ~= 0 and editor(previous) then return previous end
    return vim.iter(vim.api.nvim_tabpage_list_wins(0)):find(editor)
  end,

  -- pick an open review tab and pass it to cb; skips the picker when only one
  -- filter(r): only offer reviews it accepts; label names them in the "none open" warning
  pick = function(prompt, cb, filter, label)
    local tabs = vim.tbl_filter(function(tab)
      local r = vim.t[tab][config.vars.spec]
      return r ~= nil and (not filter or filter(r))
    end, vim.api.nvim_list_tabpages())
    if #tabs == 0 then return vim.notify(config.messages.no_open_reviews:format(label or ""), vim.log.levels.WARN) end
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
}

worktree = {
  -- worktree review whose worktree is gone: no folder, or a leftover one without its .git file
  missing = function(r) return r.path ~= nil and vim.uv.fs_stat(r.path .. "/.git") == nil end,

  -- close review r in tab and every other tab reviewing the same worktree
  close_missing = function(tab, r)
    -- forget them all before closing any: close_tab fires handlers.tab_enter, which would close them again
    local tabs = vim.tbl_filter(function(t)
      local o = vim.t[t][config.vars.spec]
      return t == tab or (o and o.path == r.path)
    end, vim.api.nvim_list_tabpages())
    for _, t in ipairs(tabs) do
      vim.t[t][config.vars.spec], state.active[t] = nil, nil
    end
    worktree.wipe_buffers(r.path)
    worktree.leave_folder(r.path, r.repo)
    for _, t in ipairs(tabs) do
      worktree.close_tab(t)
    end
    local name = config.messages.tab_name:format(r.base, r.name, r.kind)
    vim.notify(config.messages.missing_worktree:format(name, r.path), vim.log.levels.WARN)
  end,

  -- move every cwd (tab-local and global) inside path, a removed worktree, to repo (default: the main repo of
  -- the current one, else home): a cwd left on a missing folder breaks later :tcd/:cd (E344)
  leave_folder = function(path, repo)
    local inside = function(cwd) return vim.startswith(cwd .. "/", path .. "/") end
    repo = repo or vim.fn.expand "~"
    for _, t in ipairs(vim.api.nvim_list_tabpages()) do
      if vim.fn.haslocaldir(-1, vim.api.nvim_tabpage_get_number(t)) == 1 then
        if inside(vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(t))) then
          vim.api.nvim_win_call(vim.api.nvim_tabpage_get_win(t), function() vim.cmd.tcd(vim.fn.fnameescape(repo)) end)
        end
      end
    end
    if inside(vim.fn.getcwd(-1, -1)) then
      -- :cd also drops the current tab's local cwd: put it back
      local tab = vim.fn.haslocaldir(-1, 0) == 1 and vim.fn.getcwd(-1, 0)
      vim.cmd.cd(vim.fn.fnameescape(repo))
      if tab then vim.cmd.tcd(vim.fn.fnameescape(tab)) end
    end
  end,

  -- close tab (TabClosed drops its state); the last tab cannot close (E784), so open an empty one first
  close_tab = function(tab)
    if not vim.api.nvim_tabpage_is_valid(tab) then return end
    if #vim.api.nvim_list_tabpages() == 1 then
      vim.cmd.tabnew()
      -- not the review's cwd it inherited, maybe a worktree about to be removed
      vim.cmd.tcd(vim.fn.fnameescape(vim.fn.getcwd(-1, -1)))
    end
    vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(tab))
    -- closing another tab fires no TabEnter: drop its quickfix list when the current tab is not a review
    handlers.tab_enter()
  end,

  -- wipe the buffers of files under path (a removed worktree), unsaved edits included,
  -- and fugitive blobs read through it (fugitive://<repo>/.git/worktrees/<folder>//<sha>/<file>)
  wipe_buffers = function(path)
    local blobs, kept = "/.git/worktrees/" .. vim.fs.basename(path) .. "//", 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      if vim.startswith(name, path .. "/") or (vim.startswith(name, "fugitive://") and name:find(blobs, 1, true)) then
        vim.b[buf][config.vars.base] = nil
        -- unsaved edits: keep the buffer, never lose them silently
        if vim.bo[buf].modified then
          kept = kept + 1
          -- else gitsigns runs git in the missing folder each time the buffer is shown
          pcall(require("gitsigns").detach, buf)
          vim.b[buf][config.vars.detached] = true
        else
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
    if kept > 0 then vim.notify(config.messages.kept_modified:format(kept), vim.log.levels.WARN) end
  end,
}

quickfix = {
  -- fill the quickfix list (global) with changed (one entry per file), current entry at the current buffer
  set = function(changed)
    -- a wiped buffer (:bwipeout) makes setqflist fail (E92): leave its file out until resume rebuilds the list
    changed = vim.tbl_filter(function(f) return vim.api.nvim_buf_is_valid(f.bufnr) end, changed)
    -- the review list goes last, after the user's lists (reachable with :colder, TabEnter goes back to them in
    -- other tabs). Only one review list: rebuild the history when there are more, or one before a user list
    local titles = quickfix.titles()
    local reviews = #vim.tbl_filter(function(t) return t == config.namespace end, titles)
    -- also empty untitled lists, and resession's (an empty saved list restores as :setqflist())
    local empty = vim.iter(ipairs(titles)):any(
      function(i, t) return (t == "" or t == ":setqflist()") and vim.fn.getqflist({ nr = i, size = 0 }).size == 0 end
    )
    if empty or reviews > 1 or (reviews == 1 and titles[#titles] ~= config.namespace) then
      state.qf_back = quickfix.drop(quickfix.back())
      titles = quickfix.titles()
    else
      state.qf_back = quickfix.back()
    end
    if titles[#titles] == config.namespace then
      vim.cmd("silent " .. #titles .. "chistory")
    else
      quickfix.newest()
      vim.fn.setqflist({}, " ")
    end
    -- quickfixtextfunc before items, so an open quickfix window redraws with it; the title marks it as a
    -- review list
    vim.fn.setqflist({}, "r", { quickfixtextfunc = quickfix.text, title = config.namespace })
    vim.fn.setqflist({}, "r", {
      items = vim.tbl_map(
        function(f) return { bufnr = f.bufnr, module = f.path, text = f.status, valid = 1 } end,
        changed
      ),
    })
    local current = vim.api.nvim_get_current_buf()
    for i, f in ipairs(changed) do
      if f.bufnr == current then return vim.fn.setqflist({}, "a", { idx = i }) end
    end
  end,

  -- drop the review list (always the newest) and go back to the user's list: the one current now, else the
  -- one before the review tab took over
  leave = function()
    if not vim.tbl_contains(quickfix.titles(), config.namespace) then return end
    local back = quickfix.drop(quickfix.back())
    state.qf_back = 0
    local count = vim.fn.getqflist({ nr = "$" }).nr
    -- also redraws an open quickfix window (drop rebuilds with events off)
    if count > 0 then vim.cmd("silent " .. (back > 0 and back or count) .. "chistory") end
  end,

  -- title of each list in the quickfix history, by position
  titles = function()
    local titles = {}
    for nr = 1, vim.fn.getqflist({ nr = "$" }).nr do
      titles[nr] = vim.fn.getqflist({ nr = nr, title = 1 }).title
    end
    return titles
  end,

  -- position of the user's list to go back to when leaving the review tabs: the current one unless it is a
  -- review list, else the one recorded when a review tab took over
  back = function()
    local l = vim.fn.getqflist { nr = 0, title = 1 }
    return (l.nr > 0 and l.title ~= config.namespace) and l.nr or state.qf_back
  end,

  -- make the newest list current before adding one: adding after the current one frees every newer list.
  -- A full history (10 lists) drops the oldest on the next add: shift qf_back with it
  newest = function()
    local count = vim.fn.getqflist({ nr = "$" }).nr
    if count > 0 then vim.cmd("silent " .. count .. "chistory") end
    if count == 10 then state.qf_back = math.max(state.qf_back - 1, 0) end
  end,

  -- rebuild the quickfix history without review lists (difftool's included, changed_files titles them) and
  -- without empty untitled ones (or resession's): the history cannot delete one list. Returns the new position of list
  -- target (0: dropped or none). Vimscript: a Lua copy turns a funcref quickfixtextfunc or context into vim.NIL
  drop = function(target)
    vim.api.nvim_exec2(
      ([[
        let s:kept = []
        let s:back = 0
        for s:nr in range(1, getqflist({'nr': '$'}).nr)
          " idx 0: every item and the current index (idx N returns only item N)
          let s:l = getqflist({'nr': s:nr, 'items': 1, 'title': 1, 'context': 1, 'idx': 0, 'quickfixtextfunc': 1})
          " setqflist with nr targets that list instead of adding one
          call remove(s:l, 'nr')
          " empty: untitled ones, and resession's (it restores the current list as :setqflist())
          if s:l.title !=# '%s' && !(index(['', ':setqflist()'], s:l.title) >= 0 && empty(s:l.items))
            call add(s:kept, s:l)
            if s:nr == %d | let s:back = len(s:kept) | endif
          endif
        endfor
        " events off: each setqflist reloads an open quickfix window (BufReadPost, FileType...), ms per list;
        " the caller's :chistory redraws it once
        let s:ei = &eventignore
        " nothing kept: no :chistory follows, so free with events on (an open window empties)
        if !empty(s:kept) | set eventignore=all | endif
        call setqflist([], 'f')
        for s:l in s:kept | call setqflist([], ' ', s:l) | endfor
        let &eventignore = s:ei
        " not :echo, which a :silent caller swallows
        let g:git_review_back = s:back
        unlet! s:kept s:back s:nr s:l s:ei
      ]]):format(config.namespace, target),
      {}
    )
    local back = vim.g.git_review_back
    vim.g.git_review_back = nil
    return back
  end,

  -- quickfixtextfunc of the review list: file icon, repo-relative path, status icon
  text = function(info)
    local items = vim.fn.getqflist({ id = info.id, items = 1 }).items or {}
    local lines = {}
    for _, item in ipairs(vim.list_slice(items, info.start_idx, info.end_idx)) do
      -- quickfix.set stores the repo-relative path in module
      table.insert(lines, files.chunks_text(files.file_chunks(item.module, item.text)))
    end
    return lines
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

  -- merge-base of review r's base and compare branch, or nil after saying why
  merge_base = function(r)
    local mb = git.run({ "merge-base", r.base, r.ref or "HEAD" }, r.path)[1]
    if mb then return mb end
    -- a branch deleted since the review was opened (or saved), else unrelated histories
    for _, branch in ipairs { r.base, r.ref } do
      if not git.run({ "rev-parse", "--verify", "--quiet", branch .. "^{commit}" }, r.path)[1] then
        return vim.notify(config.messages.missing_branch:format(branch), vim.log.levels.ERROR)
      end
    end
    vim.notify(config.messages.no_merge_base:format(r.base), vim.log.levels.ERROR)
  end,

  -- worktrees of the current repo, the main one first: { path, branch? } (branch nil when detached);
  -- porcelain, so paths with spaces parse
  worktrees = function()
    local worktrees = {}
    for _, line in ipairs(git.run { "worktree", "list", "--porcelain" }) do
      local path = line:match "^worktree (.+)$"
      if path then table.insert(worktrees, { path = path }) end
      local branch = line:match "^branch refs/heads/(.+)$"
      if branch then worktrees[#worktrees].branch = branch end
    end
    return worktrees
  end,

  -- changed files of review r since merge-base mb, in tree order: { status, path, bufnr }.
  -- fugitive's difftool computes the diff and its buffers (fugitive:// blobs, or worktree files);
  -- worktree reviews add untracked files as U, which diffs never list.
  changed_files = function(r, mb)
    -- :Git uses the current buffer's repo (no -C), so run it from a scratch buffer pinned to the review's repo
    local buf, git_dir = vim.api.nvim_create_buf(false, true), vim.fn.FugitiveExtractGitDir(r.path or vim.fn.getcwd())
    vim.b[buf].git_dir = git_dir
    -- difftool adds a list: record the user's list first
    state.qf_back = quickfix.back()
    quickfix.newest()
    vim.api.nvim_buf_call(buf, function()
      -- string form: Git is -nargs=?, so vim.cmd.Git { args = {...} } fails once fugitive is loaded;
      -- ! fills the quickfix list without jumping to the first file
      -- unquoted paths: git quotes non-ASCII ones ("\303\274...") by default, which matches no file
      vim.cmd("Git! -c core.quotePath=false difftool --name-status " .. mb .. (r.ref and " " .. r.ref or ""))
    end)
    vim.api.nvim_buf_delete(buf, {})
    -- a deleted file has nothing on the compare side: show it as it was at the merge-base (read-only)
    -- through the main repo's git dir: a blob under .git/worktrees/<folder> makes gitsigns cache that folder as
    -- the repo of every file in the worktree, which then never attaches
    local main = r.repo and vim.fn.FugitiveExtractGitDir(r.repo) or git_dir
    local changed = vim.tbl_map(function(item)
      -- module is "<ref>:<path>" for blobs, empty for worktree files (only in worktree reviews, r.path)
      local path = item.module:match ":(.+)$" or vim.fs.relpath(r.path, vim.api.nvim_buf_get_name(item.bufnr))
      local bufnr = item.text == "D" and vim.fn.bufadd(vim.fn.FugitiveFind(mb .. ":" .. path, main)) or item.bufnr
      -- renames come as R<similarity> (R100): keep the letter
      return { status = item.text:sub(1, 1), path = path, bufnr = bufnr }
    end, vim.fn.getqflist())
    -- a review list: quickfix.set drops it
    vim.fn.setqflist({}, "r", { title = config.namespace })
    for _, path in
      ipairs(
        r.path and git.run({ "-c", "core.quotePath=false", "ls-files", "--others", "--exclude-standard" }, r.path) or {}
      )
    do
      -- a nested repo or a leftover submodule is listed as a folder ("inner/"): not a file to review; nor the
      -- mark of a placeholder inside the repo (a missing worktree's, until restore removes it)
      if not vim.endswith(path, "/") and vim.fs.basename(path) ~= config.placeholder_mark then
        table.insert(changed, { status = "U", path = path, bufnr = vim.fn.bufadd(r.path .. "/" .. path) })
      end
    end
    table.sort(changed, function(a, b) return files.file_order(a.path, b.path) end)
    return changed
  end,

  -- sibling folder to check ref out into, and the branch it gets; remote: ref is <remote>/<branch>, the branch
  -- drops the remote
  worktree_folder = function(ref, remote)
    local root = git.run({ "rev-parse", "--show-toplevel" })[1]
    local branch = remote and ref:match "^[^/]+/(.+)$" or ref
    -- <worktree_prefix><repo>__<branch>: sibling repos reviewing the same branch get their own folder; __ because
    -- repo and branch names may hold a single _
    local folder = branch:gsub("/", "-")
    return vim.fs.dirname(root) .. "/" .. config.worktree_prefix .. vim.fs.basename(root) .. "__" .. folder, branch
  end,

  -- check ref out into a new worktree at path as branch (see worktree_folder); true, or nil after showing git's error
  add_worktree = function(ref, branch, path)
    -- remote branch: create a local tracking branch, a worktree cannot check out <remote>/x itself
    local args = branch ~= ref and { "worktree", "add", "--track", "-b", branch, path, ref }
      or { "worktree", "add", path, ref }
    local _, out = git.run(args)
    if out.exit_status ~= 0 then return vim.notify(table.concat(out.stderr, "\n"), vim.log.levels.ERROR) end
    return true
  end,

  -- worktrees of the current repo that edit created (folder starts with config.worktree_prefix, or with
  -- git_review_ from before):
  -- { path, branch, repo }; repo is the main worktree (listed first), where remove_worktree runs git
  review_worktrees = function()
    local all = git.worktrees()
    local worktrees = {}
    for _, w in ipairs(vim.list_slice(all, 2)) do
      local name = vim.fs.basename(w.path)
      if vim.startswith(name, config.worktree_prefix) or vim.startswith(name, "git_review_") then
        table.insert(worktrees, { path = w.path, branch = w.branch or "(detached)", repo = all[1].path })
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

  -- buffers are shared by all tabs: give buf the gitsigns base of the current tab, the review merge-base
  -- if buf is one of its files, else gitsigns' default. Only calls gitsigns when the base changes, which
  -- also ends the GitSignsUpdate that change_base itself triggers
  sync_base = function(buf)
    local a = state.active[vim.api.nvim_get_current_tabpage()]
    local base = a and a.bufs[buf] and a.mb or nil
    -- kept by wipe_buffers (detached) and its file is back (g.e recreated the worktree): attach again, the
    -- GitSignsUpdate that follows syncs it
    if vim.b[buf][config.vars.detached] and vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf)) then
      vim.b[buf][config.vars.detached] = nil
      pcall(require("gitsigns").attach, buf)
      return
    end
    if vim.b[buf][config.vars.base] == base then return end
    -- change_base is a no-op until gitsigns has attached (get_hunks is nil until then), so record nothing
    -- yet: a later GitSignsUpdate applies it. Not b:gitsigns_status_dict, which attach sets earlier
    if not require("gitsigns").get_hunks(buf) then return end
    -- one change_base at a time per buffer: overlapping ones finish in any order, and the slower one's
    -- revision wins. A sync while one runs is redone when it ends
    if state.changing[buf] then
      state.changing[buf] = "again"
      return
    end
    state.changing[buf] = true
    vim.b[buf][config.vars.base] = base
    local done = function()
      local again = state.changing[buf] == "again"
      state.changing[buf] = nil
      if again and vim.api.nvim_buf_is_valid(buf) and vim.tbl_contains(vim.fn.tabpagebuflist(), buf) then
        git.sync_base(buf)
      end
    end
    -- pcall: git fails for a buffer whose worktree was removed outside nvim; a BufEnter must not error
    local ok = pcall(
      vim.api.nvim_buf_call,
      buf,
      function() require("gitsigns").change_base(base, false, vim.schedule_wrap(done)) end
    )
    if not ok then state.changing[buf] = nil end
  end,

  -- sync_base every buffer shown in the current tab
  sync_tab = function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      git.sync_base(vim.api.nvim_win_get_buf(win))
    end
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
    local changed = vim.t[config.vars.files]
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

    -- back to this window afterwards; wincmd p has no previous window in a tab a session just restored
    local editor = vim.api.nvim_get_current_win()
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
        -- a wiped buffer (:bwipeout) is gone until resume loads the review again
        if not vim.api.nvim_buf_is_valid(node.file.bufnr) then
          return vim.notify(config.messages.wiped_buffer:format(node.file.path), vim.log.levels.WARN)
        end
        local target = review.editor_window()
        if target then
          vim.api.nvim_set_current_win(target)
        else
          -- only the tree (and quickfix) left (:only, :bd): split the tree, keeping its width
          vim.cmd "rightbelow vsplit"
          vim.api.nvim_win_set_width(win, config.tree_width)
        end
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
    local group = vim.api.nvim_create_augroup(config.namespace .. "_tree_" .. buf, {})
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      callback = function(ev)
        -- BufWipeout may not fire (session loads ignore events): true deletes this autocmd
        if not vim.api.nvim_buf_is_valid(buf) then return true end
        if
          not vim.api.nvim_win_is_valid(win)
          or vim.api.nvim_win_get_buf(win) ~= buf
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
    vim.api.nvim_set_current_win(editor)
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
  {
    "stevearc/resession.nvim",
    opts = function(_, opts)
      opts.extensions = vim.tbl_extend("force", opts.extensions or {}, { [config.namespace] = {} })
      -- hooks here, not in the extension: resession loads extensions after pre_save on the first save
      local resession = require "resession"
      resession.add_hook("pre_load", session.pre_load)
      -- post_load hook, not the User ResessionLoadPost event: resession schedules that one, so the user could
      -- act on half-restored tabs first. The hook runs at the end of the load, events back on
      resession.add_hook("post_load", session.restore)
      -- resession's quickfix extension saves the current list without its title: save the user's list, never
      -- the review one (restore rebuilds it), then put it back
      resession.add_hook("pre_save", quickfix.leave)
      resession.add_hook("post_save", handlers.tab_enter)
    end,
  },
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
    -- undocumented gitsigns option: re-read the base text on every update. Without it, git.sync_base's
    -- change_base during an update gitsigns already runs (attach, tab switch) is overwritten by that update's
    -- old base text, and the file shows the wrong signs until :Gitsigns refresh. If gitsigns drops the option,
    -- that bug comes back
    opts = { _refresh_staged_on_update = true },
  },
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
