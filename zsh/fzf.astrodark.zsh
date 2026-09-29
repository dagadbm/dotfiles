# fzf astrodark theme
# colorscheme taken from ~/.local/share/nvim-astrovim/lazy/astrotheme/extras/fzf/astrodark.sh
# palette: ~/.local/share/nvim-astrovim/lazy/astrotheme/lua/astrotheme/palettes/astrodark.lua
fzf_fg='#ADB0BB'          # syntax.text
fzf_fg_plus='#ADB0BB'     # ui.text_active
fzf_bg='#1A1D23'          # ui.base
fzf_bg_plus='#1E222A'     # ui.current_line
fzf_gutter='#1A1D23'      # ui.base
fzf_border='#3A3E47'      # ui.border
fzf_accent='#5EB7FF'      # syntax.blue
fzf_hl=$fzf_accent
fzf_hl_plus=$fzf_accent
fzf_marker=$fzf_accent
fzf_pointer=$fzf_accent
fzf_prompt=$fzf_accent
fzf_spinner=$fzf_accent
fzf_header='#50A4E9'      # ui.accent
fzf_info='#3A3E47'        # ui.border
fzf_query='#ADB0BB'       # syntax.text

export FZF_THEME=" \
  --color=fg:$fzf_fg,bg:$fzf_bg,hl:$fzf_hl,gutter:$fzf_gutter \
  --color=fg+:$fzf_fg_plus,bg+:$fzf_bg_plus,hl+:$fzf_hl_plus \
  --color=info:$fzf_info,prompt:$fzf_prompt,pointer:$fzf_pointer,query:${fzf_query}:regular \
  --color=marker:$fzf_marker,spinner:$fzf_spinner,header:$fzf_header \
  --color=border:$fzf_border,separator:$fzf_border,scrollbar:$fzf_border"
