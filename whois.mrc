## Whois mods by Sebastien (xplo)
## $comchan alias from someone in a help chan somewhere. 
## If you touch at something below this line, you WILL fuckup something.
##----------------------------------------------------------------------

alias w { .enable #whois | whois $1 $1 } 
#whois off
raw 311:*: { 
  echo $color(notice) -ai2 14[7###14] $iif($me == $2,Looking at yourself?,/whois7 $2)
  echo -ai2 2Nick:14 $2 
  echo -ai2 2Address:14 $3 $+ @ $+ $4 
  echo -ai2 2FullName:14 $6-   
  halt 
} 
raw 379:*:{ echo -ai2 2Is using modes:14 $6- | halt }
raw 378:*:{ echo -ai2 2Is Connecting from:14 $6- | halt }
raw 319:*: { 
  echo -ai2 2Channels:4 $sorttok($3-,32,c) 
  $iif($2 == $me,halt,echo -ai2 2Common Channels:11 $AdoComChan($2))
  halt 
} 
raw 312:*: { 
  echo -ai2 2Server:14 $3
  echo -ai2 2Description:14 $4- 
  halt 
} 
raw 330:*:{ echo -ai2 2Username: 4 $+ $3 $+  | halt } 
raw 338:*:{ echo -ai2 2Host:14 $3 | halt } 
raw 307:*:{ echo -ai2 3 $+ $2 $3- | halt } 
raw 301:*:{ echo -ai2 2 $+ $2 is away:7 $3- | halt } 
raw 313:*:{ echo -ai2 2Status:14 $5- | halt } 
raw 310:*:{ echo -ai2 2 $+ $2 14 $+ $3- | halt } 
raw 320:*:{ echo -ai2 2 $+ $2 14 Is using a Secure Connection (4SSL14) | halt }
raw 335:*:{ echo -ai2 2 $+ $2 14 Is a Bot on $network (4BOT14) | halt }
raw 671:*:{ echo -ai2 2 $+ $2 14 Is using a Secure Connection (4SSL14) | halt }
raw 317:*:{ 
  echo -a 2Idle time:4 $duration($3) 
  if ($4 isnum) echo -ai2 2Online time:14 $asctime($4) 
  halt 
} 
raw 318:*:{ 
  echo $color(notice) -ai2 14[7###14] End of Whois for7 $2  
  linesep -a
  .disable #whois 
  halt 
} 
alias AdoComChan { 
  var %AdoComCh = 1 
  while (%AdoComCh <= $comchan($1,0)) { 
    var %AdoComLi = %AdoComLi $comchan($1,%AdoComCh) 
    inc %AdoComCh 
  } 
  if (%AdoComLi == $null) { return None } 
  else { return %AdoComLi } 
} 
#whois end

#EOF
