;Nicklist coloring Script
; Made by: http://www.jrIRC.vze.com
;Shared by: Sebastien
;Example: http://i.imgur.com/ww4YMfU.png

menu menubar,channel { 
  .NickList Colors:nicklistcl
}
alias nicklistcl {
  if ($dialog(background) == $null) { dialog -m background background } 
}
alias _vr {
  if ($exists(data\setting.ini) == $false) { mkdir data | write -c data\setting.ini }
  return $readini data\setting.ini $$1 $$2 
}
alias _vw {
  if ($exists(data\setting.ini) == $false) { mkdir data | write -c data\setting.ini }
  writeini data\setting.ini $$1 $$2 $$3-
}
alias _vrem {
  if ($exists(data\setting.ini) == $false) { mkdir data | write -c data\setting.ini }
  remini data\setting.ini $$1 $$2 
}

dialog background {
  title "NickList Colors"
  size -1 -1 86 132
  option dbu
  icon 100, 10 87 172 82
  button "Apply", 50, 15 116 25 10
  button "Close", 51, 45 116 25 10, default ok
  box "NickList Colors", 14, 2 1 83 90
  check "Enable Color Nicklist", 2, 5 9 62 10
  check "Ops", 3, 5 24 22 10
  check "Voice", 4, 5 35 27 10
  check "Half-ops", 30, 5 46 29 10
  check "Regular", 5, 5 56 27 10
  check "Own Nick", 6, 5 66 33 10
  text "Background", 33, 6 77 32 9
  combo 7, 45 25 37 50, drop
  combo 8, 45 35 37 50, drop
  combo 12, 45 45 37 50, drop
  combo 9, 45 55 37 50, drop
  combo 10, 45 65 37 50, drop
  combo 11, 45 75 37 50, drop
  text "Shared by: xplo", 300, 20 100 40 7
}

