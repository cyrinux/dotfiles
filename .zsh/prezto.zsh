zstyle ':prezto:*:*' color 'yes'

zstyle ':prezto:module:editor' dot-expansion 'yes'

zstyle ':prezto:load' pmodule \
  'environment' \
  'editor'      \
  'history'     \
  'directory'   \
  'completion'  \
  'rsync'  \
  'docker'  \
  'archive'

zstyle ':prezto:module:ruby:chruby' auto-switch 'yes'
