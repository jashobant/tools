
alias vi='vim'
alias mymksb='/homes/jmajhi/scripts/my_mksb.sh'
alias mkcscope='/homes/jmajhi/scripts/create_cscope_db.sh'
alias b='cd /b/jmajhi/sandbox'
alias vmdisk='cd /vmm/data/user_disks/jmajhi'


# Servers
alias elpod1='ssh elpod1-vmm'
alias elpod2='ssh elpod2-vmm'
alias btpod1='ssh btpod1-vmm'
alias qpod='ssh q-pod05-vmm'
alias ubm='ssh -X contrail-ubm-jmajhi.ccp.juniper.net'
alias ubm-svl='ssh contrail-ubm-svlsupport17.ccp.juniper.net'
alias ubm-bng='ssh contrail-ubm-bngsupport10.ccp.juniper.net'
alias toby-bng='ssh ttbg-ubu16-01.juniper.net'

# Commands to jump across directories for code browsing

alias vrrp='source /homes/jmajhi/scripts/set_src.sh; cd $SRC/junos/usr.sbin/vrrpd '
alias vrrpman='source /homes/jmajhi/scripts/set_src.sh; cd $SRC/pfe/common/applications/vrrpman/ '
alias ppmd='source /homes/jmajhi/scripts/set_src.sh; cd $SRC/junos/usr.sbin/ppmd '
alias ppm='source /homes/jmajhi/scripts/set_src.sh; cd $SRC/pfe-shared/toolkits/jnx/ppm '
alias ppman='source /homes/jmajhi/scripts/set_src.sh; cd $SRC/pfe/common/applications/ppman/ '
alias ifcm='source /homes/jmajhi/scripts/set_src.sh; cd $SRC/pfe/common/applications/ifcm/ '
alias pfeman='source /homes/jmajhi/scripts/set_src.sh; cd $SRC/pfe/common/applications/pfeman/ '
alias src='source /homes/jmajhi/scripts/set_src.sh; cd $SRC '

# Router command

alias rt='/homes/jmajhi/scripts/rt'
alias rt-fpc='/homes/jmajhi/scripts/rt-fpc'
alias load-router='/homes/jmajhi/scripts/upgradeRouter.pl'
alias send-file='/homes/jmajhi/scripts/send-file'
alias rt-put='/homes/jmajhi/scripts/rt-put'

alias svn='/volume/buildtools/bin/svn'

# Aft specific
alias aft_cscope='/homes/jmajhi/scripts/create_cscope_db_aft.sh'

# Baas aliases
alias bls='baas ls'
alias blspod='baas lspod'
alias bedit='baas edit'
alias bbuild='baas build'
alias bcrtvol='baas createvol'
alias bdelvol='baas deletevol'

if [ $(uname -n) != 'editsb' ]; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi
