# Oh my Zsh config.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ibricchi"
plugins=()
source $ZSH/oh-my-zsh.sh

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

alias rz="source ~/.zshrc"

# load cargo environment
. $HOME/.cargo/env

# source fzf
source <(fzf --zsh)

# rgf will search for $1 and pass the rest of the arguments to rg
# it will format the output to be <file>:line_number:line_content: matching_line
# fzf should just print the selected file on stdout
# Usage: rgf <search_term> [rg_args...]
function rgf() {
    if [[ -z "$1" ]]; then
        echo "Usage: rgf <search_term> [rg_args...]"
        return 1
    fi

    local search_term="$1"
    shift  # Remove the first argument (search term) from the list

    rg --hidden --line-number --color=always "$search_term" "$@" --no-heading \
        | fzf --ansi --bind "enter:become(echo {+} | cut -d: -f-2)" \
}

# source gobi
source <(gobi_cli shellrc zsh)
