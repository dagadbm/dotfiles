"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Auto vim-plug installation if plugin folder isn't present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vim-Plug start
call plug#begin()

" ==> Files and Folders Navigation
Plug 'justinmk/vim-dirvish'

" ==> Window and Buffer Management
" Automaticaly resize windows to golden ratio. Used in simpler windows
Plug 'roman/golden-ratio'

" ==> UI
" Light as air status-bar
Plug 'vim-airline/vim-airline'
" Start page
Plug 'mhinz/vim-startify'

" ==> Editting
" Surround text with s motion
Plug 'tpope/vim-surround'
" Allow the . command to work on plugin actions (for surround)
Plug 'tpope/vim-repeat'
" Add commentary with gcc for line. g<b and g>b for block
Plug 'tomtom/tcomment_vim'
" Automatically find correct file indentation while respecting editor config files
Plug 'tpope/vim-sleuth'
Plug 'sgur/vim-editorconfig'
" * and # to work on visual mode
Plug 'bronson/vim-visual-star-search'
" Add additional text objects to vim
Plug 'wellle/targets.vim'
" Make vim current directory the project root
Plug 'airblade/vim-rooter'
" indentation as an object (i)
Plug 'michaeljsmith/vim-indent-object'
" Sneak anywhere using s/S
Plug 'justinmk/vim-sneak'
" Auto save buffers
Plug '907th/vim-auto-save'
" Multi cursor support
Plug 'terryma/vim-multiple-cursors'
" Tab all the things

" ==> LSP
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

" ==> Testing
Plug 'janko/vim-test'

" ==> Undo history
Plug 'mbbill/undotree'

" ==> Syntax
" Syntax pack
Plug 'sheerun/vim-polyglot'
" tmux.conf support
Plug 'tmux-plugins/vim-tmux'

" ==> Code Navigation
" Vim matchit plugin (makes % match with other tags)
Plug 'andymass/vim-matchup'
" Highlight f/F/t/T when needed
Plug 'unblevable/quick-scope'
" Show buffers on the status bar
" tagbar with lsp support
Plug 'liuchengxu/vista.vim'
" Fzf
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

" ==> Key Bindings
Plug 'tpope/vim-unimpaired'

" ==> Snippets
" Snippets database
Plug 'honza/vim-snippets'
" Snipmate dependencies
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
" VimL snippet implementation
Plug 'garbas/vim-snipmate'

" ==> Tags
Plug 'ludovicchabant/vim-gutentags'

" ==> External Integrations
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'
Plug 'roxma/vim-tmux-clipboard'
Plug 'wellle/tmux-complete.vim'

" Terminal
Plug 'wincent/terminus'

" ==> Color Schemes
Plug 'nanotech/jellybeans.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'


" Vim-Plug end
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Open new split panes to right and bottom, which feels more natural than the default
set splitbelow
set splitright

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * :checktime

" Enable filetype plugins
filetype plugin on
filetype indent on

" Allows to hide buffers instead of closing them when files are not saved
set hidden

" Turn backup and swap files off
set nobackup
set nowb
set noswapfile

" Reload when a file is changed from the outside
set autoread

" Tab completion on Vim commands with extra-Tab support
set wildmode=longest,list,full
set wildmenu

" Treat all numbers as decimals
" useful when using <C-a> and <C-x>
set nrformats=

" Fix paste on terminals with tmux (mostly happens on hyper)
" https://vi.stackexchange.com/questions/14491/strange-vim-xterm-interaction-auto-insertion-of-register-when-opening-file
set t_RS=
set t_SH=

" Disabled automatic new line comment (annoying specially when editing vimrc)
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Correct comment highlighting on coc json config file
" https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
autocmd FileType json syntax match Comment +\/\/.\+$+

" Show tabs and space
:set list
:set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»

" reduce updatetime and time to next key
set updatetime=100
set timeoutlen=500

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Maintain undo history between sessions
set undofile
set undodir=~/.vim/extra


" Always show current position
set ruler

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results when /?
set incsearch
set nohlsearch
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter [/\?] :set hlsearch
  autocmd CmdlineLeave [/\?] :set nohlsearch
augroup END

" Show matching brackets when text indicator is over them
set showmatch

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

" Remove GVIM menus
:set guioptions-=m  "menu bar
:set guioptions-=T  "toolbar
:set guioptions-=r  "right-hand scroll bar
:set guioptions-=L  "left-hand scroll bar

