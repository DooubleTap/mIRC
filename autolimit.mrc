;Auto-Limiter Remote Script 
on 1:load:{ echo -a - | echo -a You just Loaded The Channel Auto-Limit Remote. | halt } 
on 1:Op:#:{ if ($opnick == $me) && ([ % [ $+ [ $chan ] $+ ] .autolimit ] != $null) { var %climit = [ % [ $+ [ $chan ] $+ ] .limit ] | .timer [ $+ [ $chan ] $+ ] llimit off | .timer [ $+ [ $chan ] $+ ] llimit 1 2 addlimit $chan %climit } } 
on 1:Join:#:{ if ($nick != $me) && ($me isop $chan) && ([ % [ $+ [ $chan ] $+ ] .autolimit ] != $null) { var %climit = [ % [ $+ [ $chan ] $+ ] .limit ] | .timer [ $+ [ $chan ] $+ ] llimit off | .timer [ $+ [ $chan ] $+ ] llimit 1 10 addlimit $chan %climit } } 
on 1:Part:#:{ 
  if ($nick == $me) { halt } 
  if ($nick == $nick) && ($me isop $chan) { if ([ % [ $+ [ $chan ] $+ ] .autolimit ] != $null) { var %climit = [ % [ $+ [ $chan ] $+ ] .limit ] | .timer [ $+ [ $chan ] $+ ] llimit off | .timer [ $+ [ $chan ] $+ ] llimit 1 2 addlimit $chan %climit } } 
} 
on 1:Quit:{ var %q = 1 | while ( %q <= $comchan($nick,0) ) { if ([ % [ $+ [ $comchan($nick,%q) ] $+ ] .autolimit ] != $null) && ($me isop $comchan($nick,%q)) { var %climit = [ % [ $+ [ $comchan($nick,%q) ] $+ ] .ch.limit ] | .timer [ $+ [ $comchan($nick,%q) ] $+ ] llimit off | .timer [ $+ [ $comchan($nick,%q) ] $+ ] llimit 1 2 raw -q mode $comchan($nick,%q) +l $calc(%climit - 1) } | inc %q } } 
on 1:Mode:#:{ 
  if (l isin $1) { set % [ $+ [ $chan ] $+ ] .ch.limit $2 } 
  if ($nick != $me) && ($me isop $chan) { if ([ % [ $+ [ $chan ] $+ ] .autolimit ] != $null) { if (l isin $1) { inc -u10 % [ $+ [ $chan ] $+ ] .inclimit | if ([ % [ $+ [ $chan ] $+ ] .inclimit ] < 2) { var %climit = [ % [ $+ [ $chan ] $+ ] .limit ] | .timer [ $+ [ $chan ] $+ ] llimit off | .timer [ $+ [ $chan ] $+ ] llimit 1 2 addlimit $chan %climit } } } } 
} 
alias addlimit { raw -q mode $$1 +l $calc($nick($$1,0) + $2) } 
on 1:Kick:#:{ if ($knick != $me) && ($me isop $chan) { if ([ % [ $+ [ $chan ] $+ ] .autolimit ] != $null) { var %climit = [ % [ $+ [ $chan ] $+ ] .limit ] | .timer [ $+ [ $chan ] $+ ] llimit off | .timer [ $+ [ $chan ] $+ ] llimit 1 2 addlimit $chan %climit } } } 
menu nicklist,channel { 
  - 
  Auto-Limit( $+ $iif([ % [ $+ [ $chan ] $+ ] .autolimit ] != $null,ON + $+ [ % [ $+ [ $chan ] $+ ] .limit ] $+ $chr(41),OFF $+ $chr(41)) :{ 
    if ([ % [ $+ [ $chan ] $+ ] .autolimit ] == $null) { var %limit = $$?="Auto Limit Float Margin (1-999):" | set % [ $+ [ $chan ] $+ ] .limit %limit | set % [ $+ [ $chan ] $+ ] .autolimit $chan | echo -a *** Turning ON the Autolimit on: $chan $+ . | if ($me isop $chan) { var %climit = [ % [ $+ [ $chan ] $+ ] .limit ] | addlimit $chan %climit } } 
    else { unset % [ $+ [ $chan ] $+ ] .limit % [ $+ [ $chan ] $+ ] .autolimit | echo -a *** Turning OFF the Autolimit on: $chan $+ . | if ($me isop $chan) { raw -q mode # -l } } 
  } 
  - 
}

on *:LOAD:{ 
  echo -a 4» »08 Auto-Limit Script Successfully Loaded.
  echo -a 4» »08 Copyright © 200915 http://xplorer.mircscripting.info
  echo -a 4» »08 Written by: 15 xplorer 08 Email: 15 xplorer@live.ca
}
