# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Add `/snap/bin` to PATH for Ubuntu
export PATH="/snap/bin:$PATH";

# Add krew for kubectl plugins (https://krew.sigs.k8s.io/)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Homebrew shell completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Load the shell dotfiles, and then some:
for file in ~/.{bash_prompt,exports,aliases,functions,plugins,extras}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH


# Autoload completions
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Completions for asdf - version manager for multiple languages
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Completions for terraform
complete -o nospace -C /usr/local/bin/terraform terraform

# Load pyenv
eval "$(pyenv init -)"

# Add nix
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

# gcloud integration
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
