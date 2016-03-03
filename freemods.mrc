; *NOT* Completed ~ lots more to add. Menus, /fhelp...
; freemods.mrc ~ Sebastien ~ ##Sebastien @ freenode
;
; This script is based on autobleh.mrc by KindOne
; and autobleh.mrc is based on the irssi version - http://autobleh.projectnet.org/ 
;
; All you need to do, is edit the op-pls alias
; 
; /fq <nick>                   (mute *!*@host.name)
; /fuq <nick>                  (unmute *!*@host.name)
; /fmq <nick!user@host.name>   (mute *!*@host.name manually)
; /fmuq <nick!user@host.name>  (unmute *!*@host.name manually)
; /fr <nick>                   (remove <nick>)

; Edit this alias, with the services op request command.
; Example:   cs op $chan  or msg x op $chan. (network specific)
alias -l op-pls { .cs op $chan }

; DO NOT touch anything else, you WILL fuck it up.
on *:op:#:{ 
  if ($opnick == $me) { 
    if (%rekt2) { %rekt1 | %rekt2 | .timer 1 1 unset %rekt1 | .timer 1 1 unset %rekt2 }
    if (%rekt1) { %rekt1 | .timer 1 1 unset %rekt1 }
  } 
}

alias fr { 
  if ($me isop $chan) { .raw remove $chan $1 :Did you see what you made me do. }
  else { set %rekt1 .raw remove $chan $1 :Did you see what you made me do. | set %rekt2 mode $chan -o $me | op-pls } 
}

alias fq { 
  if ($me isop $chan) { mode $chan +q $address($1,2) }
  else { set %rekt1 mode $chan +q-o $address($1,2) $me | op-pls } 
}

alias fuq { 
  if ($me isop $chan) { mode $chan -q $address($1,2) }
  else { set %rekt1 mode $chan -qo $address($1,2) $me | op-pls } 
}

alias fmq { 
  if ($me isop $chan) { mode $chan +q $1 }
  else { set %rekt1 mode $chan +q-o $1 $me | op-pls } 
}

alias fmuq { 
  if ($me isop $chan) { mode $chan -q $1 }
  else { set %rekt1 mode $chan -qo $1 $me | op-pls } 
}
