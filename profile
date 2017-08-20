export CLICOLOR=1

# Pull the git-completion.bash file from the contrib dir in git/git repo.
source ~/.git-completion.bash

# Pull the git-prompt.sh file from the contrib dir in git/git repo.
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true

# Colors
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
NO_COLOUR="\[\033[0m\]"

# to get the ruby version from rvm # $LIGHT_GRAY\$(~/.rvm/bin/rvm-prompt i v g)$NO_COLOUR
PS1="$RED[\t]$NO_COLOUR $GREEN\u@\h$NO_COLOUR:\w$YELLOW\$(__git_ps1)$NO_COLOUR\n\$ "

export EDITOR="vim"

# Add color to ls and give ll alias
alias ls='ls -GFh'
alias ll='ls -l'

# Add bundle search `brag`
alias brag='bundle show --paths | xargs ag'

# For rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Set Java Home -> initially for ec2 tools
export JAVA_HOME=$(/usr/libexec/java_home)

# Just EC2 tools
export EC2_HOME=/usr/local/ec2/ec2-api-tools-1.7.2.0
export PATH="$PATH:$EC2_HOME/bin"

# Update all repos in current directory, may want to alias??
# find . -type d -depth 2 -name '.git' -exec git --git-dir={} --work-tree=$PWD/{}/.. checkout master \;
# find . -type d -depth 2 -name '.git' -exec git --git-dir={} --work-tree=$PWD/{}/.. pull dev master \;

# Starts up the docker based dev environment
alias devenv="docker exec --user=${USER} -it dev bash"

# klusters for determining what kubernetes clusters are available
alias klusters="kubectl config get-contexts | tr -s ' ' | cut -d ' ' -f 2 | sort"
