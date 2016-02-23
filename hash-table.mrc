/* Original Source: http://www.hawkee.com/snippet/5493/ 
* 
* NOTE: I have modified this slightly. I've changed the dialog code. Maybe another thing or two?
*       I have made the dialog code 'larger'.. I didn't like the small dialog. 
*/

menu status,channel,query {
  - 
  Hash Table Editor:hedit
  -
}
alias hedit { dialog -m hedit hedit }
dialog hedit {
  title "Hash Table Editor"
  size -1 -1 259 230
  option dbu
  edit "Coded By: Imrac", 1, 1 219 257 10, read autohs right
  box "Tables", 2, 2 3 75 216
  list 3, 6 11 65 182, sort vsbar
  button "Add", 4, 7 194 32 11
  button "Remove", 5, 40 194 32 11
  button "Rename", 6, 7 206 32 11
  button "Clear", 7, 40 206 32 11
  box "Items", 8, 80 3 178 216
  list 9, 85 11 65 181, sort vsbar
  button "Add", 10, 83 206 32 11
  button "Remove", 11, 117 206 32 11
  box "Data", 12, 155 9 98 63
  text "Item", 13, 158 17 22 6
  edit "", 14, 158 25 92 11, autohs
  text "Data", 15, 158 37 20 6
  edit "", 16, 158 45 92 11, autohs
  button "Update", 17, 189 58 30 11
  box "Search", 18, 155 74 98 51
  check "Data", 19, 179 83 24 9
  check "Table", 20, 207 83 24 9
  edit "", 21, 158 95 92 11, autohs
  check "Regular Ex.", 22, 158 111 35 9
  button "Clear", 23, 215 109 35 11
}

