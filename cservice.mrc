;This will check the status of a cservice channel registration on undernet
;This will make your client freeze a bit, don't panic and don't click anything to make it "unresponsive"
;You NEED OpenSSL: http://www.mirc.com/ssl.html <--- read this page
;Here is a screenshot of what it looks like in your client: http://i.imgur.com/BMgJPHq.png
;USE: /checkapp #chan    If you want to change the command name, edit the next line.
alias checkapp {
  if ($sock(app)) { msg $chan [Error] < $+ $nick $+ > Socket in use | halt } 
  if ($left($1,1) != $chr(35)) { msg $chan [Error] < $+ $nick $+ > Erroneus #channelname syntax | halt } 
  unset %line , %apurl 
  set %appchan $chan 
  set %chan $remove($1,$left($1,1)) 
  set %weburl [url] https://cservice.undernet.org/live/check_app.php?name=%23 $+ %chan
  echo $color(notice) -a Checking application status for $1 $+ . (This will make your client lag like 10 seconds, don't click anything and don't panic)
  app 
} 

alias app { unset %line | sockopen -e app cservice.undernet.org 443 } 
alias -l exo { return $regsubex($1, /<[^>]+(?:>|$)|^[^<>]+>/g,) } 

on 1:sockopen:app:{ 
  if (%apurl) { var %ap2 live/ $+ %apurl } 
  else { var %ap2 live/check_app.php?name=%23 $+ %chan } 

  sockwrite -tn $sockname GET / $+ %ap2 HTTP/1.1 
  sockwrite -tn $sockname Host: cservice.undernet.org 
  sockwrite -tn $sockname User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) 
  sockwrite -tn $sockname Connection: Close 
  sockwrite -tn $sockname $crlf 
} 
on 1:sockread:app:{ 
  var %weburl [url] https://cservice.undernet.org/live/check_app.php?name=%23 $+ %chan
  var %ap 
  sockread -f %ap 
  %ap = $remove(%ap,&nbsp;) 
  echo -s *** 12 SOCKREAD: %ap 
  if (Location: isin %ap) { 
    set %apurl $remove(%ap,Location:) 
    %apurl = $remove(%apurl,$chr(32)) 
    sockclose $sockname 
    sockopen -e app cservice.undernet.org 443 
  } 
  if (*Channel :* iswm %ap) set %line %line [Channel] $remove($exo(%ap),Channel,:) 
  if (*Posted on* iswm %ap) set %line %line [Date] $remove($exo(%ap),posted,on,:) 
  if (*by user* iswm %ap) set %line %line [User] $remove($exo(%ap),by,user,:) 
  if (*Current status* iswm %ap) set %line %line [Status] $remove($exo(%ap),current,status,:) 
  if (*Decision date* iswm %ap) set %line %line [Decision Date] $remove($exo(%ap),Decision,date,:) 
  if (*Decision comment* iswm %ap) set %line %line [Decision Comment] $remove($exo(%ap),Decision,comment,:)
} 

on 1:sockclose:app:{ 
  if (%line) { 
    echo $color(notice) -a [csc] $v1 
    echo $color(notice) -a %weburl
  } 
  else { echo $color(notice) -a No applications matching $chr(35) $+ %chan were found } 
} 
