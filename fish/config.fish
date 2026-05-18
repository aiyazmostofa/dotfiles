fish_add_path --path --append $HOME/.local/bin
if not contains /home/linuxbrew/.linuxbrew/share $XDG_DATA_DIRS
    set -gx XDG_DATA_DIRS (string join : $XDG_DATA_DIRS /home/linuxbrew/.linuxbrew/share)
end

if test "$INSIDE_EMACS" = "vterm"
    and set -q EMACS_VTERM_PATH
    and test -f "$EMACS_VTERM_PATH/etc/emacs-vterm.fish"
    source "$EMACS_VTERM_PATH/etc/emacs-vterm.fish"
end
