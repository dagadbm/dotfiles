# Dotfiles
Remove emacs once and for all accept the vim master race
# MacOS
investigate this: https://github.com/agenttank/dotfiles_macos
# Alfred alternatives
https://www.raycast.com/
## tiling window managers
https://github.com/koekeishiya/yabai
https://www.raycast.com/core-features/window-management
https://rectangleapp.com/
https://github.com/nikitabobko/AeroSpace
https://github.com/MrKai77/Loop
https://github.com/ianyh/Amethyst
## shift it et al.
https://github.com/fikovnik/ShiftIt
https://github.com/fikovnik/ShiftIt/wiki/The-Hammerspoon-Alternative
http://www.hammerspoon.org/
https://github.com/peterklijn/hammerspoon-shiftit
https://deniz.co/penc/

# Vim 
## Tutorials
https://github.com/mhinz/vim-galore -> seems like a really in depth tutorial of vim
## Find and Replace
https://www.mattlayman.com/blog/2019/supercharging-vim-blazing-fast-search/ -> article about quickfix reflector
https://github.com/stefandtw/quickfix-reflector.vim -> this is to be used with other alternatives as it allows to make the quick fix list writable!
https://github.com/mhinz/vim-grepper -> together with the above might be a nice solution
https://github.com/dyng/ctrlsf.vim#quick-start -> this is a all in one plugin for searching and replacing
https://github.com/brooth/far.vim -> same as above
https://github.com/nickjj/dotfiles/blob/master/.vimrc -> this guy uses vim-grepper and some other crazy key bindings (maybe could be made easier if he used quickfix-reflector
## Git integration
https://github.com/lambdalisue/gina.vim  -> new stuff!! seems promising
https://github.com/jreybert/vimagit
https://github.com/airblade/vim-gitgutter
https://github.com/mhinz/vim-signify
https://github.com/neoclide/coc-git -> maybe delete this dependency as well and let COC just handle LSP stuff and not really git stuff
Start adding shortcuts to <Leader>g (g for git)
https://github.com/sindrets/diffview.nvim
## Floating windows
https://github.com/liuchengxu/vim-clap -> maybe this can be used to replace fzf window code on my vimrc?
## Testing!
https://github.com/janko/vim-test -> This sounds AMAZING
## MRU
https://github.com/ctrlpvim/ctrlp.vim -> maybe just user ctrlP for this and let fzf do everything else
## Start up screen
https://github.com/mhinz/vim-startify
## More tmux goodness
https://github.com/benmills/vimux -> not sure if this will be what i want but its nice that it can also run tests. maybe good together with vim-test ?
## fzf/coc love
https://github.com/dominickng/fzf-session.vim
https://github.com/antoinemadec/coc-fzf/
https://github.com/iamcco/coc-actions
## Ranger
https://tzutalin.blogspot.com/2019/04/install-rangervim-based-file-manager-on.html
## Which key
https://github.com/liuchengxu/vim-which-key

## Interesting dotfiles to learn from
https://github.com/ChristianChiarulli/nvim
https://www.chrisatmachine.com/neovim


# Tmux
https://www.reddit.com/r/neovim/comments/aex45u/integrating_nvr_and_tmux_to_use_a_single_tmux_per/
## Tmux alternatives
http://www.brain-dump.org/projects/abduco/ for session storage
http://www.brain-dump.org/projects/dvtm/ for tiling window
# icons!  https://coreyja.com/vim-fzf-with-devicons/ # asdf
Configure asdf for python and node!

# Related
https://gist.github.com/romainl/4b9f139d2a8694612b924322de1025ce

# ASDF

we cannot upgrade to v0.16.0 yet a couple of things must happen in terms of issues and compat with asdf-direnv and other things.
I am forcing the version on the git submodule for now.
When this is all ready and fun we can start using asdf on brew
