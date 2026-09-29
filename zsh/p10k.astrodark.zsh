# powerlevel10k astrodark theme
# colorscheme taken from ~/.local/share/nvim-astrovim/lazy/astrotheme/lua/astrotheme/palettes/astrodark.lua
# overrides colors from p10k.zsh and p10k.mise.zsh, so source it after both
() {
  # palette
  local red='#FF838B'       # syntax.red
  local orange='#F5983A'    # syntax.orange
  local yellow='#DFAB25'    # syntax.yellow
  local green='#87C05F'     # syntax.green
  local cyan='#4AC2B8'      # syntax.cyan
  local blue='#5EB7FF'      # syntax.blue
  local purple='#DD97F1'    # syntax.purple
  local accent='#50A4E9'    # ui.accent
  local text='#ADB0BB'      # syntax.text
  local comment='#696C76'   # syntax.comment
  local mute='#595C66'      # syntax.mute
  local border='#3A3E47'    # ui.border

  # ruler / multiline gap
  typeset -g POWERLEVEL9K_RULER_FOREGROUND=$border
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=$border

  # prompt_char
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$green
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$red

  # dir
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$accent
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$comment
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$blue

  # vcs (P10K_GIT_* are read by my_git_formatter in p10k.zsh)
  typeset -g P10K_GIT_META_COLOR=$text
  typeset -g P10K_GIT_CLEAN_COLOR=$green
  typeset -g P10K_GIT_MODIFIED_COLOR=$yellow
  typeset -g P10K_GIT_UNTRACKED_COLOR=$blue
  typeset -g P10K_GIT_CONFLICTED_COLOR=$red
  typeset -g P10K_GIT_LOADING_COLOR=$mute
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$green
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=$mute
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$green
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$green
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$yellow

  # status
  typeset -g POWERLEVEL9K_STATUS_{OK,OK_PIPE}_FOREGROUND=$green
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_FOREGROUND=$red

  # command_execution_time / background_jobs
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$yellow
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$cyan

  # mise (p10k.mise.zsh)
  typeset -g POWERLEVEL9K_MISE_FOREGROUND=$cyan
  typeset -g POWERLEVEL9K_MISE_RUBY_FOREGROUND=$red
  typeset -g POWERLEVEL9K_MISE_PYTHON_FOREGROUND=$yellow
  typeset -g POWERLEVEL9K_MISE_GOLANG_FOREGROUND=$cyan
  typeset -g POWERLEVEL9K_MISE_NODEJS_FOREGROUND=$green
  typeset -g POWERLEVEL9K_MISE_RUST_FOREGROUND=$orange
  typeset -g POWERLEVEL9K_MISE_DOTNET_CORE_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_MISE_FLUTTER_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_MISE_LUA_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_MISE_JAVA_FOREGROUND=$orange
  typeset -g POWERLEVEL9K_MISE_PERL_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_MISE_ERLANG_FOREGROUND=$red
  typeset -g POWERLEVEL9K_MISE_ELIXIR_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_MISE_POSTGRES_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_MISE_PHP_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_MISE_HASKELL_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_MISE_JULIA_FOREGROUND=$green

  # cloud / infra
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_TERRAFORM_VERSION_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=$orange
  typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND=$green
  typeset -g POWERLEVEL9K_AZURE_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_TOOLBOX_FOREGROUND=$yellow

  # context (user@hostname)
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$red
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=$text
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=$text

  # shells / file managers
  typeset -g POWERLEVEL9K_NORDVPN_FOREGROUND=$blue
  typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=$cyan
  typeset -g POWERLEVEL9K_RANGER_FOREGROUND=$yellow
  typeset -g POWERLEVEL9K_{NNN,LF,XPLR}_FOREGROUND=$cyan
  typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=$green
  typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND=$yellow
  typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=$blue

  # task tracking
  typeset -g POWERLEVEL9K_{TODO,TIMEWARRIOR,TASKWARRIOR}_FOREGROUND=$comment

  # time
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$comment

  # If p10k is already loaded, reload configuration.
  (( ! $+functions[p10k] )) || p10k reload
}
