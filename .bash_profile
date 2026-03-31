export EDITOR=nvim
export TERMINAL=st
export XCURSOR_SIZE=16
export XCURSOR_THEME=Adwaita
export PATH="$PATH:~/.local/bin"
#export QT_QPA_PLATFORMTHEME=gnome
export BAT_THEME=gruvbox-dark

[[ -f ~/.bashrc ]] && . ~/.bashrc

# opam configuration
test -r /home/qyrhx/.opam/opam-init/init.sh && . /home/qyrhx/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
