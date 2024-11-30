# /xunhide alias made by Xaifas on undernet Long time ago.
# Kept alive by Seb :D
###########################################


alias xunhide {
  hadd -mu4 noflood plx 1
  .timer 1 0 names -d $chan
}

raw 355:*:{
  if ( $hget(noflood,plx) ) {
    var %total = $numtok($4-,32)
    hadd -mu15 user list $4-
    var %x = $hget(user,0).item
    while ( %x > 0 ) {
      var %a = $gettok($hget(user,list),1-6,32)
      .msg x voice $3 %a
      .msg x devoice $3 %a
      hadd user list $gettok($hget(user,list),7-,32)
      dec %x 6
    }
    HALT
  }
}
raw 366:*:{ if ( $Hget(noflood,plx) ) { HALT } }
