# Add `~/bin` to the `$PATH`
export PATH="/usr/local/bin:$PATH";
export PATH="/usr/local/sbin:$PATH"

# history options
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# Add `/snap/bin` to PATH for Ubuntu
export PATH="/snap/bin:$PATH";

# Add krew for kubectl plugins (https://krew.sigs.k8s.io/)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Homebrew shell completions
if type brew &>/dev/null; then
  # Add gnu coreutils to path. Utils are prefixed with `g`
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Load the shell dotfiles, and then some:
for file in ~/.{bash_prompt,exports,aliases,functions,extras}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH


# Autoload completions
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Completions for terraform
complete -o nospace -C /usr/local/bin/terraform terraform

# Add nix
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

# gcloud integration
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi

# python poetry
export PATH="$HOME/.poetry/bin:$PATH"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"

# Load asdf command
export ASDF_DIR="${HOME}/.asdf"

if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
    . "$ASDF_DIR/asdf.sh"

    # Load completions
    if [[ -f "$ASDF_COMPLETIONS/asdf.bash" ]]; then
        . "$ASDF_COMPLETIONS/asdf.bash"
    fi
fi

if type brew &>/dev/null; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  if [[ -f "$(brew --prefix)/etc/profile.d/z.sh" ]]; then
    . $(brew --prefix)/etc/profile.d/z.sh
  fi
fi

# setup ssh-agent
SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
