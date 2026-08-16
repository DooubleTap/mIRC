; Duck Hunt Shop Script for mIRC
; Right-click in channel to access shop menu
; Usage: Right-click in a channel window and select "Duck Hunt Shop"
; Find the latest version of this script here: https://github.com/DooubleTap/mIRC

; Main shop menu
menu channel {
  Duck Hunt Shop
  .Ammo & Weapons
  ..1. Extra Bullet (7 XP): msg $active !shop 1
  ..2. Extra Clip (20 XP): msg $active !shop 2
  ..3. AP Ammo - Antiblindage (15 XP): msg $active !shop 3
  ..4. Explosive Ammo (25 XP): msg $active !shop 4
  .-
  .Equipment & Gear
  ..5. Repurchase Confiscated Gun (40 XP): msg $active !shop 5
  ..7. Sight (6 XP): msg $active !shop 7
  ..8. Infrared Detector (15 XP): msg $active !shop 8
  ..9. Silencer (5 XP): msg $active !shop 9
  ..11. Sunglasses (5 XP): msg $active !shop 11
  ..22. Ducks Detector (5 XP): msg $active !shop 22
  .-
  .Consumables & Boosts
  ..6. Grease (8 XP): msg $active !shop 6
  ..10. Four-leaf Clover (13 XP): msg $active !shop 10
  ..21. Piece of Bread (2 XP): msg $active !shop 21
  .-
  .Utility & Tools
  ..12. Spare Clothes (7 XP): msg $active !shop 12
  ..13. Brush for Gun (7 XP): msg $active !shop 13
  ..20. Decoy (8 XP): msg $active !shop 20
  .-
  .Attack Items
  ..14. Mirror (7 XP): msg $active !shop 14
  ..15. Handful of Sand (7 XP): msg $active !shop 15
  ..16. Water Bucket (10 XP): msg $active !shop 16
  ..17. Sabotage (14 XP): msg $active !shop 17
  ..23. Mechanical Duck (50 XP): msg $active !shop 23
  .-
  .Insurance
  ..18. Life Insurance (10 XP): msg $active !shop 18
  ..19. Liability Insurance (5 XP): msg $active !shop 19
  .-
  .Shop Info: duckhunt.shop.info
  .-
  .Web Store: duckhunt_web_store
}

; Alias to display shop information
alias duckhunt.shop.info {
  echo -at [DuckHunt] *** Duck Hunt Shop Information ***
  echo -at [DuckHunt] Use !shop <number> in channel to buy items
  echo -at [DuckHunt] Items are organized by category in the right-click menu
  echo -at [DuckHunt] XP costs are shown next to each item
  echo -at [DuckHunt] Most effects last 24 hours unless specified
  echo -at [DuckHunt] *** Available Categories ***
  echo -at [DuckHunt] Ammo & Weapons: Basic ammunition and damage boosts
  echo -at [DuckHunt] Equipment & Gear: Accuracy and detection improvements
  echo -at [DuckHunt] Consumables & Boosts: Temporary bonuses and luck items
  echo -at [DuckHunt] Utility & Tools: Maintenance and duck attraction items
  echo -at [DuckHunt] Attack Items: Items to use against other players
  echo -at [DuckHunt] Insurance: Protection against accidents and penalties
  echo -at [DuckHunt] *** End of Shop Info ***
}

alias duckhunt_web_store { run https://duckhunt-irc.vercel.app/ }

; Load message
on *:LOAD: {
  echo -a *** Duck Hunt Shop Script Loaded ***
  echo -a * Right-click in any channel for Duck Hunt Shop menu
  echo -a * Use /duckhunt.shop.info for detailed information
  echo -a *** Script by: Seb ***
}
