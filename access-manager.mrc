; Userlist System
; Version: 5.2
; By: Seb
; Changelog:     
; v1 was ugly, and from 2001
; v2 revamped completely,
; added levels and aliases
; todo:
; [] .set (chanset)
; [] %var in menu?
; [X] combined aliases
; [x] lvl edits
; [] help files

alias user.list { 
  var %dbp = database\ $+ # $+ .ini
  var %valid.levels = op,voice,protect,bot,manager
  vas %pull.level = $1
  if ($1 !isin %valid.levels) { echo -a [Error] Invalid Level, try: /c.list <op|voice|protect|bot|manager> | halt }
  if ($ini(%dbp,$1,0) == $null) { echo -at $1 List Empty | halt }  
  echo -a Listing:4 $1 on # 
  var %o = 1 | while (%o <= $ini(%dbp,$1,0)) { echo -a $2 $ini(%dbp,$1,%o) | inc %o } 
}

alias show.levels {
  var %dbp = database\ $+ # $+ .ini
  echo -a command disabled for now
  msg $chan Levels for $1 with this mask :: $address($1,2)
  msg $chan $&
    $iif($readini(%dbp, manager, $address($1,2)),3+manager,4-manager) $&    
    $iif($readini(%dbp, infoline, $address($1,2)),3+infoline,4-infoline) $&    
    $iif($readini(%dbp, op, $address($1,2)),3+autoop,4-autoop) $&    
    $iif($readini(%dbp, voice, $address($1,2)),3+autovoice,4-autovoice) $&    
    $iif($readini(%dbp, keepop, $address($1,2)),3+keepop,4-keepop) $&    
    $iif($readini(%dbp, bot, $address($1,2)),3+bot,4-bot) $& 
    $iif($readini(%dbp, protect, $address($1,2)),3+protect,4-protect)               
}


alias update.levels {
  var %dbp2 = database\ $+ $2 $+ .ini
  msg $2 Levels for $1 with this mask :: $address($1,2)
  msg $2 $&
    $iif($readini(%dbp2, manager, $address($1,2)),3+manager,4-manager) $&    
    $iif($readini(%dbp2, infoline, $address($1,2)),3+infoline,4-infoline) $&    
    $iif($readini(%dbp2, op, $address($1,2)),3+autoop,4-autoop) $&    
    $iif($readini(%dbp2, voice, $address($1,2)),3+autovoice,4-autovoice) $&    
    $iif($readini(%dbp2, keepop, $address($1,2)),3+keepop,4-keepop) $&    
    $iif($readini(%dbp2, bot, $address($1,2)),3+bot,4-bot) $& 
    $iif($readini(%dbp2, protect, $address($1,2)),3+protect,4-protect) $&
    $iif($readini(%dbp2, suspend, $address($2,2)),3+suspend,4-suspend)        
}

alias c.update { 
  if ($timershow) { halt }
  set %dbupchan $chan
  .timer $+ show 1 2 update.levels $1 %dbupchan
  unset %dbupchan
}

on *:JOIN:#:{
  var %dbp = database\ $+ # $+ .ini
  if ($readini(%dbp, suspend, $address($nick,2))) { msg $chan $+([,$nick,]) Is Suspended | halt }
  if ($readini(%dbp, infoline, $address($nick,2))) { 
    if ($nick == $me) { return }
    msg $chan ( $+ $nick $+ ) $readini(%dbp, infoline, $address($nick,2)) 
  }
  if ($readini(%dbp, op, $address($nick,2)) == 1) && ($readini(%dbp, voice, $address($nick,2)) == 1) { 
    .mode # +ov # $nick 
    halt 
  } 
  if ($readini(%dbp, op, $address($nick,2)) == 1) { 
    mode $chan +o $nick 
    halt 
  } 
  if ($readini(%dbp, voice, $address($nick,2)) == 1) { 
    mode $chan +v $nick 
    halt
  } 
}
on *:KICK:#:{ 
  var %dbp = database\ $+ # $+ .ini
  if ($readini(%dbp, protect, $address($knick,2)) == 1) { 
    ban -k $chan $nick $knick is Protected! [Suspended: 1h] 
    writeini %dbp suspend $address($nick,2) 1
    .timer 1 3600 remini %dbp suspend $address($nick,2) 1
  } 
}
on *:ban:#:{ 
  var %dbp = database\ $+ # $+ .ini
  if ($bnick == $nick) { halt }
  if ($readini(%dbp, protect, $address($bnick,2)) == 1) { 
    mode $chan -bo+b $banmask $nick $address($nick,2) 
    kick $chan $nick $bnick is Protected! [Suspended: 1h]
    writeini %dbp suspend $address($nick,2) 1    
    .timer 1 3600 remini %dbp suspend $address($nick,2) 1
  } 
}
on *:DEOP:#:{ 
  var %dbp = database\ $+ # $+ .ini
  if ($nick == $me) { halt }
  if ($opnick == $nick) { halt }
  if ($readini(%dbp, keepop, $address($opnick,2)) == 1) { 
    mode $chan -o+o $nick $opnick 
    msg $chan $opnick has KeepOp Enabled on $opnick
  } 
}

