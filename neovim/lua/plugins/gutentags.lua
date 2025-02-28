return {
  {
    'ludovicchabant/vim-gutentags',
    event = 'VeryLazy',
    config = function ()
      -- https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
      -- https://github.com/ludovicchabant/vim-gutentags/issues/178#issuecomment-575693926
      vim.g.gutentags_ctags_exclude = {
        '*.git', '*.svn', '*.hg',
        'cache', 'build', 'dist', 'bin', 'node_modules', 'bower_components',
        '*-lock.json',  '*.lock',
        '*.min.*',
        '*.bak',
        '*.zip',
        '*.pyc',
        '*.class',
        '*.sln',
        '*.csproj', '*.csproj.user',
        '*.tmp',
        '*.cache',
        '*.vscode',
        '*.pdb',
        '*.exe', '*.dll', '*.bin',
        '*.mp3', '*.ogg', '*.flac',
        '*.swp', '*.swo',
        '.DS_Store', '*.plist',
        '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.svg',
        '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
        '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', '*.xls',
      }
      vim.g.gutentags_exclude_filetypes = {
        'gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git'
      }

      vim.g.gutentags_add_default_project_roots = false
      vim.g.gutentags_project_root = {
        '.git', '.hg', '.svn'
      }
      vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/nvim/gutentags')
      vim.g.gutentags_generate_on_new = true
      vim.g.gutentags_generate_on_missing = true
      vim.g.gutentags_generate_on_write = true
      vim.g.gutentags_generate_on_empty_buffer = true
      vim.g.gutentags_background_update = true
      vim.g.gutentags_ctags_extra_args = {'--tag-relative=yes', '--fields=+ailmnS', }
    end
  },
}
