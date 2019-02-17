# gnuworld.mrc - Seb @ undernet version 2.1.5 on 17/02/2019
# Setup: Load into Remotes. Follow Instructions. Right click in channels and on users. Share.
#
# This script's purpose is to have an easy access to all the commands available to you with your mouse. 
# ALL of the latest X Commands and options are found here https://cservice.undernet.org/docs/xcmds.txt
# For Questions with Registered channel issues and X Just join #CService and ask your question. 
# For questions about this script, join #Social and ask Seb 
# The latest version of this script is found here: https://github.com/SebLemery/mIRC/blob/master/gnuworld.mrc
#
# version 1: Started the script with some commands for channel operators. Ban kick op voice deop devoice. 
# July 2018  it was simple stuff. This version was only for me and never shared, but one day someone asked for it
#
#
# version 2: I added all the commands from 0 to 500 for undernet's specific version of GnuWorld. and shared it 
# July 2018  to the guy who asked for it. added it to github with a permanent link and it got shared! :p like a lot.
#                  Since then, i now moved it to a GitHub page on my account. 
#
#
# version 2.1: Added commands from 501 to 1000 so everyone can use it, even network admins. Will also add
# Dec 2018     all the uworld's commands. the next version will probably also contain most of the commands used
#                     by Network Operators for quick glines and channel fixes. There will be a setting that needs to be turned on 
#                     to be able to see admin commands. 
#
#
# version 2.1.5: Added nicklist commands and separated the menus. 
# Feb 2019
#
###############

#right click options in channel
menu channel { 
  [GnuWorld]
  .[800]
  ..Say:msg %gnuworld say # $$?="Text"
  ..ServNotice:msg %gnuworld servnotice # $$?="Text"
  .[750]
  ..Register:msg %gnuworld register # $$?="To who?"
  ..Purge
  ...With Reop:msg %gnuworld purge # $$?="Reason for purge"
  ...Without reop:msg %gnuworld purge # -noop $$?="Reason for purge" 
  ..RemoveAll:msg %gnuworld removeall #
  .[600]
  ..RemIgnore:msg %gnuworld showignore | msg x remignore $$?="mask"
  ..ScanHost:msg %gnuworld scanhost $$?="*host*"
  ..ScanUname:msg %gnuworld scanuname $$?="*username*" -all
  ..ScanEmail:msg %gnuworld scanemail $$?="*email*" -all
  .[500]
  ..Part:.msg %gnuworld part #
  .[450-499]
  ..Join:.msg %gnuworld join #
  ..Set
  ...Autojoin
  ....[ON]:.msg %gnuworld set # autojoin on
  ....[OFF]:.msg %gnuworld set # autojoin off
  ...Massdeoppro
  ....1:.msg %gnuworld set # MASSDEOPPRO 1
  ....2:.msg %gnuworld set # MASSDEOPPRO 2
  ....3:.msg %gnuworld set # MASSDEOPPRO 3
  ....4:.msg %gnuworld set # MASSDEOPPRO 4
  ....5:.msg %gnuworld set # MASSDEOPPRO 5
  ....6:.msg %gnuworld set # MASSDEOPPRO 6
  ....7:.msg %gnuworld set # MASSDEOPPRO 7
  ...noop
  ....[ON]:.msg %gnuworld set # noop on
  ....[OFF]:.msg %gnuworld set # noop off
  ...strictop
  ....[ON]:.msg %gnuworld set # strictop on
  ....[OFF]:.msg %gnuworld set # strictop off 
  .[400-449]
  ..Clearmode:.msg %gnuworld clearmode #
  ..Modinfo
  ...Invite:.msg %gnuworld modinfo # INVITE $$?="ON OR OFF"
  .[100-399]
  ..Invite:.msg %gnuworld invite #
  .[50]
  ..Topic:.msg %gnuworld topic # $$?="topic"
  .[1]
  ..Banlist:.msg %gnuworld banlist #"
  ..Status:.msg %gnuworld status #" 
  .[0]
  ..access:.msg %gnuworld access # $$?="<*user*|=nickname*>" -modif
  ..chaninfo:.msg %gnuworld chaninfo #
  ..help
  ...Help:.msg %gnuworld help
  ..lbanlist:.msg %gnuworld lbanlist # $$?="<*!*user@*.host>"
  ..login:.msg %gnuworld login  $$?="Your User" $$?="Your Password"
  ..motd:.msg %gnuworld motd
  ..showcommands:.msg %gnuworld showcommands #
  ..showignore:.msg %gnuworld showignore
  ..suspendme
  ...Are you sure
  ....This is only irreversible by a CService Admin
  .....Yes:echo -at 14[4WARNING14] You are about to suspend your own account. To do this, you have to follow those instructions. | .msg x help suspendme
  .....No:echo -at 14[4WARNING14] You almost suspend your own account..
  .[OPER]
  ..operjoin:.msg %gnuworld operjoin #
  ..operpart:.msg %gnuworld operpart # 
  .-
  .Support
  ..Channels
  ...#CService - Support channel for Registered channel issue And X Questions
  ....Join now:join #CService
  ...#usernames - Support channel for usernames issues
  ....Join now:join #usernames
  ...#userguide - General support channel for undernet
  ....Join now:join #userguide
  ...#user-com - UnderNet User Committee support channel
  ....Join now:join #user-com
  ...#zT - Zero Tolerance channel against abuse on undernet
  ....Join now:join #zT
  ...#mircscripting - Main mIRC Scripting channel on undernet
  ....Join now:join #mircscripting
  ...#GNUWorld - GnuWorld's support channel
  ....Join now:join #gnuworld
  ...#Tcl-Help - TCL Scripting support channel
  ....Join now:join #tcl-help
  ..Website
  ...This script:run https://github.com/SebLemery/mIRC/blob/master/gnuworld.mrc
  ...Services
  ....CService's username page:run https://cservice.undernet.org/live/
  ...Committees
  ....Coder Committee:run http://coder-com.undernet.org/
  ....Undernet Channel Service:run https://cservice.undernet.org/
  ....Undernet Routing Committee:run http://www.routing-com.undernet.org/
  ....Undernet User Committee:http://www.user-com.undernet.org/
  ...Undernet's AUP:run http://www.user-com.undernet.org/documents/aup.php
}

