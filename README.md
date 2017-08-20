# ausmith's dotfiles

Storing my dotfiles on github is generally the right way to go.
Using what is likely an overcomplicated setup script, this repo
can do a comparison against the already setup config file that
is about to be replaced and give that info before running.

## Why do something different?

1. I wanted to store my gitconfig in github without including
settings specific to my git username
2. ...
3. Profit

## Usage

```
make help
...

make bashrc
make profile
make git
make vimrc
```

If you want to modify where the files get put, you can call the
`make` targets with a different `HOME` directory.

```
HOME=/my/special/dir make vimrc
```