" Always show the status line
:set laststatus=2
" Dont show mode (handled by status line)
set noshowmode

" Set extra margin to the left side of the screen
set foldcolumn=0

" Start GVIM maximized on Windows
if(has('win32') || has('win64'))
    autocmd GUIEnter * simalt ~x
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax on

" Set background colour
set background=dark

" onedark.vim override: Don't set a background color when running in a terminal;
" just use the terminal's background color
" `gui` is the hex color code used in GUI mode/nvim true-color mode
" `cterm` is the color code used in 256-color mode
" `cterm16` is the color code used in 16-color mode
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    " `bg` will not be styled since there is no `bg` setting
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white })
  augroup END
endif

" Define colorscheme
set termguicolors
set t_Co=256
colorscheme onedark

" Define font
if has('gui_running')
    if has('unix')
        set guifont=Monaco:h10
    else
        set guifont=Consolas:h10
    endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set utf8 as standard encoding
set encoding=utf8

" Auto indent - next line in same location
set ai

" Word Wrap
set wrap

" Indent wrapped lines
set breakindent

" Set absolute and relative line numbers
set number
set relativenumber

" Use default system clipboard.
set clipboard=unnamed

" Make backspace work like most applications
set backspace=indent,eol,start

" Make ripgrep be the default vimgrep
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

set title
set titlestring=%f

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"<Leader> key avoids default vim key collision
let mapleader = "\<Space>"

" text related searches
nnoremap <Leader>/ :BLines<CR>
" Type <Leader>* to search everywhere for the selected word on normal and visual mode
nnoremap <silent> <Leader>* :Rg <C-R><C-W><CR>
xnoremap <silent> <Leader>* y:Rg <C-R>"<CR>
nnoremap <Leader>p :Files<CR>
nnoremap <Leader>P :History<CR>
nnoremap <Leader>f :Rg<CR>
" Find by filtered file type. After typing the file type just press Ctrl-e to go to end of line and type the expression you want
nnoremap <Leader>F :RgRaw -g '*'<space><Left><Left>

" vim related searches
nnoremap <Leader>. :Commands<CR>
nnoremap <Leader>: :History:<CR>
nnoremap <Leader>h :Helptags<CR>
nnoremap <Leader>m :Maps<CR>
nnoremap <Leader>t :Vista finder fzf:ctags<CR>
nnoremap <Leader>T :Vista finder fzf:coc<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>b :Buffers<CR>

" git related searches
nnoremap <Leader>gc :BCommits<CR>
nnoremap <Leader>gC :Commits<CR>
nnoremap <Leader>gf :GFiles?<CR>
nnoremap <Leader>gb :Gblame<CR>

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Keybinding

" Remap gotos with coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Use <c-e> to trigger snippet expansion
imap <C-e> <Plug>(coc-snippets-expand)

" Cursor support with <C-e>
nmap <silent> <C-e> <Plug>(coc-cursors-word)*
xmap <silent> <C-e> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn

" Use control+space to trigger completion menu
inoremap <silent><expr> <C-space> coc#refresh()

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" https://ianding.io/2019/07/29/configure-coc-nvim-for-c-c++-development/
" https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources
" use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" save
nnoremap <C-s> :w<CR>

" stop it with the annoying macro q and ex mode that I never use (re map it to <Leader> q)
noremap <Leader>q q
noremap q <Nop>
noremap q: <Nop>
noremap Q <Nop>

" Make Enter and Shift-Enter insert lines below and above
" without entering insert mode
nnoremap <CR> o<Esc>k
nnoremap <S-Enter> O<Esc>j

" Space jk for normal mode on visual mode and not on insert mode to avoid
" row selection delay in visual mode
inoremap jk <Esc>
vnoremap <Leader>jk <Esc>

" Traverse only display lines (like normal text editors)
nnoremap j gj
nnoremap k gk

