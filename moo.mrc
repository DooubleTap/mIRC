;.oO{ moo script v3.19 by HM2K }Oo. - IRC@HM2K.ORG

;description:
;no more moo.dll! -- this script uses $com to lookup the WMI functions to return specified system information.
;moo script was originally created to display your system information via IRC, including: operating system, 
;  uptime, cpu, memory usage, graphics card, resolution, network details and hard drive details.

;install:
;NOTICE: please unload and remove any old moo scripts, else this script may not work.
;make sure moo.mrc is in your $mircdir then type: /load -rs moo.mrc

;Please make sure you have the latest windows updates or the latest WMI core (http://goo.gl/nAYpB)
;Also, please use the latest version of mIRC, ideally mIRC v6.16 or above...

;usage:
;for moo type: /moo or !moo (if enabled)
;for uptime only type: /up or !uptime (if enabled)

;history:
;moo script v3.19	- added better output relaying
;moo script v3.18	- added find the fastest network interface and find active graphics card
;moo script v3.17	- added cpu architecture descriptors
;moo script v3.16	- Added /stat and /statself, and fixed local echoing.
;moo script v3.15	- Fixed a few bugs + Fixed the repeat checker + Out of beta
;moo script v3.14	- Change the WMI lookup location of the rammax inline with the ramuse.
;moo script v3.13	- Changed the ram function to use a more reliable WMI location, added OSArchitecture (osarc) for Vista, fixed CPU load to not return anything if there's no load.
;moo script v3.12	- Minor tweaks, a few code changes, added /moo echo and a few more functions.
;moo script v3.11	- Added some new features and made it easier to style the output, added some additional notes
;moo script v3.1	- Added the long awaited flood protection, simple lookup error checking, more/better functions, quicker script
;moo script v3.0	- The whole script was changed, no more moo.dll, it now uses WMI however this version MUST be run on mIRC v6.16 or above.
;[moo] script v2.27	- !moo trigger fix, now turned off by default to stop abuse
;[moo] script v2.26	- Lots of little changes made up till this version, including getmoo.
;[moo] script v2.23	- changed some alias' to alias -l, fixed small bugs, added new featuers
;[moo] script v2.22	- minor bug fixes, bold added etc.
;[moo] script v2.21	- added a feature to turn the !moo get and !getmoo on or off, and fixed a few bugs.
;[moo] script v2.2	- name change, completly changed the /moo and !moo system, should work better now, no mistakes.
;moo script v2.13	- still a few mistakes, changes made, mbm5 isn't functioning correctly...
;moo script v2.12	- many small changes and fixes made, mbm5 was fixed also.
;moo script v2.11	- simple bug fixes.
;moo script v2.1	- minor modifications, final public release.
;moo script v2.0	- New name, new style, new script, same idea.
;MooDll Script v1.21	- Many bug fixes, first public release
;MooDll Script v1.0	- Original private release, very simple, buggy.

;thanks:
;Mark (from influenced.net) for the original concept and for letting me know that he was not creating a new moo.dll
;HndlWCare who inspired me to write this for making false claims about the original moo.dll

;support:
;Help support continued development: Please consider donating (http://tinyurl.com/hm2kpaypal). Thanks!

;--------------------------------------------------------------------------------------------------------
;SETTINGS - START
;--------------------------------------------------------------------------------------------------------

;moo banned channels - these are channels you don't want the triggers to function in
alias -l moo.banchans return #php #windows #eztv

;moo style - use this to style the titles of the output
alias -l moos return $+(,$1,:)

;moo prefix - style the prefix
alias -l mooprefix return moo:

;--------------------------------------------------------------------------------------------------------
;SETTINGS - END
;--------------------------------------------------------------------------------------------------------

;NOTICE: DO NOT edit below unless you know what you're doing. If you do make any changes, please let me know! :)

alias -l moover return moo script v3.19

;usage: /moo <os|up|cpu|gfx|res|ram|hdd|net>
alias moo $iif($isid,return $stat($1),stat $1)
alias stat {
  if ($isid) {
    if (!$mooi(name)) { return lookup error }
    if (!$1) { return $moo(os) $moo(up) $moo(cpu) $moo(gfx) $moo(res) $moo(ram) $moo(hdd) $moo(net) }
    if ($1 == os) { return $moos($1) $mooi(ostitle) - $mooi(ossp) $brak($mooi(osver)) }
    if ($1 == up) { return $moos($1) $duration($mooi(up)) }
    if ($1 == cpu) { return $moos($1) $mooi(cpuname) $brak($mooi(cpuarch)) at $mooi(cpuspeed) $mooi(cpuload) }
    if ($1 == gfx) { return $moos($1) $mooi(gfxmake) $mooi(gfxproc) $mooi(gfxram) }
    if ($1 == res) { return $moos($1) $mooi($1) $mooi(resbit) $mooi(resrate) }
    if ($1 == ram) { var %moo.rammax = $mooi(rammax) | var %moo.ramuse = $mooi(ramuse) | return $moos($1) $+($round($calc(%moo.rammax - %moo.ramuse),0),/,%moo.rammax,MB) $+($chr(40),$round($calc((%moo.rammax - %moo.ramuse) / %moo.rammax * 100),2),%,$chr(41)) $moorambar($round($calc((%moo.rammax - %moo.ramuse) / %moo.rammax * 100),2)) }
    if ($1 == hdd) { return $moos($1) $mooi(hdd) }
    if ($1 == net) { return $moos($1) $iif($mooi(netname),$ifmatch $iif($mooi(netspeed), - $ifmatch, ) $mooi(netin) In $mooi(netout) Out, ) }
    elseif ($mooi($1)) { return $moos($1) $ifmatch }
  }
  var %out $relay($active)
  if (!$1) { %out $moo | return }
  if ($moo($1)) { %out $ifmatch }
}
alias mooecho {
  var %out echo $color(info2) -gat
  if (!$1) { %out $moo | return }
  if ($moo($1)) { %out $ifmatch }
}
alias statself mooecho $1-

alias -l relay { ;output relay v0.05 by HM2K
  ;default
  var %out echo $color(info2) -gat
  ;channel command
  var %chanmsg msg
  ;user action
  var %usermsg msg

  if ($modespl) {
    if ($1) {
      if (!$gettok($1,2,32)) {
        if ($left($1,1) != $chr(35)) { var %out %chanmsg $1 }
        elseif ($chan($1)) { var %out %chanmsg $1 }
      }
    }
    elseif (($nick) && ($nick != $me)) { var %out %usermsg $nick }
  }
  if ($isid) { return %out }
  %out $1-
}

;info - below are the useful or interesting wmi functions to use with the script
alias mooi {
  if ($1 == name) { return $wmiget(Win32_ComputerSystem).Name }
  if ($1 == ostitle) { return $wmiget(Win32_OperatingSystem).Caption }
  if ($1 == ossp) { return $wmiget(Win32_OperatingSystem).CSDVersion }
  if ($1 == osver) { return $wmiget(Win32_OperatingSystem).Version }
  if ($1 == osinstall) { var %time = $ctime($iif($wmiget(Win32_OperatingSystem).InstallDate,$+($mid($ifmatch,7,2),/,$mid($ifmatch,5,2),/,$mid($ifmatch,1,4)) $+($mid($ifmatch,9,2),:,$mid($ifmatch,11,2),:,$mid($ifmatch,13,2)))) | return $asctime(%time) $brak($duration($calc($ctime - %time)) ago) }
  if ($1 == osarc) { return $wmiget(Win32_OperatingSystem).OSArchitecture }
  if ($1 == up) { return $uptime(system,3) }
  if ($1 == cpuname) { return $wmiget(Win32_Processor).Name }
  if ($1 == cpuspeed) { return $+($wmiget(Win32_Processor).CurrentClockSpeed,MHz) }
  if ($1 == cpuload) { return $iif($wmiget(Win32_Processor).LoadPercentage,$brak($+($ifmatch,% Load)),) }
  if ($1 == cputotal) { return $wmiget(Win32_ComputerSystem).NumberOfProcessors }
  if ($1 == cpuarch) { return $mooarch($wmiget(Win32_Processor).Architecture) }
  if ($1 == gfxmake) { return $wmiget(Win32_VideoController,$moogfx).AdapterCompatibility }
  ;if ($1 == gfxproc) { return $wmiget(Win32_VideoController,$moogfx).VideoProcessor }
  if ($1 == gfxproc) { return $wmiget(CIM_VideoController,$moogfx).Description }
  if ($1 == gfxram) { return $bytes($wmiget(Win32_VideoController,$moogfx).AdapterRam,3).suf }
  if ($1 == res) { return $+($wmiget(Win32_VideoController,$moogfx).currenthorizontalresolution,x,$wmiget(Win32_VideoController).currentverticalresolution) }
  if ($1 == resbit) { return $wmiget(Win32_VideoController,$moogfx).currentbitsperpixel $+ bit }
  if ($1 == resrate) { return $wmiget(Win32_VideoController,$moogfx).currentrefreshrate $+ Hz }
  if ($1 == rammax) { return $round($calc($wmiget(Win32_OperatingSystem).TotalVisibleMemorySize / 1024),1) }
  if ($1 == ramuse) { return $round($calc($wmiget(Win32_OperatingSystem).FreePhysicalMemory / 1024), 1) }
  if ($1 == netname) { return $wmiget(Win32_PerfRawData_Tcpip_NetworkInterface,$mooni).Name }
  if ($1 == netspeed) { return $calc($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface,$mooni).CurrentBandwidth / 1000000) $+ MB/s }
  if ($1 == netin) { return $bytes($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface,$mooni).BytesReceivedPersec).suf }
  if ($1 == netout) { return $bytes($wmiget(Win32_PerfRawData_Tcpip_NetworkInterface,$mooni).BytesSentPersec).suf }
  if ($1 == hdd) { var %i 1 | while (%i <= $disk(0)) { if ($disk(%i).type == fixed) var %var %var $disk(%i).path $+($bytes($disk(%i).free).suf,/,$bytes($disk(%i).size).suf) | inc %i } | return %var }

  if ($1 == hddfull) {
    var %i 1
    while (%i <= $disk(0)) {
      if ($disk(%i).type == fixed) var %var %var $disk(%i).path $+($bytes($disk(%i).free).suf,/,$bytes($disk(%i).size).suf)
      inc %hddsumfree $bytes($disk(%i).free)
      inc %hddsumavail $bytes($disk(%i).size)
      inc %i
    }
    var %hddsumfull free/total: %hddsumfree $+ GB $+ / $+ %hddsumavail $+ GB
    .timerunsethddsumfree 1 3 unset %hddsumfree
    .timerunsethddsumavail 1 3 unset %hddsumavail
    return %hddsumfull
  }

  if ($1 == sound) { return $wmiget(Win32_SoundDevice).Name }
  if ($1 == mobo) { return $wmiget(Win32_BaseBoard).Manufacturer $wmiget(Win32_BaseBoard).Product }
}