#Right click options on nick
menu nicklist { 
  [GnuWorld]
  .[400-449]
  ..Adduser:.msg %gnuworld adduser $chan $+(=,$$1) $$="What level?"
  ..Modinfo
  ...Automode:.msg %gnuworld modinfo automode $+(=,$$1) $$?="OP VOICE or NONE"
  ...Remuser:.msg %gnuworld remuser # $+(=,$$1)
  .[100-399]
  ..Op:.msg %gnuworld op # $$1
  ..Deop:.msg %gnuworld Deop # $$1
  ..Suspend:.msg %gnuworld suspend # $+(=,$$1) $$?="<Duration 1h 2d 3m>" $$?="Level" $$?="Reason"
  ..Unsuspend:.msg %gnuworld unsuspend # $+(=,$$1)
  .[75]
  ..Ban:.msg %gnuworld ban # $$1 $$?="Ban Duration This can be set like 400s 300m 2d and zero is perm" $$?="Level (optional)" $$?="Reason"
  .[50]
  ..Kick:.msg %gnuworld kick # $$1  $$?="Reason?"
  .[25]
  ..Voice:.msg %gnuworld voice # $$1
  ..Devoice:.msg %gnuworld devoice # $$1
  .[0]
  ..access:.msg %gnuworld access # $+(=,$$1) -modif
  ..lbanlist:.msg %gnuworld lbanlist # $+(=,$$1)
  ..verify:.msg %gnuworld verify  $$?="nickname"
}

on *:LOAD:{ 
  echo -a [gnuworld.mrc] woohoo you have successfully loaded gnuworld.mrc Right click in a channel or on a nickname to use
  set %gnuworld x@channels.undernet.org
  echo -a [gnuworld.mrc] i've set your GnuWorld's (X) nickname to x@channels.undernet.org
  echo -a [gnuworld.mrc] If you have any questions, join #social and ask Seb or push a commit to github
  echo -a [gnuworld.mrc] Always check for updates here: https://github.com/SebLemery/mIRC/blob/master/gnuworld.mrc
  echo -a [gnuworld.mrc] This version is: 2.1.5 from 17/02/2019
}