on *:Dialog:hedit:*:*:{
  if ($devent == init) {
    var %x = $hget(0)
    did -o $dname 2 1 Tables $+($chr(40),%x,$chr(41))
    did -b $dname 5-23
    while (%x) {
      did -a $dname 3 $hget(%x)
      dec %x
    }
    did -f $dname 3
  }
  if ($devent == sclick) {
    var %tb = $did($dname,3).seltext
    var %it = $did($dname,9).seltext

    If ($did == 1) { did -jk $dname 3 }

    ; // Click On Table List //
    If ($did == 3) && (%tb) {
      ; meh
      did -ek $dname 5-10
      did -uk $dname 9
      iu
      If ($did($dname,21).text) { itemsearch }
      did -ok $dname 1 1 Table: ' $+ %tb $+ ' Items: $hget(%tb,0).item Size: $hget(%tb).size
    }

    ; // Click On Item List //
    If ($did == 9) && ($did($dname,$did).seltext) {
      did -e $dname 11-17
      var %t = $did($dname,3).seltext
      var %i = $did($dname,9).seltext
      did -o $dname 14 1 %i
      did -o $dname 16 1 $hget(%t,%i)
    }

    ; // ADD NEW HASH TABLE BUTTON //
    If ($did == 4) {
      var %n = $input(Hash Table Name:,equd,New Hash Table)
      If (%n == $null) { derror -c No Name Given }
      ElseIf ($regex(%n,/ /)) {  derror -c Hash Table Name Can Not Contain Spaces }
      ElseIf ($hget(%n)) {  derror -c Hash Table Name Already Exists }
      Else {
        var %s = $input(Hash Table Size:,equd,New Hash Table,100)
        If (%s == $null) {  derror -c No Size Specified }
        ElseIf (%s !isnum 1-) || (%s != $int(%s)) {  derror -c Invalid Size Specified }
        Else {
          hmake %n %s
          did -o $dname 1 1 Success: Made Hash Table.
          did -a $dname 3 %n
          did -o $dname 2 1 Tables $+($chr(40),$hget(0),$chr(41))
        }
      }
    }

    ; // Remove Hash table //
    If ($did == 5) {
      If ($input(Are You Sure You Want To Remove Hash Table ' $+ %tb $+ ', wudy, Remove Table)) {
        hfree %tb
        did -o $dname 1 1 Success: Removed Hash Table.
        did -d $dname 3 $did($dname,3).sel
        did -r $dname 14,16,9,21
        did -b $dname 5-23
        did -o $dname 2 1 Tables $+($chr(40),$hget(0),$chr(41))
        did -o $dname 8 1 Items
      }
    }

    ; // Rename Hash Table
    If ($did == 6) {
      var %n = $input(Hash Table's New Name:,equd,Rename Hash Table)
      If (%n == $null) { derror -r No New Name Specified }
      ElseIf ($regex(%n,/ /)) { derror -r Hash Table Name Can Not Contain Spaces }
      Else {
        did -o $dname 1 1 Success: Renamed Hash Table.
        hrename %tb %n
        did -d $dname 3 $did($dname,3).sel
        did -ac $dname 3 %n
      }
    }

    ; // Clear Hash Table //
    If ($did == 7) {
      var %c = $input(Are You Sure You Want To Clear All Items From ' $+ %tb $+ '?, wudy, Clear Table)
      If (%c) { hdel -w %tb * | iu | did -o $dname 1 1 Success: Removed Hash Table. }
    }

    ; // Add item to table //
    If ($did = 10) {
      var %ni = $input(New Item Name:,equd,Add Item) 
      If (%ni == $null) { derror -a No Item Name Specified }
      ElseIf ($regex(%ni,/ /)) { derror -a Item Name Can Not Contain Spaces }
      ElseIf ($hget(%tb,%ni)) { derror -a Item Already Exists }
      Else {
        var %nd = $input(New Item Data:,equdv,Add Item)
        If (%nd == $cancel) { derror -a Cancelled }
        Else {
          hadd %tb %ni %nd
          did -o $dname 1 1 Success: Added Item.
          itemsearch
        }
      }
    }

    ; // Remove an item from the table //
    If ($did = 11) {
      var %yn = $input(Are You Sure You Want To Delete ' $+ %it $+ '.,wdyu,Remove Item)
      if (%yn) {
        hdel %tb %it
        itemsearch
        did -o $dname 1 1 Success: Removed Item.
      }
    }

    ; // Update an item //
    If ($did == 17) {
      var %ni = $did($dname,14).text
      If (%ni == $null) { derror -u No Item Name Given }
      ElseIf ($regex(%ni,/ /)) { derror -u Item Name Can Not Contain Spaces }
      Else {
        did -o $dname 1 1 Success: Updated Item.
        hdel %tb %it
        hadd %tb %ni $did($dname,16).text
        did -d $dname 9 $did($dname,9).sel
        did -ac $dname 9 %ni
        If ($did($dname,21).text) { itemsearch }
      }
    }
    If ($did == 19) { if ($did($dname,21).text) { itemsearch  } }
    If ($did == 20) { if ($did($dname,21).text) { itemsearch  } }
    If ($did == 22) { if ($did($dname,21).text) { itemsearch  } }
    If ($did == 23) { did -r $dname 21 | did -u $dname 19,20,22 | itemsearch }
  }

  If ($devent == edit) {
    If ($did = 21) { itemsearch | did -f $dname 21 }  
  }
}


alias -l itemsearch {
  If ($did($dname,21).text) {
    var %t = $did($dname,3).seltext
    var %sel = $did($dname,9).seltext
    var %f = $iif($did($dname,22).state,r,w)
    var %f = $iif($did($dname,20).state,$upper(%f),$lower(%f))
    var %d = $iif($did($dname,19).state,.$true,)
    var %s = $did($dname,21).text
    var %x = $iif(%d,$hfind(%t,%s,0,%f).data,$hfind(%t,%s,0,%f))
    did -o $dname 8 1 Items $+($chr(40),%x,/,$hget(%t,0).item,$chr(41))
    did -r $dname 9
    while (%x) {
      if (%d) var %st = $hfind(%t,%s,%x,%f).data
      else var %st = $hfind(%t,%s,%x,%f)
      did -a $dname 9 %st
      dec %x
    }
    If (%sel) && ($didreg($dname,9,/^ $+ %sel $+ $/)) { did -c $dname 9 $v1 }
    Else {
      did -r $dname 14,16
      did -b $dname 11-17
    }
  }
  Else {
    iu
  }
}

alias -l iu {
  var %tb = $did($dname,3).seltext
  var %it = $did($dname,9).seltext
  var %x = $hget(%tb,0).item
  did -r $dname 9
  did -o $dname 8 1 Items $+($chr(40),%x,$chr(41))
  did -e $dname 18-23
  while (%x) { did -a $dname 9 $hget(%tb,%x).item | dec %x }
  If (%it) && ($didreg($dname,9,/^ $+ %it $+ $/)) { did -c $dname 9 $v1 }
  Else {
    did -r $dname 14,16
    did -b $dname 11-17
  } 
}



alias hrename {
  var %t1 = $1, %t2 = $2
  hmake %t2 $hget(%t1).size
  var %x = $hget(%t1,0).item
  while (%x) {
    hadd %t2 $hget(%t1,%x).item $hget(%t1,%x).data
    dec %x
  }
  hfree %t1
}

alias -l derror {
  If ($1 == -c) { did -o $dname 1 1 Error: Unable To Create Hash Table. ( $+ $2- $+ ) }
  ElseIf ($1 == -r) { did -o $dname 1 1 Error: Unable To Rename Hash Table. ( $+ $2- $+ ) }
  ElseIf ($1 == -a) { did -o $dname 1 1 Error: Unable To Add Item. ( $+ $2- $+ ) }
  ElseIf ($1 == -u) { did -o $dname 1 1 Error: Unable To Update Item. ( $+ $2- $+ ) }
}
