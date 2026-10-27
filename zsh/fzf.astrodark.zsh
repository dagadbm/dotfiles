# astrodark theme, derived
# legend: <palette key>: <variables set>
# syntax.text: fzf_fg, fzf_query
# ui.text_active: fzf_fg_plus
# ui.base: fzf_bg, fzf_gutter
# ui.current_line: fzf_bg_plus
# ui.border: fzf_border, fzf_info
# syntax.blue: fzf_accent, fzf_hl, fzf_hl_plus, fzf_marker, fzf_pointer, fzf_prompt, fzf_spinner
# ui.accent: fzf_header
fzf_fg='#ADB0BB'
fzf_fg_plus='#ADB0BB'
fzf_bg='#1A1D23'
fzf_bg_plus='#1E222A'
fzf_gutter='#1A1D23'
fzf_border='#3A3E47'
fzf_accent='#5EB7FF'
fzf_hl=$fzf_accent
fzf_hl_plus=$fzf_accent
fzf_marker=$fzf_accent
fzf_pointer=$fzf_accent
fzf_prompt=$fzf_accent
fzf_spinner=$fzf_accent
fzf_header='#50A4E9'
fzf_info='#3A3E47'
fzf_query='#ADB0BB'

export FZF_THEME=" \
  --color=fg:$fzf_fg,bg:$fzf_bg,hl:$fzf_hl,gutter:$fzf_gutter \
  --color=fg+:$fzf_fg_plus,bg+:$fzf_bg_plus,hl+:$fzf_hl_plus \
  --color=info:$fzf_info,prompt:$fzf_prompt,pointer:$fzf_pointer,query:${fzf_query}:regular \
  --color=marker:$fzf_marker,spinner:$fzf_spinner,header:$fzf_header \
  --color=border:$fzf_border,separator:$fzf_border,scrollbar:$fzf_border"
