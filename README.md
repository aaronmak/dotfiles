# Dotfiles

## Installation

```shell
git clone git://github.com:aaronmak/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
rake install
```

## What they do

* .config/nvim - used for neovim configs
* .aliases - Helpful shortcuts
* .editorconfig - Configures text editor settings
-- [Documentation](https://editorconfig.org)
* .exports - Helpful exports
* .functions - Helpful functions
* .gitignore_global - Creates a global gitignore file
* .hushlogin - Disables message of the day
* .inputrc - Configures the readline library to customize the command line user interface
-- [Documentation](https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File.html)
* .screenrc - Configures your terminal screen
-- [Documentation](http://www.gnu.org/software/screen/manual/screen.html#Startup-Files)
* .zshrc - loads dotfiles and some zsh configs on zsh startup.
