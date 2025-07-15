#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"

export BAT_THEME="TwoDark"
export ELECTRON_OZONE_PLATFORM_HINT=auto

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

neofetch
export PATH="$HOME/.npm-global/bin:$PATH"

alias claude="/home/creoo/.claude/local/claude"