;find active graphics card
alias -l moogfx {
  var %i = 1, %t = $wmiget(Win32_VideoController,-1).Availability
  while (%i < %t) {
    if ($wmiget(Win32_VideoController,%i).Availability == 3) { return %i }
    inc %i
  }
  .timerunset_t 1 3 unset %t
}

;find fastest network interface
alias mooni {
  var %i = 0, %s = 0, %n = 0
  %t = $wmiget(Win32_PerfRawData_Tcpip_NetworkInterface,-1).CurrentBandwidth
  while (%i < %t) {
    inc %i
    %ns = $wmiget(Win32_PerfRawData_Tcpip_NetworkInterface,%i).CurrentBandwidth
    if (%ns >= %s) {
      %s = %ns
      %n = %i
    }
  }
  .timerunset_ns 1 3 unset %ns
  return %n
}

;cpu architecture descriptors
alias -l mooarch {
  if ($1 == 0) { return x86 }
  if ($1 == 1) { return MIPS }
  if ($1 == 2) { return Alpha }
  if ($1 == 3) { return PowerPC }
  if ($1 == 6) { return Intel Itanium Processor Family (IPF) }
  if ($1 == 9) { return x64 }
}

;rambar - the famous rambar from the original script with a couple of changes
alias -l moorambar {
  if ($len($1) < 990) {
    var %moo.rb.size = 10
    var %moo.rb.used = $round($calc($1 / 100 * %moo.rb.size),0)
    var %moo.rb.unused = $round($calc(%moo.rb.size - %moo.rb.used),0)
    var %moo.rb.usedstr = $str(|,%moo.rb.used)
    var %moo.rb.unusedstr = $str(-,%moo.rb.unused)
    if ((%moo.rb.usedstr) && (%moo.rb.unusedstr)) return $+([,%moo.rb.usedstr,%moo.rb.unusedstr,])
  }
}