on 1:input:#:{ 
  var %dbp = database\ $+ # $+ .ini
  if ($1 == .who) {
    .timer 1 1 msg $chan Levels for $2 with this mask :: $address($2,2)
    .timer 1 1 msg $chan $&
      $iif($readini(%dbp, manager, $address($2,2)),3+manager,4-manager) $&    
      $iif($readini(%dbp, infoline, $address($2,2)),3+infoline,4-infoline) $&    
      $iif($readini(%dbp, op, $address($2,2)),3+autoop,4-autoop) $&    
      $iif($readini(%dbp, voice, $address($2,2)),3+autovoice,4-autovoice) $&    
      $iif($readini(%dbp, keepop, $address($2,2)),3+keepop,4-keepop) $&    
      $iif($readini(%dbp, bot, $address($2,2)),3+bot,4-bot) $& 
      $iif($readini(%dbp, protect, $address($2,2)),3+protect,4-protect) $&
      $iif($readini(%dbp, suspend, $address($2,2)),3+suspend,4-suspend)    
    $iif($readini(%dbp, infoline, $address($2,2)),msg $chan Infoline: $readini(%dbp, infoline, $address($2,2)),$null) 
  }
  if ($1 == .mod) {
    if (+bot isin $3-) { writeini %dbp bot $address($2,2) 1 | c.update $2 }
    if (+autoop isin $3-) { writeini %dbp op $address($2,2) 1 | c.update $2 | mode $chan +o $2 }
    if (+autovoice isin $3-) { writeini %dbp voice $address($2,2) 1 | c.update $2 | mode $chan +v $2 }
    if (+keepop isin $3-) { writeini %dbp keepop $address($2,2) 1 | c.update $2 }
    if (+protect isin $3-) { writeini %dbp protect $address($2,2) 1 | c.update $2 }
    if (+manager isin $3-) { writeini %dbp manager $address($2,2) 1 | c.update $2 }
    if (+suspend isin $3-) { writeini %dbp suspend $address($2,2) 1 | c.update $2 }    
    if (-bot isin $3-) { remini %dbp bot $address($2,2) | c.update $2 }
    if (-autoop isin $3-) { remini %dbp op $address($2,2) | c.update $2 | mode $chan -o $2 }
    if (-autovoice isin $3-) { remini %dbp voice $address($2,2) | c.update $2 | mode $chan -v $2 }
    if (-keepop isin $3-) { remini %dbp keepop $address($2,2) | c.update $2 }
    if (-protect isin $3-) { remini %dbp protect $address($2,2) | c.update $2 }
    if (-manager isin $3-) { remini %dbp manager $address($2,2) | c.update $2 }
    if (-suspend isin $3-) { remini %dbp suspend $address($2,2) 1 | c.update $2 }    
  }
  if ($1 == +infoline) {
    writeini %dbp infoline $address($2,2) $3- 
    .timer 1 1 msg $chan Added infoline to $2 on $chan :: $3-
  }
  if ($1 == -infoline) {
    remini %dbp infoline $address($2,2) 
    .timer 1 1 msg $chan Removed infoline From $2 on $chan
  }
}

on *:text:.who *:#:{
  var %dbp = database\ $+ # $+ .ini
  msg $chan Levels for $2 with this mask :: $address($2,2)
  msg $chan $&
    $iif($readini(%dbp, manager, $address($2,2)),3+manager,4-manager) $&    
    $iif($readini(%dbp, infoline, $address($2,2)),3+infoline,4-infoline) $&    
    $iif($readini(%dbp, op, $address($2,2)),3+autoop,4-autoop) $&    
    $iif($readini(%dbp, voice, $address($2,2)),3+autovoice,4-autovoice) $&    
    $iif($readini(%dbp, keepop, $address($2,2)),3+keepop,4-keepop) $&    
    $iif($readini(%dbp, bot, $address($2,2)),3+bot,4-bot) $& 
    $iif($readini(%dbp, protect, $address($2,2)),3+protect,4-protect) $&
    $iif($readini(%dbp, suspend, $address($2,2)),3+suspend,4-suspend)    
  $iif($readini(%dbp, infoline, $address($2,2)),msg $chan Infoline: $readini(%dbp, infoline, $address($2,2)),$null) 
}

