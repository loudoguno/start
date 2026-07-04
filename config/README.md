# config/ — dotfiles

Store dotfiles here **without** the leading dot:

    config/zshrc      →  ~/.zshrc
    config/gitconfig  →  ~/.gitconfig

`scripts/link-dotfiles.sh` symlinks each one into $HOME. Edit the file
here, and the live one updates instantly (it's the same file).