;Get WMI data - this is the most useful function here, this only works if mIRC has the $COM function, its very useful, but a little slow.
alias wmiget {
  var %com = cominfo, %com2 = cominfo2, %com3 = cominfo3
  if ($com(%com)) { .comclose %com }
  if ($com(%com2)) { .comclose %com2 }
  if ($com(%com3)) { .comclose %com3 }
  .comopen %com WbemScripting.SWbemLocator
  var %x = $com(%com,ConnectServer,3,dispatch* %com2), %x = $com(%com2,ExecQuery,3,bstr*,select $prop from $1,dispatch* %com3), %x = $comval(%com3,$iif($2,$2,1),$prop)
  if ($com(%com)) { .comclose %com }
  if ($com(%com2)) { .comclose %com2 }
  if ($com(%com3)) { .comclose %com3 }
  return %x
}

;backets - I got fed up of repeating the same thing
alias -l brak return $+($chr(40),$1-,$chr(41))

;uptime script - this is the short uptime script created to return your current update and retain your best uptime
on *:connect: up x
alias up { ;uptime v0.4
  $iif($timer(up) == $null,.timerup 0 60 up x) 
  if (($uptime(system,3) >= %up) || (%up == $null)) set %up $uptime(system,3) 
  $iif($1 == x,halt,$iif($chan,msg $chan,$iif($active == Status Window,echo,say)) $+(Windows,$OS) uptime: $uptime(system,1) best: $duration(%up))
}

#!uptime off
on *:text:!uptime:#: if (!$istok($moo.banchans,$chan,32)) { up | $repeatcheck(!uptime) }
#!uptime end

;moo triggers - public display, sharing the script and ctcp moo

#!moo off
on *:text:!moo*:#: if (!$istok($moo.banchans,$chan,32)) { $relay($chan) $moo($2) | $repeatcheck(!moo) }
#!moo end
#!getmoo off
on *:text:!getmoo:*: {
  if ($chan) { .notice $nick moo: To get $moover type: "/msg $me !getmoo" (set "/dccignore off" first) | $repeatcheck(!getmoo) | halt }
  else { .close -m $nick | .dcc send $nick $script | .notice $nick moo: Once you receive the script issue: "/load -rs $nopath($script) $+ ", and don't forget to do "/dccignore on" | $repeatcheck(!getmoo) | halt }
}
#!getmoo end
#ctcpmoo off
;ctcp *:*:*: if (($1 == MOO) || ($1 == VERSION)) { .ctcpreply $nick $1 $moover by HM2K | $repeatcheck(ctcpmoo) }
#ctcpmoo end

alias -l repeatcheck { ;v0.12 by HM2K - will disable the appropriate group if its flooded
  var %rep.lim = 3
  var %rep.t.lim = 25
  var %rep.t.expr = 10
  if (%rep.lockusr- [ $+ [ $nick ] ]) { echo $ifmatch | haltdef }
  inc $+(-u,%rep.t.lim,$chr(32),%,rep-,$nick,.,$len($strip($1-)),.,$hash($strip($1-),32)) 1
  if (%rep- [ $+ [ $nick ] $+ . $+ [ $len($strip($1-)) ] $+ . $+ [ $hash($strip($1-),32) ] ] == %rep.lim) {
    ;ignore -u60 $address($nick,5)
    if ($group($chr(35) $+ $1) == on) { .disable $chr(35) $+ $1 | .echo -gat $1 is $group($chr(35) $+ $1) due to a repeat flood from $iif($chan,$nick in $chan,$nick) $+ , to re-enable: /enable $chr(35) $+ $1 }
    .set $+(-u,%rep.t.expr,$chr(32),%,rep.lockusr-,$nick) 1
  }
}

;onload and onunload checks - making sure everything is as it should be
on *:load: { up x | if ($version < 6.16) { echo -a moo: you need mIRC v6.16 or greater to run this script, get the latest version from www.mirc.com/get.html | unload -rs $script | halt } }
on *:unload: { .timerup off | $iif($input(Do you want to remove the best uptime data,y,unset %up),unset %up,) | .echo $colour(info2) -gat $moover was unloaded, to reload type: /load -rs $script }

;the menus - only simple at the moment, however this script is designed to utilise the /moo and !moo triggers
menu channel,query {
  $moover
  .moo all (/moo): moo
  .moo uptime (/up): up
  .moo os: moo os
  .moo cpu: moo cpu
  .moo gfx: moo gfx
  .moo res: moo res
  .moo ram: moo ram
  .moo hdd: moo hdd
  .moo net: moo net
  .-
  .!moo trigger ( $+ $group(#!moo) $+ ):{
    if ($group(#!moo) != on) { .enable #!moo }
    else { .disable #!moo }
    .echo -ga moo: !moo is $group(#!moo)
  }
  .!uptime trigger ( $+ $group(#!uptime) $+ ):{
    if ($group(#!uptime) != on) { .enable #!uptime }
    else { .disable #!uptime }
    .echo -ga moo: !uptime is $group(#!uptime)
  }
  .!getmoo trigger ( $+ $group(#!getmoo) $+ ):{
    if ($group(#!getmoo) != on) { .enable #!getmoo }
    else { .disable #!getmoo }
    .echo -ga moo: !getmoo is $group(#!getmoo)
  }
  .ctcp moo trigger ( $+ $group(#ctcpmoo) $+ ):{
    if ($group(#ctcpmoo) != on) { .enable #ctcpmoo }
    else { .disable #ctcpmoo }
    .echo -ga moo: ctcpmoo is $group(#ctcpmoo)
  }
  .-
  .unload $remove($script,$scriptdir)
  ..are you sure?
  ...yes: { .unload -rs $script }
  ...no: { .echo $colour(info2) -gat $remove($script,$scriptdir) was NOT unloaded. }
}
;EOF