on *:TEXT:.mod *:#:{
  var %dbp = database\ $+ # $+ .ini
  if ($readini(%dbp, manager, $address($nick,2)) !== 1) { 
    msg $chan you need manager level to use this command.
    HALT 
  }
  if ($readini(%dbp, manager, $address($nick,2)) == 1) {
    if (+bot isin $3-) { writeini %dbp bot $address($2,2) 1 | c.update $2 }
    if (+autoop isin $3-) { writeini %dbp opj $address($2,2) 1 | c.update $2 | mode $chan +o $2 }
    if (+autovoice isin $3-) { writeini %dbp voice $address($2,2) 1 | c.update $2 | mode $chan +v $2 }
    if (+keepop isin $3-) { writeini %dbp keepop $address($2,2) 1 | c.update $2 }
    if (+protect isin $3-) { writeini %dbp protect $address($2,2) 1 | c.update $2 }
    if (+manager isin $3-) { writeini %dbp manager $address($2,2) 1 | c.update $2 }
    if (+suspend isin $3-) { writeini %dbp suspend $address($2,2) 1 | c.update $2 }    
    if (-bot isin $3-) { remini %dbp bot $address($2,2) | c.update $2 }
    if (-autoop isin $3-) { remini %dbp op $address($2,2) | c.update $2 | mode $chan -o $2 }
    if (-autovoice isin $3-) { remini %dbp voice $address($2,2) | c.update $2 | mode $chan -v $2 }
    if (-keepop isin $3-) { remini %dbp keepop $address($2,2) | c.update $2 }
    if (-protect isin $3-) { remini %dbp protect $address($2,2) | c.update $2 }
    if (-manager isin $3-) { remini %dbp manager $address($2,2) | c.update $2 }
    if (-suspend isin $3-) { remini %dbp suspend $address($2,2) 1 | c.update $2 }    
  }
}

on *:text:+infoline *:#:{ 
  var %dbp = database\ $+ # $+ .ini
  writeini $+(%dbp) infoline $address($nick,2) $2- 
  .notice $nick Added infoline to $nick on $chan :: $2-
}
on *:text:-infoline:#:{ 
  remini $+(%dbp) infoline $address($nick,2) 
  .notice $nick Removed infoline From $nick on $chan
}

#menus 

menu nicklist {
  [Userlist]
  .Add
  ..manager:writeini $+(database\,$chan,.ini) manager $address($$1,2) 1 | echo -a Added $$1 To manager level on $chan with this host: $address($$1,2) | mode $chan +o $$1
  ..Op:writeini $+(database\,$chan,.ini) op $address($$1,2) 1 | echo -a Added $$1 To Op list on $chan with this host: $address($$1,2) | mode $chan +o $$1
  ..Voice:writeini $+(database\,$chan,.ini) voice $address($$1,2) 1 | echo -a Added $$1 To Voice list on $chan with this host: $address($$1,2) | mode $chan +v $$1
  ..KeepOp:writeini $+(database\,$chan,.ini) keepop $address($$1,2) 1 | echo -a Added $$1 To KeepOp list on $chan with this host: $address($$1,2) | mode $chan +o $$1
  ..Protect:writeini $+(database\,$chan,.ini) protect $address($$1,2) 1 | echo -a Added $$1 To protect list on $chan with this host: $address($$1,2)
  ..Bot:writeini $+(database\,$chan,.ini) bot $address($$1,2) 1 | writeini $+(database\,$chan,.ini) opjoin $address($$1,2) 1 | echo -a Added $$1 To Bot list on $chan with this host: $address($$1,2) | mode # +o $$1
  .Remove
  ..manager:remini $+(database\,$chan,.ini) manager $address($$1,2) | echo -a Removed $$1 From manager list on $chan with this host: $address($$1,2) | mode $chan -o $$1
  ..Op:remini $+(database\,$chan,.ini) op $address($$1,2) | echo -a Removed $$1 From Op list on $chan with this host: $address($$1,2) | mode $chan -o $$1
  ..Voice:remini $+(database\,$chan,.ini) voice $address($$1,2) | echo -a Removed $$1 From Voice list on $chan with this host: $address($$1,2) | mode $chan -v $$1  
  ..KeepOp:remini $+(database\,$chan,.ini) KeepOp $address($$1,2) 1 | echo -a Removed $$1 From KeepOp list on $chan with this host: $address($$1,2)
  ..Protect:remini $+(database\,$chan,.ini) protect $address($$1,2) 1 | echo -a Removed $$1 From protect list on $chan with this host: $address($$1,2)
  ..Bot:remini $+(database\,$chan,.ini) bot $address($$1,2) 1 | echo -a Removed $$1 From Bot list on $chan with this host: $address($$1,2)
}

menu channel {
  [Userlist]
  .Show
  ..Managers:user.list manager  
  ..Op:user.list op
  ..Voice:user.list voice
  ..Protect:user.list protect
  ..Bots:user.list bot 
}

on *:LOAD:{ 
  echo -a Userlist v5.2 Succesfully loaded 
  echo -a Make sure the folder database has been created. Type: //run database To verify.
  echo -a if you see: * /run: unable to open file 'database' Then it failed.  (Will not usually fail)
  echo -a Just type /mkdir database or open your mIRC folder (where mirc.exe is) and create it manually with read/write permissions
  mkdir database 
}
