# My Dotfiles
Thank you [https://github.com/dreamsofautonomy] for delivering good way to backup my DotFiles

## Requirements
Ensure you have the following installed on your system

### Git

```
pacman -S git
```

### Stow

```
pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com:Hummr01/.dotfiles.git
$ cd .dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```
