alias p="ps -ewwo stat,user,pid,pcpu,vsize,cmd --sort=pcpu,vsize"
HISTSIZE= 
HISTFILESIZE=
shopt -s histappend
PROMPT_COMMAND="history -a; history -n;$PROMPT_COMMAND"
