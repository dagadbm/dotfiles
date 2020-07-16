" Debug vim
" https://codeinthehole.com/tips/debugging-vim-by-example/

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vim-Plug start
call plug#begin()

" ==> Files and Folders Navigation
Plug 'justinmk/vim-dirvish'

" ==> Window and Buffer Management
" Automaticaly resize windows to golden ratio. Used in simpler windows
" Plug 'roman/golden-ratio'

" ==> UI
" Light as air status-bar
Plug 'vim-airline/vim-airline'
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'

" ==> Editting
" Surround text with s motion
Plug 'tpope/vim-surround'
" Allow the . command to work on plugin actions (for surround)
Plug 'tpope/vim-repeat'
" Add commentary with gcc for line. g<b and g>b for block
Plug 'tomtom/tcomment_vim'
" Automatically find correct file indentation while respecting editor config files
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sleuth'
" * and # to work on visual mode
Plug 'bronson/vim-visual-star-search'
" Add additional text objects to vim
" indentation as an object (i)
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'
Plug 'wellle/line-targets.vim'
" Make vim current directory the project root
Plug 'airblade/vim-rooter'
" Auto close tags
Plug 'alvan/vim-closetag'

Plug 'mattn/emmet-vim'

" ==> Extra vim behavior
Plug 'tpope/vim-eunuch'

" ==> LSP
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'tpope/vim-rails'

" ==> Testing
Plug 'janko/vim-test'
Plug 'tpope/vim-dispatch'

" ==> Find and Replace workflow
Plug 'jesseleite/vim-agriculture'

" ==> Undo history
Plug 'mbbill/undotree'

" ==> Session Management
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

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
" Fzf
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

" ==> Key Bindings
Plug 'tpope/vim-unimpaired'

" ==> Snippets
" Snippets database
Plug 'honza/vim-snippets'
" Snipets program
Plug 'SirVer/ultisnips'

" ==> Tags
Plug 'ludovicchabant/vim-gutentags'

" ==> External Integrations
" Git
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" Tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'
Plug 'roxma/vim-tmux-clipboard'
Plug 'wellle/tmux-complete.vim'

" Make vim color scheme integrate automatically with tmux
Plug 'edkolev/tmuxline.vim'

" Terminal
Plug 'wincent/terminus'

" ==> Color Schemes
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
" set t_RS=
" set t_SH=

" Show tabs and space
set list
set listchars=tab:→\ ,nbsp:␣,extends:»,precedes:«,trail:•

set tabstop=4

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

" Add vertical bar when reaching 80 chars
set colorcolumn=80

" Maintain undo history between sessions
set undofile
set undodir=~/.vim/undos

" Always show current position
set ruler

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results when /?
set incsearch
set nohlsearch

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Setup 256 color support
if exists('+termguicolors')
  set termguicolors
endif
set t_Co=256

let &t_ut=''
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

" ==> onedark.vim
let g:onedark_hide_endofbuffer = 1
let g:onedark_terminal_italics = 1
colorscheme onedark


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
" set clipboard=unnamed

" Make backspace work like most applications
set backspace=indent,eol,start

" Make ripgrep be the default vimgrep
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

set title
set titlestring=%f

" https://github.com/neoclide/coc-eslint/issues/28
set virtualedit=onemore

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"<Leader> key avoids default vim key collision
let mapleader = "\<Space>"

" Terminal mode
" Allow hitting <Esc> to switch to normal mode
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
" Ctrl+[hjkl] to navigate through windows in insert mode
tnoremap <buffer> <C-h> <C-\><C-n><C-w>h
tnoremap <buffer> <C-j> <C-\><C-n><C-w>j
tnoremap <buffer> <C-k> <C-\><C-n><C-w>k
tnoremap <buffer> <C-l> <C-\><C-n><C-w>l
" Simulate i_Ctrl-R
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

" change star (c*) to to something similar to multiple cursors
" Use . to repeat the motion
" Does not pollute the jump list
nnoremap c* *<C-o>cgn
nnoremap c# #<C-o>cgn

" use Q to play a macro.
" disable visual mode Q (use gQ instead)
nnoremap Q @

" Use J and K on visual mode to move the selection up or down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Mnemonics for merging conflicts (Use :Gdiffsplit on conflicting file)
" H is left side, L is right side (similar to vim hjkl motions)
" left side is the target branch (where HEAD points to), the active branch you are merging into
" right side is the merge branch passed onto the git merge command
nmap <leader>gdh d2o
nmap <leader>gdl d3o

" text related searches
nnoremap <Leader>/ :FzfBLines<CR>
" Type <Leader>* to search everywhere for the selected word on normal and visual mode
nnoremap <silent> <Leader>* :FzfRg <C-R><C-W><CR>
xnoremap <silent> <Leader>* y:FzfRg <C-R>"<CR>
" Type <Leader>+ to search on the current buffer for the selected word on normal and visual mode
nnoremap <silent> <Leader>+ :FzfBLines <C-R><C-W><CR>
xnoremap <silent> <Leader>+ y:FzfBLines <C-R>"<CR>
nnoremap <Leader>p :FzfFiles<CR>
" Type <Leader>P to search for files with the content off the selected word on normal mode
nnoremap <silent> <Leader>P :call fzf#vim#files('.', {'options':'--query '.expand('<cword>')})<CR>
nnoremap <Leader>f :FzfRg<CR>
" Find by filtered file type. After typing the file type just press Ctrl-e to go to end of line and type the expression you want
nnoremap <Leader>F :RgRaw -t<space><left>

" vim related searches
nnoremap <Leader>. :FzfCommands<CR>
nnoremap <Leader>: :FzfHistory:<CR>
nnoremap <Leader>h :FzfHelptags<CR>
nnoremap <Leader>H :FzfHistory<CR>
nnoremap <Leader>m :FzfMaps<CR>
nnoremap <Leader>w :FzfWindows<CR>
nnoremap <Leader>b :FzfBuffers<CR>

" git related searches
nnoremap <Leader>gc :FzfBCommits<CR>
nnoremap <Leader>gC :FzfCommits<CR>
nnoremap <Leader>gf :FzfGFiles?<CR>

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <c-e> for multiple cursor
nmap <expr> <silent> <C-e> <SID>select_current_word()
function! s:select_current_word()
if !get(g:, 'coc_cursors_activated', 0)
  return "\<Plug>(coc-cursors-word)"
endif
return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

" Use leader-e to use operations on cursor as a text object
nmap <leader>e  <Plug>(coc-cursors-operator)

" Keybinding

" I cant fix this pesky floating window bug I have
" This is a workaround copied from a coc function that does the same
nnoremap <silent> ~~ :call <SID>close_all_floating_windows()<CR>
inoremap ~~ <Esc>~~
function! s:close_all_floating_windows()
  if has('nvim')
    let exists = exists('*nvim_win_get_config')
    for id in nvim_list_wins()
      if exists
        if !empty(nvim_win_get_config(id)['relative'])
          call nvim_win_close(id, 1)
        endif
      else
        if getwinvar(id, 'float', 0)
          call nvim_win_close(id, 1)
        endif
      endif
    endfor
  elseif exists('*popup_clear')
    call popup_clear()
  endif
endfunction

" Since Tab and Ctrl-I are interchaneable in vim i need to map Ctrl-l to serve as a workaround of ctrl-i
nnoremap <A-o> <C-i>

" Remap gotos with coc
nmap <silent> <leader>cgd <Plug>(coc-definition)
nmap <silent> <leader>cgD <Plug>(coc-declaration)
nmap <silent> <leader>cgt <Plug>(coc-type-definition)
nmap <silent> <leader>cgi <Plug>(coc-implementation)
nmap <silent> <leader>cgr <Plug>(coc-references)

" Activate diagnostic error message with keybinding!
nmap <silent> <leader>cp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>cn <Plug>(coc-diagnostic-next)
nmap <silent> <leader>ci <Plug>(coc-diagnostic-info)
nmap <silent> <leader>cf <Plug>(coc-fix-current)
nmap <silent> <leader>ca <Plug>(coc-codeaction-selected)
vmap <silent> <leader>ca <Plug>(coc-codeaction-selected)
nmap <silent> <leader>cA <Plug>(coc-codeaction)
nmap <silent> <leader>co <Plug>(coc-action-organizeImport)
nmap <silent> <leader>cr <Plug>(coc-refactor)

" formaT selection and entire file
vmap <silent> <leader>ct <Plug>(coc-format-selected)
nmap <silent> <leader>ct <Plug>(coc-format-selected)
nmap <silent> <leader>cT <Plug>(coc-format)

" Use control+space and C-X (vim default mode) to trigger completion menu
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
" use <tab> for trigger completion and snippets and navigate to the next complete item
" https://github.com/neoclide/coc-snippets
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" use enter to accept auto completion
inoremap <silent><expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" Close the preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ==> GitGutter
let g:gitgutter_map_keys = 0
nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPrevHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)
nmap <Leader>ga <Plug>(GitGutterStageHunk)
nmap <Leader>gi <Plug>(GitGutterPreviewHunk)

omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)


" User leader s/S to save save all buffers
nnoremap <Leader>s :w<CR>
nnoremap <Leader>S :wa<CR>

" Make Enter and Shift-Enter insert lines below and above
" without entering insert mode
nnoremap <CR> o<Esc>k
nnoremap <S-Enter> O<Esc>j

" jk to quit to normal mode
tnoremap <buffer> jk <C-\><C-n>
inoremap jk <Esc>
inoremap jk <Esc>
inoremap jk <Esc>

" Traverse only display lines (like normal text editors)
nnoremap j gj
nnoremap k gk

" Make gm go to exact position of any mark
nnoremap gm `

"Make gM go to start of line of any mark
nnoremap gM '

" Update vimrc
nnoremap <Leader>R :source $MYVIMRC<CR>

" Go to tag (use h instead of t so I dont lose tab navigation by number e.g. 1gt, 2gt, etc)
nnoremap gh <C-]>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:command! -nargs=0 Tabs2Spaces :set et|retab<CR>
:command! -nargs=0 Spaces2Tabs :set noet|retab!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Auto Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disabled automatic new line comment (annoying specially when editing vimrc)
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Correct comment highlighting on coc json config file
" https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
autocmd FileType json syntax match Comment +\/\/.\+$+

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_snippet_next = '<tab>'

" Close the preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ==> Airline
let g:airline_theme='onedark'

let g:airline_powerline_fonts = 1

let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#vista#enabled = 0

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#show_message = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1

let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tab_count = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#alt_sep = 1
let g:airline#extensions#tabline#buf_label_first = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline#extensions#tabline#formatter = 'short_path'
let g:airline#extensions#tabline#fnamemod = ':.'
let g:airline#extensions#tabline#fnametruncate = 10
let g:airline#extensions#tabline#fnamecollapse = 1


let g:airline_section_x = airline#section#create_right(['bookmark', 'tagbar', 'gutentags', 'grepper'])
let g:airline_section_y = ''
let g:airline_section_z = airline#section#create(['%3p%% ☰  %l/%L  : %c'])

" ==> netrw
let g:netrw_liststyle = 3

" ==> fzf related
let $FZF_DEFAULT_OPTS .= ' --layout=reverse'
let g:fzf_command_prefix = 'Fzf'
let g:fzf_preview_window = 'right:60%:hidden'
" fzf actions similar to tmux splits
let g:fzf_action = {
\  'ctrl-t': 'tab split',
\  'ctrl-s': 'split',
\  'ctrl-v': 'vsplit',
\}

" Use fzf with_preview
"Make :Rg not show file name as results
command! -bang -nargs=* FzfRg
  \ call fzf#vim#grep(
  \   'rg --follow --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:60%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir FzfFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:60%:hidden', '?'), <bang>0)

" floating fzf
" Required:
" - width [float range [0 ~ 1]]
" - height [float range [0 ~ 1]]
" Optional:
" - xoffset [float default 0.5 range [0 ~ 1]]
" - yoffset [float default 0.5 range [0 ~ 1]]
" - highlight [string default 'Comment']: Highlight group for border
" - border [string default 'rounded']: Border style
"   - 'rounded' / 'sharp' / 'horizontal' / 'vertical' / 'top' / 'bottom' / 'left' / 'right'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8, 'xoffset': 0.5, 'yoffset': 0.2, 'border': 'rounded' } }

" ==> Gutentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root  = ['package.json', '.git', '.hg', '.svn']
let g:gutentags_cache_dir = expand('~/.gutentags_cache')
let g:gutentags_exclude_filetypes = ['gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git', 'term', 'fzf']
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

" BufKill
let g:BufKillCreateMappings = 0

" Session Management
let g:prosession_dir = '~/.vim/sessions/'
let g:prosession_on_startup = 1
let g:prosession_per_branch = 1

" Terminal
let g:disable_key_mappings = 0

" Animate buffer resizes
let g:lens#height_resize_max = 100
let g:lens#height_resize_min = 10
let g:lens#width_resize_max = 100
let g:lens#width_resize_min = 20

" Find and replace workflow
let g:rg_command = 'rg --vimgrep -S'

" EditorConfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" vim-test
let test#strategy = "dispatch"
let g:test#javascript#jest#options = '--reporters jest-vim-reporter'

" vim-go
let g:go_def_mapping_enabled = 0

" vim-rooter
" Manually run :Rooter to find project dir
let g:rooter_manual_only = 1

" Make tab of coc work together with ulti snips
let g:UltiSnipsExpandTrigger = "<NUL>"