" Make gm go to exact position of any mark
nnoremap gm `

"Make gM go to start of line of any mark
nnoremap gM '

" Change vim working directory to the current file dir
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Edit vimrc
nnoremap <Leader>E :edit $MYVIMRC<CR>
" Update vimrc
nnoremap <Leader>R :source $MYVIMRC<CR>

" Go to tag
nnoremap gt <C-]>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:command! -nargs=0 Tabs2Spaces :set et|retab<CR>
:command! -nargs=0 Spaces2Tabs :set noet|retab!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" coc
let g:coc_global_extensions = [
\  'coc-css',
\  'coc-dictionary',
\  'coc-docker',
\  'coc-emmet',
\  'coc-eslint',
\  'coc-html',
\  'coc-json',
\  'coc-lists',
\  'coc-prettier',
\  'coc-python',
\  'coc-sh',
\  'coc-snippets',
\  'coc-stylelint',
\  'coc-svg',
\  'coc-syntax',
\  'coc-tag',
\  'coc-tsserver',
\  'coc-vetur',
\  'coc-vimlsp',
\  'coc-webpack',
\  'coc-yaml',
\  'coc-yank',
\]

let g:coc_snippet_next = '<tab>'

" Close the preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ==> Airline
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#show_message = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1

let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#alt_sep = 0
let g:airline#extensions#tabline#buf_label_first = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline#extensions#tabline#formatter = 'short_path'
let g:airline#extensions#tabline#fnamemod = ':.'
let g:airline#extensions#tabline#fnametruncate = 10
let g:airline#extensions#tabline#fnamecollapse = 1
" I cannot get the line numbers and percentages to work correctly so I just use a static value always of max lines
let g:airline_section_z = airline#section#create(['%L', ' ☰ '])

" ==> netrw
let g:netrw_liststyle = 3

" ==> fzf related
" fzf actions similar to tmux splits
let g:fzf_action = {
\  'ctrl-t': 'tab split',
\  'ctrl-s': 'split',
\  'ctrl-v': 'vsplit',
\  'enter': 'edit',
\}

" Use fzf with_preview
"Make :Rg not show file name as results
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --follow --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:60%:hidden', '?'),
  \   <bang>0)
command! -bang -nargs=* RgRaw
  \ call fzf#vim#grep(
  \   'rg --hidden --follow --column --line-number --no-heading --color=always --smart-case '.(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:60%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:60%:hidden', '?'), <bang>0)

" floating fzf
if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --layout=reverse'

  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)

    let width = float2nr(&columns * 0.7)
    let height = float2nr(&lines * 0.7)
    let opts = { 'relative': 'editor',
          \ 'row': (&lines - height) / 2,
          \ 'col': (&columns - width) / 2,
          \ 'width': width,
          \ 'height': height,
          \ 'style': 'minimal'
          \}

    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&winhl', 'NormalFloat:TabLine')
  endfunction

  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

" ==> Gutentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root  = ['package.json', '.git', '.hg', '.svn']
let g:gutentags_cache_dir = expand('~/.gutentags_cache')
let g:gutentags_exclude_filetypes = ['gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']
let g:gutentags_ctags_exclude = [
\  '*.git', '*.svn', '*.hg',
\  'cache', 'build', 'dist', 'bin', 'node_modules', 'bower_components',
\  '*-lock.json',  '*.lock',
\  '*.min.*',
\  '*.bak',
\  '*.zip',
\  '*.pyc',
\  '*.class',
\  '*.sln',
\  '*.csproj', '*.csproj.user',
\  '*.tmp',
\  '*.cache',
\  '*.vscode',
\  '*.pdb',
\  '*.exe', '*.dll', '*.bin',
\  '*.mp3', '*.ogg', '*.flac',
\  '*.swp', '*.swo', 
\  '.DS_Store', '*.plist',
\  '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.svg',
\  '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
\  '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', '*.xls',
\]

" ==> quick-scope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ==>  Bufferline integration with airline
let g:bufferline_echo=0

" ==> Sneak
let g:sneak#label = 1
let g:sneak#s_next = 1

" ==> GitGutter
let g:gitgutter_map_keys = 0
" hunk should be h but h is very unconfortable so i am using c as in (c)hunk
" navigate through hunks with nN
" git hunk add / git hunk checkout / git hunk preview
nmap <Leader>ghn <Plug>(GitGutterNextHunk)
nmap <Leader>ghN <Plug>(GitGutterPrevHunk)
nmap <Leader>gha <Plug>(GitGutterStageHunk) 
nmap <Leader>ghr <Plug>(GitGutterUndoHunk)
nmap <Leader>ghp <Plug>(GitGutterPreviewHunk)

omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" ==> Startify
let g:startify_change_to_vcs_root = 1
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_lists = [
\ { 'type': 'sessions',  'header': ['   Sessions']       },
\ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
\ { 'type': 'files',     'header': ['   MRU']            },
\ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ { 'type': 'commands',  'header': ['   Commands']       },
\]

" ==> vim auto save
let g:auto_save = 1
