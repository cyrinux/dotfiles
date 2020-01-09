. /usr/share/zsh/share/antigen.zsh

antigen use prezto

antigen bundles <<EOB
  peikk0/tmux-cssh
  MichaelAquilina/zsh-autoswitch-virtualenv
  robbyrussell/oh-my-zsh plugins/encode64
  robbyrussell/oh-my-zsh plugins/fancy-ctrl-z
  hlissner/zsh-autopair
  aperezdc/zsh-fzy
  marzocchi/zsh-notify
  rupa/z
  changyuheng/fz
  Tarrasch/zsh-bd
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-history-substring-search
  mafredri/zsh-async
EOB

antigen theme romkatv/powerlevel10k

antigen apply