on *:DIALOG:background:sclick:598:.run http://xplorer.mircscripting.info/
on *:dialog:background:sclick:*:{
  if ($did == 2) { 
    var %xt = 3
    :loop
    did - $+ $iif($did(2).state,e,b) background %xt
    if (%xt < 6) { inc %xt | goto loop }
    _vw  nicklist switch 0 
  }
  if ($did == 7) { _vw nicklist ops $calc($did(background,7).sel - 1) }
  if ($did == 8) { _vw nicklist voice $calc($did(background,8).sel - 1) }
  if ($did == 12) { _vw nicklist hops $calc($did(background,12).sel - 1) }
  if ($did == 9) { _vw nicklist reg $calc($did(background,9).sel - 1) }
  if ($did == 10) { _vw nicklist me $calc($did(background,10).sel - 1) }
  if ($did == 30) { 
    if ($_vr(nicklist,s.hops) == 1) { _vw nicklist s.hops 0  }
    else { _vw nicklist s.hops 1 }
  }  
  if ($did == 3) { 
    if ($_vr(nicklist,s.ops) == 1) { _vw nicklist s.ops 0  }
    else { _vw nicklist s.ops 1 }
  }  
  if ($did == 4) { 
    if ($_vr(nicklist,s.voice) == 1) { _vw nicklist s.voice 0  }
    else { _vw nicklist s.voice 1 }
  }  
  if ($did == 5) { 
    if ($_vr(nicklist,s.reg) == 1) { _vw nicklist s.reg 0  }
    else { _vw nicklist s.reg 1 }
  }  
  if ($did == 6) { 
    if ($_vr(nicklist,s.me) == 1) { _vw nicklist s.me 0  }
    else { _vw nicklist s.me 1 }
  }
  if ($did == 27) { run http://www.jIRC.vze.com | beep } 
  if ($did == 50) { 
    cl.apply 
  }
}

on *:dialog:background:init:*:{
  .timer -m 1 1 nl.back 
  _vrem background window | _vrem background type | _vrem background default 
  did - $+ $iif($_vr(nicklist,switch),c,u) background 2 
  nfcolor 7 | nfcolor 8 | nfcolor 9 | nfcolor 10 | nfcolor 11 | nfcolor 12
  did -c background 7 $calc($_vr(nicklist,ops) + 1)
  did -c background 8 $calc($_vr(nicklist,voice) + 1)
  did -c background 12 $calc($_vr(nicklist,hops) + 1)
  did -c background 9 $calc($_vr(nicklist,reg) + 1)
  did -c background 10 $calc($_vr(nicklist,me) + 1)
  if ($_vr(nicklist,s.hops) == 1) { did -c background 30 }
  if ($_vr(nicklist,s.ops) == 1) { did -c background 3 }
  if ($_vr(nicklist,s.voice) == 1) { did -c background 4 }
  if ($_vr(nicklist,s.reg) == 1) { did -c background 5 }
  if ($_vr(nicklist,s.me) == 1) { did -c background 6 }
}

alias -l nl.back {
  if ($_vr(background,nicklist) == $null) { _vw background nicklist black }
  if ($colour(listbox) == $null) { _vw background nicklist black | did -c background 11 2 }  
  elseif ($colour(listbox) == 0) { did -c background 11 1 }
  elseif ($colour(listbox) == 1) { did -c background 11 2 }
  elseif ($colour(listbox) == 2) { did -c background 11 3 }
  elseif ($colour(listbox) == 3) { did -c background 11 4 }
  elseif ($colour(listbox) == 4) { did -c background 11 5 }
  elseif ($colour(listbox) == 5) { did -c background 11 6 }
  elseif ($colour(listbox) == 6) { did -c background 11 7 }
  elseif ($colour(listbox) == 7) { did -c background 11 8 }
  elseif ($colour(listbox) == 8) { did -c background 11 9 }
  elseif ($colour(listbox) == 9) { did -c background 11 10 }
  elseif ($colour(listbox) == 10) { did -c background 11 11 }
  elseif ($colour(listbox) == 11) { did -c background 11 12 }
  elseif ($colour(listbox) == 12) { did -c background 11 13 }
  elseif ($colour(listbox) == 13) { did -c background 11 14 }
  elseif ($colour(listbox) == 14) { did -c background 11 15 }
  elseif ($colour(listbox) == 15) { did -c background 11 16 }
}
alias -l chan.l {
  var %channum = 0
  :findchan
  inc %channum 1
  var %chan = $chan(%channum)
  if (%chan == $null) { goto end }
  if ($dialog(background) != $null) { did -i background 43 1 %chan }
  goto findchan
  :end
}

alias cl.apply {
  _vw nicklist switch $did(background,2).state
  var %xt = 3
  :start
  if (%xt < 6) { inc %xt | goto start }
  var %xt = 7
  :loop
  if (%xt < 10) { inc %xt | goto loop }
  if ($_vr(nicklist,switch) == 0) { colour listbox 0 }
  else colour listbox $calc($did(background,11).sel - 1)
  clchans
}

on *:join:#:{ 
  if ($_vr(nicklist,switch) == $null) { _vw nicklist switch 1 }
  if ($_vr(nicklist,s.ops) == $null) { _vw nicklist s.ops 1 }
  if ($_vr(nicklist,s.reg) == $null) { _vw nicklist s.reg 1 }
  if ($_vr(nicklist,s.voice) == $null) { _vw nicklist s.voice 1 }
  if ($_vr(nicklist,s.me) == $null) {  _vw nicklist s.me 1 }
  if ($_vr(nicklist,ops) == $null) { _vw nicklist ops 12 }
  if ($_vr(nicklist,voice) == $null) { _vw nicklist voice 8 }
  if ($_vr(nicklist,s.hops) == $null) { _vw nicklist s.hops 1 }
  if ($_vr(nicklist,reg) == $null) { _vw nicklist reg 3 }
  if ($_vr(nicklist,hops) == $null) { _vw nicklist hops 10 }
  if ($_vr(nicklist,me) == $null) { _vw nicklist me 4 }
  cl.nick $chan $nick
  if ($nick == $me) && ($_vr(background,channel) == on) { 
    if ($exists($_vr(background,channelback)) == $true) { .background - $+ $_vr(background,channeltype) $chan $_vr(background,channelback)" }
    elseif ($exists($_vr(background,channelback)) == $false) _vrem background channelback
  }
}
on *:part:#:{ 
  if ($nick == $me) { background -x $chan }
}
on *:help:#:cl.nick $chan $hnick
on *:dehelp:#:cl.nick $chan $hnick
on *:deop:#:cl.nick $chan $opnick
on *:devoice:#:cl.nick $chan $vnick
on *:op:#:cl.nick $chan $opnick
on *:serverdeop:#:cl.nick $chan $opnick
on *:serverop:#:cl.nick $chan $opnick
on *:voice:#:cl.nick $chan $vnick
raw 366:*:if ($me ison $2) { cl.loop $2 }
alias -l cl.loop {
  var %t = $nick($1,0)
  var %t2 = 1
  while (%t2 <= %t) { cl.nick $1 $nick($1,%t2) | inc %t2 1 }
}
alias -l clchans {
  if ($_vr(nicklist,switch) == 1) {
    var %c = $chan(0)
    var %c1 = 1
    while (%c1 <= %c) { cl.loop $chan(%c1) | inc %c1 1 }
  }
}
alias -l cl.nick {
  if ($2) {
    if ($_vr(nicklist,switch) == 1) {
      if ($2 == $me) && ($_vr(nicklist,s.me) == 1) { cline $_vr(nicklist,me) $1 $nick($1,$2) }
      elseif ($2 ishop $1) && ($_vr(nicklist,s.hops) == 1) { cline $_vr(nicklist,hops) $1 $nick($1,$2) }
      elseif ($2 isop $1) && ($_vr(nicklist,s.ops) == 1) { cline $_vr(nicklist,ops) $1 $nick($1,$2) }
      elseif ($2 isvoice $1) && ($_vr(nicklist,s.voice) == 1) { cline $_vr(nicklist,voice) $1 $nick($1,$2) }
      elseif ($2 isreg $1) && ($_vr(nicklist,s.reg)) { cline $_vr(nicklist,reg) $1 $nick($1,$2) }
      else { cline $colour(nick) $1 $nick($1,$2) }
    }
  }
}

