## whowas (/ww) mods by Sebastien ~ ##Sebastien @ freenode
## If you touch at something below this line, you WILL fuckup something.
##----------------------------------------------------------------------

alias ww { .enable #whowas | whowas $1 } 
#whowas on
raw 314:*: { 
  echo $color(notice) -ai2 14[7###14] $iif($me == $2,Looking at yourself?,/whowas7 $2)
  echo -ai2 2Nick:14 $2 
  echo -ai2 2Address:14 $3 $+ @ $+ $4 
  echo -ai2 2FullName:14 $6-   
  halt 
} 
raw 312:*: { 
  echo -ai2 2Server:14 $3
  echo -ai2 2Description:14 $4- 
  halt 
} 
raw 330:*:{ echo -ai2 2Username: 4 $+ $3 $+  | halt } 

raw 369:*:{ 
  echo $color(notice) -ai2 14[7###14] End of Whowas for7 $2  
  linesep -a
  .disable #whois 
  halt 
} 
#whowas end

#EOF
