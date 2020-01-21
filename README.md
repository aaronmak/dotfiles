# Dotfiles

To make it more modular, the `.bash_prompt`, `.functions`, `.exports` and
`.aliases` are in different dotfiles but they are called in `.zshrc`.

Some of the dotfiles are dependent on https://github.com/aaronmak/mac-setup.

## Installation

```shell
git clone git://github.com:aaronmak/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
rake install
```

For `ssh_config`, refer to this [repo](https://github.com/aaronmak/ssh-config).

Don't forget to add your gpg and ssh keys before proceeding.
