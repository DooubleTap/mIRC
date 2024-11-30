# All the commands you type in a channel will not be written in the channel. 
# Example: xkick YourNick I just kicked you with X
on 1:input:#:{
  if ($1 == xa) { .msg x access $chan = $+ $2- | HALT }
  if ($1 == xforce) { .msg x force $chan | HALT }
  if ($1 == xunforce) { .msg x unforce $chan | HALT }
  if ($1 == xset) { .msg x set $chan $2- | HALT }
  if ($1 == xvoice) { .msg x voice $active $2- | HALT }
  if ($1 == xstfu) { .msg x ban $chan $2 My nice way to say shut the fu*k up | halt }
  if ($1 == nobot) { .msg x ban $chan $2 Useless piece of Bot | halt }
  if ($1 == kb) { ban -k # $2 Begone! | halt }
  if ($1 == xdevoice) { .msg x devoice $active $2- | HALT }
  if ($1 == op) { .mode $chan +o $2- | HALT }  
  if ($1 == deop) { .mode $chan -o $2- | HALT }  
  if ($1 == voice) { .mode $chan +v $2- | HALT }
  if ($1 == devoice) { .mode $chan -v $2- | HALT }
  if ($1 == xop) { .msg x op $active $2- | HALT }
  if ($1 == xdeop) { .msg x deop $active $2- | HALT }
  if ($1 == xkick) { .msg x kick $active $2- | HALT }
  if ($1 == xban) { .msg x ban $active $2- | HALT }
  if ($1 == xunban) { .msg x unban $active $2- | HALT }
  if ($1 == xadd) { .msg x adduser # = $+ $2 $3 $4- | HALT }
  if ($1 == xrem) { .msg x remuser # = $+ $2 $3- $4- | HALT } 
  if ($1 == xpart) { .msg x part $active $2- | HALT }
  if ($1 == xstat) { .msg x status $active | HALT }
  if ($1 == xjoin) { .msg x join $active $2- | HALT }
  if ($1 == xreg) { .msg x register $active $2 | HALT }  
  if ($1 == xn) { .msg x set $active noop $2- | HALT }
  if ($1 == xs) { .msg x set $active strictop $2- | HALT }
  if ($1 == xt) { .msg x topic $active $2-40 | HALT }
  if ($1 == xm) { .msg x modinfo $active access = $+ $2 $3- | HALT }
  if ($1 == xmop) { .msg x modinfo $active automode = $+ $2 op - | HALT }
  if ($1 == xmv) { .msg x modinfo $active automode = $+ $2 voice - | HALT }
  if ($1 == xmn) { .msg x modinfo $active automode = $+ $2 none - | HALT }
  if ($1 == xmod) { .msg x access $chan = $+ $2 -modif -| HALT }
  if ($1 == xsus) { .msg x suspend $active = $+ $2 $3 $4- | HALT }
  if ($1 == xusus) { .msg x unsuspend $active = $+ $2 - | HALT }
  if ($1 == xinfo) { .msg x info = $+ $2- | HALT }
  if ($1 == xjoin) { .msg x join # $2- | HALT }
  if ($1 == xverify) { .msg x verify $2- | HALT }
  if ($1 == xpart) { .msg x part $active- | HALT }
  if ($1 == xbanlist) { .msg x lbanlist # $2- | HALT }
}
