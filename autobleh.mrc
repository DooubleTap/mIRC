; mIRC autobleh - Updated: Jan 1, 2016 
; Created by KindOne - irc.freenode.net ##kindone
; This script is based on the irssi version (Credits for them. Awesome script)  - http://autobleh.projectnet.org/ 

; Syntax:

; /fb KindOne       - Ban
; /fk KindTwo       - Kick
; /fq MeanOne       - Quiet on hostmask/cloak - (charybdis)
; /fr EvilOne       - Remove - (charybdis)
; /fbk lolwut       - Kick/Ban on hostmask/cloak
; /fbr ChanServ     - Remove/Ban on hostmask/cloak

alias fb { 
  if ($me isop $chan) { mode $chan +b $address($1,2) } 
  else { set %command_1 mode $chan +b-o $address($1,2) $me | get_op }
}

alias fk { 
  if ($me isop $chan) { kick $chan $1 Did you see what you made me do. } 
  else { 
    set %command_1 kick $chan $1 Did you see what you made me do.
    set %command_2 mode $chan -o $me
    get_op 
  }
}

alias fq { 
  if ($me isop $chan) { mode $chan +q $address($1,2) }
  else { set %command_1 mode $chan +q-o $address($1,2) $me | get_op } 
}

alias fbr { 
  if ($me isop $chan) { 
    mode $chan +b $address($1,2) $+ $chr(36) $+ ##arguments
    .raw remove $chan $1 :Did you see what you made me do. 
  }
  else {  
    set %command_1  mode $chan +b $address($1,2) $+ $chr(36) $+ ##arguments
    set %command_2  .raw remove $chan $1 :Did you see what you made me do. 
    set %command_3  mode $chan -o $me 
    get_op
  }
}

alias fbk { 
  if ($me isop $chan) { 
    mode $chan +b $address($1,2)
    kick $chan $1 Did you see what you made me do.
  }
  else { 
    set %command_1 mode $chan +b $address($1,2)
    set %command_2 kick $chan $1 Did you see what you made me do.
    set %command_3 mode $chan -o $me 
    get_op
  }
}

alias fr { 
  if ($me isop $chan) { .raw remove $chan $1 :Did you see what you made me do. }
  else { set %command_2 .raw remove $chan $1 :Did you see what you made me do. | get_op }
}


on me:*:op:#:{ 
  if (%command_1) {
    %command_1 
    %command_2 
    %command_3
    unset %command_1 
    unset %command_2 
    unset %command_3
  }
}

alias -l get_op { .msg ChanServ op $chan $me }

; Freenode specific. 
; "A Bad Connection"
alias abc { 
  if ($me isop $chan) { mode $chan +b $address($1,2) $+ $ $+ ##fix_your_connection }
  else { set %command_1 mode $chan +b-o $address($1,2) $+ $ $+ ##fix_your_connection $me | get_op }
}
