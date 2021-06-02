local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} '
# PROMPT='[%{$fg[cyan]%}%c%{$reset_color%}] '
# RPROMPT='%B%F{208}%n%f%{$fg_bold[white]%}@%F{039}%m%f%{$reset_color%}'
# RPROMPT='[%*]'
RPROMPT='[%B%F{039}%m%f]%{$reset_color%}'
