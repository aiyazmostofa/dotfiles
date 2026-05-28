fish_add_path --path --append "$HOME/.local/bin"
fish_add_path --path --append /home/linuxbrew/.linuxbrew/bin
if not contains /home/linuxbrew/.linuxbrew/share "$XDG_DATA_DIRS"
    set -gx XDG_DATA_DIRS (string join : "$XDG_DATA_DIRS" /home/linuxbrew/.linuxbrew/share)
end

set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"

if test "$INSIDE_EMACS" = "vterm"
    and set -q EMACS_VTERM_PATH
    and test -f "$EMACS_VTERM_PATH/etc/emacs-vterm.fish"
    source "$EMACS_VTERM_PATH/etc/emacs-vterm.fish"
end
