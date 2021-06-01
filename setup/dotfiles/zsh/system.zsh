
# export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin

export PATH=/volume/buildtools/bin:/volume/labtools/lib:/volume/labtools/bin:/volume/labtools/bin/ccc:/volume/buildtools/bin:/usr/local/bin:/volume/cross/cygnus-i386-ppc-current/bin:/usr/sbin:/volume/fwtools/fm/current:/volume/perl/bin/perl:/volume/evo/files/share/buildtools/sandbox-tools/bin:$PATH

export PATH=/volume/baas_devops/baas/baas-service/baas-cli/bin:$PATH
export PATH=$PATH:~/.dotfiles/bin

export MANPATH=~/local/man:/homes/pnh/enlightenment/man:/homes/pnh/man:/usr/man:/usr/local/man:/usr/share/man:/usr/X11R6/man:/volume/labtools/man:/volume/buildtools/man
export CVSROOT=cvs:/cvs/juniper
export CVS_RSH=ssh
export PAGER=less
export EDITOR=vim
export SHELL=/bin/zsh
# This is for prompt to stop dancing in edit pod with zsh shell
export LC_ALL=C.UTF-8

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

if [ "$TERM" = "xterm" ]
then
    export TERM=xterm-256color
fi

#setup ssh
eval `/volume/buildtools/bin/ssh-agent.sh --and-link`

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
