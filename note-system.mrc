;Just load it, and read the instructions. it's pretty simple. 
;Made by Sebastien @ undernet - freenode - nextirc - geekshed

alias note.add { 
  if ($hget(jnotes) != jnotes) { hmake jnotes } 
  hadd jnotes $1 $2- 
  echo -at Note Added for $1  $+ $2- $+ . 
} 

alias note.del { 
  var %i = 1 
  while (%i <= $hget(jnotes,0).item) { 
    if ($hget(jnotes,%i).item == $1) { 
      hdel jnotes $1 
      echo -at Note Deleted for $1 
    } 
    inc %i 
  } 
} 

alias notes { 
  echo $color(notice) -at Note System help 
  echo $color(notice) -at /note.list               :: Show the notes added to the database. 
  echo $color(notice) -at /note.del <nick>         :: Delete a note from the database. 
  echo $color(notice) -at /note.add <nick> <info>  :: Add some infos to the database 
  echo $color(notice) -at /note.credits            :: Informations about the author. 
  echo $color(notice) -a Example /note.add $me I am really hot, and you know it!  
} 

alias note.credits { 
  echo -at This script was written by xplorer@live.ca 
  echo -at You can find me on /server -m irc.undernet.org -j #mircscripting 
  echo -at Feel free to modify it as you wish, but it would be nice to send me your copy, so i could get another version out. 
  echo -at Improvements are allways welcomed. 
} 

alias note.list { 
  window -k0 @Notes 10 10 
  aline @Notes [Listing Join notes Database] 
  .timer 1 3 aline @Notes 4Double-Click in this window to close it. 
  var %i = 1 
  if ($hget(jnotes)) { 
    while (%i <= $hget(jnotes,0).item) { 
      aline @Notes 4,1[ $+ $hget(jnotes,%i).item $+ 4]: $hget(jnotes,$hget(jnotes,%i).item) 
      inc %i 
    } 
  } 
} 

on *:EXIT:{ hsave jnotes jnotesystem.txt } 
on *:DISCONNECT:{ hsave jnotes jnotesystem.txt } 
on *:START:{ hmake jnotes | hload jnotes jnotesystem.txt } 

on ^*:JOIN:#:{ 
  var %i = 1 
  while (%i <= $hget(jnotes,0).item) { 
    if ($nick == $hget(jnotes,%i).item) { 
      echo $color(join) $chan $timestamp * Joins: $nick ( $+ $gettok($address($nick,5),2,33) $+ )
      echo $color(notice) $chan ### [Note] $+([,$nick,]) - $hget(jnotes,$nick) 
      haltdef
    } 
    inc %i 
  } 
} 
menu @notes { 
  dclick: window -c @notes 
}
