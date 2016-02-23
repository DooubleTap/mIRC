; Script to display whois information in an @window 
; - Ook 
; 
; All the whois raws are captured but only the nick, address, idle, server, channels info is shown 
; with a little tinkering more can easily be added. 
; 
; v1.0 
; - First release 
; v1.1 
; - fixed possible error in endofwhois when $address fails. 
; - added some more error output. 
; - changed tabs to cut off text that exceeds limits. 
; - changed code to update horiz scrollbar on end of whois (doesnt display whole line still, this is mircs fault) 
; - channel name no longer needed, will take active window as channel if no channel name given. 
; 
; /whoischan <chan> 
; $1 = chan 
alias whoischan { 
  if ($0 > 1) { echo -aqmlbfti2 [whoischan] Usage: /whoischan <#channel> | halt } 
  var %i = 1, %c = $iif($0,$1,$active) 
  window -lM -t20,100,130,170 @whoischan 
  clear @whoischan 
  aline @whoischan $+( Nick,$chr(9),Address,$chr(9),Idle Time,$chr(9),Server,$chr(9),Channels) 
  aline @whoischan  
  while ($nick(%c,%i) != $null) { 
    var %n = $v1 
    aline @whoischan $+(%n,$chr(9),$iif($address(%n,5) != $null,$v1,unknown),$chr(9),0,$chr(9),-,$chr(9),$chr(160)) 
    _pushwhois %n %n 
    inc %i 
  } 
  !return 
  :error 
  !echo 4 -s whoischan: $error 
} 
alias -l _nnet { 
  !if ($network != $null) return $v1 
  !elseif ($server($server).group != $null) { 
    !if ($v1 !isnum) return $v1 
  } 
  !return Default 
  :error 
  !echo 4 -s _nnet: $error 
} 
; start temp data hashtable functs 
; $1 = var (delete temp var) 
alias -l tdel !if ($hget(whoischan)) hdel whoischan $1 
; $1 = var wildcard (del temp vars that matcvh wildcard) 
alias -l twdel !if ($hget(whoischan)) hdel -w whoischan $1 
; $1 = var, $2- = data (add a temp var) 
alias -l tadd !hadd whoischan $1- 
; $1 = var (get the contents of a temp var) 
alias -l tget !return $hget(whoischan,$1-) 
; end temp data hashtable functs 
alias -l _pushwhois { 
  !var %cid = $cid 
  !hadd -m $+(%cid,-whois-queue) $1 $1- 
  if (!$timer($+(%cid,-pushwhois))) $+(.timer,%cid,-pushwhois) 1 0 _pushwhois.dump 
  !return 
  :error 
  !echo 4 -s _pushwhois: $error 
} 
alias -l _pushwhois.dump { 
  !var %cid = $cid, %limit = $tget($+(%cid,-maxtarget-WHOIS)) 
  !if (!%limit) var %limit = 1 
  !if ($tget($+(%cid,enable_combined_whois))) { 
    ; if the network supports it combine the /whois into one 
    !while ($hget($+(%cid,-whois-queue),1).data != $null) { 
      !var %n = $v1 
      !if ($numtok(%n,32) == 1) { 
        ; single nick /whois nick style, these can be combined. 
        !var %whois = $addtok(%whois,%n,44) 
        !hdel $+(%cid,-whois-queue) $hget($+(%cid,-whois-queue),1).item 
        !if ($numtok(%whois,44) == %limit) break 
      } 
      ; otherwise its /whois nick nick style, these can't be combined. 
      !elseif (%whois != $null) break 
      !else { 
        !var %whois = %n 
        !hdel $+(%cid,-whois-queue) $hget($+(%cid,-whois-queue),1).item 
        !break 
      } 
      !inc %cnt 
    } 
  } 
  !else { 
    ; otherwise do a single whois & pause before next 
    !var %whois = $hget($+(%cid,-whois-queue),1).data 
    !hdel $+(%cid,-whois-queue) $hget($+(%cid,-whois-queue),1).item 
  } 
  if ($hget($+(%cid,-whois-queue),0).item > 0) $+(.timer,%cid,-pushwhois) 1 2 _pushwhois.dump 
  else hfree $+(%cid,-whois-queue) 
  if (%whois != $null) whois %whois 
  !return 
  :error 
  !echo 4 -s _pushwhois.dump: $error 
} 
RAW 5:*: { 
  !if ($hget(whoischan) == $null) hmake whoischan 100 
  !var %cid = $cid, %tmp = $matchtokcs($1-,SILENCE,1,32) 
  if (%tmp) tadd $+(%cid,-silence) $gettok(%tmp,2,61) 
  else tadd $+(%cid,-silence) 0 
  !var %tmp = $matchtokcs($1-,TOPICLEN,1,32) 
  if (%tmp) tadd $+(%cid,-topiclen) $gettok(%tmp,2,61) 
  else tadd $+(%cid,-topiclen) 0 
  !var %tmp = $matchtokcs($1-,NICKLEN,1,32) 
  if (%tmp) tadd $+(%cid,-nicklen) $gettok(%tmp,2,61) 
  else tadd $+(%cid,-nicklen) 0 
  !var %tmp = $matchtokcs($1-,UHNAMES,1,32) 
  if (%tmp) tadd $+(%cid,-uhnames) 1 
  else tadd $+(%cid,-uhnames) 0 
  !var %tmp = $matchtokcs($1-,TARGMAX,1,32) 
  !if (%tmp) { 
    !var %cnt = 1, %tmp = $gettok(%tmp,2,61) 
    !while ($gettok(%tmp,%cnt,44) != $null) { 
      tadd $+(%cid,-maxtarget-,$gettok($v1,1,58)) $gettok($v1,2,58) 
      !inc %cnt 
    } 
  } 
  else twdel $+(%cid,-maxtarget-*) 
  !var %tmp = $matchtokcs($1-,MAXLIST,1,32) 
  !if (%tmp) { 
    !var %cnt = 1, %tmp = $gettok(%tmp,2,61) 
    !while ($gettok(%tmp,%cnt,44) != $null) { 
      !var %t = $+(%cid,-maxlist-,$gettok($v1,1,58)) 
      tadd %t $gettok($v1,2,58) 
      if ($tget(%t) == $null) tadd %t 1 
      !inc %cnt 
    } 
  } 
  else twdel $+(%cid,-maxlist-*) 
  !var %tmp = $matchtokcs($1-,AWAYLEN,1,32) 
  if (%tmp) tadd $+(%cid,-awaylen) $gettok(%tmp,2,61) 
  else tadd $+(%cid,-awaylen) 0 
  !var %tmp = $matchtokcs($1-,KICKLEN,1,32) 
  if (%tmp) tadd $+(%cid,-kicklen) $gettok(%tmp,2,61) 
  else tadd $+(%cid,-kicklen) 0 
  !var %nnet = $_nnet 
  !if ($istok(DALnet UnderNet BeyondIRC IRCHighway SwiftIRC Genscripts,%nnet,32)) { 
    ; net supports combined whois 
    tadd $+(%cid,enable_combined_whois) 1 
    !if ($tget($+(%cid,-maxtarget-WHOIS)) == $null) { 
      ; max targets wasn't set for some reason, try a known value for that network. 
      if (%nnet == Undernet) tadd $+(%cid,-maxtarget-WHOIS) 12 
      elseif (%nnet == Genscripts) tadd $+(%cid,-maxtarget-WHOIS) 20 
      else tadd $+(%cid,-maxtarget-WHOIS) 4 
    } 
  } 
  else tdel $+(%cid,enable_combined_whois) 
} 
; output line = nick address idle-time server channels 
;275 HighwayIRC RPL_WHOISSECURE "<TheirNick> is using a secure connection (SSL)" 
raw 275:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;301 RPL_AWAY "<nick> :<away message>" 
raw 301:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;307 DALnet RPL_WHOISREGNICK Registered Nick  “:<nick> is a registered nick 
raw 307:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;308 DALnet RPL_WHOISADMIN Server Admin (may be dropped) 
raw 308:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;309 DALnet RPL_WHOISSADMIN Services Admin (may be dropped) “: <nick> is a services adminstrator 
raw 309:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;310 DALnet RPL_WHOISHELPOP "%s :looks very helpful.", “<nick> <help status msg>" - A sample reply is: “White_Dragon looks very helpful.” 
raw 310:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;311 RPL_WHOISUSER "<nick> <user> <host> * :<real name>" - The '*' in RPL_WHOISUSER is there as the literal character and not as a wild card 
raw 311:*: { 
  !if ($fline(@whoischan,$+($2,$chr(9),*),1,1) != $null) { 
    var %l = $v1 
    haltdef 
    rline @whoischan %l $puttok($line(@whoischan,%l),$chr(160),5,9) 
  } 
} 
;312 RPL_WHOISSERVER "<nick> <server> :<server info>" 
raw 312:*: { 
  ;echo -s whoischan312: $1- 
  !if ($fline(@whoischan,$+($2,$chr(9),*),1,1) != $null) { 
    var %l = $v1 
    haltdef 
    rline @whoischan %l $puttok($line(@whoischan,%l),$chr(160) $3,4,9) 
  } 
} 
;313 RPL_WHOISOPERATOR "<nick> :is an IRC operator" 
raw 313:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;316 RPL_WHOISCHANOP 
raw 316:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;317 RPL_WHOISIDLE "<nick> <integer> :seconds idle" 
raw 317:*: { 
  ;echo -s whoischan317: $1- 
  !if ($fline(@whoischan,$+($2,$chr(9),*),1,1) != $null) { 
    var %l = $v1 
    haltdef 
    rline @whoischan %l $puttok($line(@whoischan,%l),$chr(160) $duration($3),3,9) 
  } 
} 
;318 RPL_ENDOFWHOIS "<nick>(,nick,nick,...) :End of /WHOIS list" 
raw 318:*: { 
  ;echo -s whoischan318: $1- 
  !var %i = 1 
  !while ($gettok($2,%i,44) != $null) { 
    !var %n = $v1 
    !if ($fline(@whoischan,$+(%n,$chr(9),*),1,1) != $null) { 
      var %l = $v1 
      haltdef 
      if ($address(%n,5) != $null) rline @whoischan %l $puttok($line(@whoischan,%l),$chr(160) $v1,2,9) 
    } 
    inc %i 
  } 
} 
;319 RPL_WHOISCHANNELS "<nick> :{[@|+]<channel><space>}" 
raw 319:*: { 
  !if ($fline(@whoischan,$+($2,$chr(9),*),1,1) != $null) { 
    var %l = $v1 
    haltdef 
    var %txt = $line(@whoischan,%l) 
    rline @whoischan %l $puttok(%txt,$addtok($gettok(%txt,5,9),$3-,32),5,9) 
    window -b @whoischan 
  } 
} 
;330 Undernet/Quakenet RPL_WHOISACCOUNT "<source> 330 <target> <nick> <account> :is authed as" returned when using the WHOIS command on UnderNet "is logged in as" is shown as text 
raw 330:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;335 RPL_WHOISBOT 
raw 335:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;338 RPL_WHOISACTUALLY ":%s 338 %s :%s is actually %s@%s [%s]" 
raw 338:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;615 HighwayIRC RPL_WHOISMODES "<TheirNick> is using modes <modes>" 
raw 615:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
;616 HighwayIRC RPL_WHOISREALHOST "<TheirNick> real hostname <host> <ip>" 
raw 616:*: !if ($fline(@whoischan,$+($2,$chr(9),*),0,1) != $null) haltdef 
