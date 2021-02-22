# Add `~/bin` to the `$PATH`
export PATH="/usr/local/bin:$PATH";
export PATH="/usr/local/sbin:$PATH"

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

eval "$(starship init zsh)"