alias -l vcl.nick {
  var %a = $nick($active,0)  
  var %a1 = 1
  while (%a1 <= %a) { 
    if ($nick($active,%a1) isop $active) { cline 3 $1 %a1 } 
    elseif ($nick($active,%a1) isvoice $active) { cline 8 $1 %a1 } 
    elseif ($nick($active,%a1) isreg $active) { cline 7 $1 %a1 } 
    elseif ($nick($active,%a1) ishop $active) { cline 12 $1 %a1 } 
    cline 4 $1 $nick($active,$me)  
    inc %a1 1 
  }
}

alias flash.off { 
  .timer91 off
  .timer92 off
  clchans
}
on *:INPUT:*: {
  .timer91 off
  .timer92 off
  ;clchans
}
alias -l nfcolor {
  did -r background $1
  did -a background $1 White
  did -a background $1 Black
  did -a background $1 Blue
  did -a background $1 Green
  did -a background $1 Lightred
  did -a background $1 Brown
  did -a background $1 Purple
  did -a background $1 Orange
  did -a background $1 Yellow
  did -a background $1 Lightgreen
  did -a background $1 Cyan
  did -a background $1 Lightcyan
  did -a background $1 Lightblue
  did -a background $1 Pink
  did -a background $1 Grey
  did -a background $1 Lightgrey
}
