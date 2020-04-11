# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

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

# Completions for asdf - version manager for multiple languages
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
