# GMTK 2025 Game Jam
GMTK 2025 Game Jam entry.

Day 1:
- Random map generation
- player character can move around the map
- Different terrain types (road, empty plain, forest, hills, mountains, water)
- Randomized loot that a can affect stats or do special things
 (bypass terrain)
- Loot is selected from 3 random choices
- the random choices will not repeat
- The special items will not appear again once you take them
- Terrain has different effects (block movement, block vision, enhance vision, limit vision, slow you down, speed you up, etc)
- An attempt to avoid softlocks
- Step counter until the end of the loop
- Our stats generally planned out
- Line of sight implemented and working fully now

Day 2:
- Add combat
 - random encounters
 - boss fight itself (when we run out of steps)
- Items can be perma or just for the loop
- Items need rarities
- "Though, there has to be some way to tell the player that there is more to discover." If we number each item and show the total for that rarity people will know how much to expect. Like you might see on trading cards.
- Need a way to process inventory of items in order to apply to combat
- Add reset loop logic for when losing or beating boss
- You get one legendary or unique reward (which you should be able to carry over to the next run...)
- Add ability to see equipment
- For stats
 - HP is obvious
 - Armor is damage reduction (flat) but doesn't restore normally
 - Speed: If you outspeed the enemy enough you get extra attacks (like FE)
 - Strength: Half of it applies to damage
 - Damage self expanitory
 - Vision also self expanitory
- If you can't move with your remaining steps it needs to be treated as 0, or click a button to give up

Day3:
- Make menus (including options)
- Step counter: Make it a visual graphic of a clock or something with a dramatic boss face
- Boss graphic
- Bonus attacks due to outspeeding are now limited but items can increase it
- Made art for the actual game part
- Added new items, enemies, loot, etc
- Added quit button to bottom right of game
- Improved inventory system to be able to show icons if they exist in the config
- Created splash screen for the loop progressing
- You now keep the last reward when entering a new loop even if it was an item

Day 4(Plan):
- Music
- Sound effects
- keep adding new items, enemies, loot, etc
- Add random modifiers to the bosses
- Have some other benefit to Strength because Speed is so good in comparison
- Polish and test
 - Partical effects, animations, etc
 - Damage numbers in combat
 - Shaders
  - (Done) https://godotshaders.com/shader/line-jitter-stroke-shake-effect/  In the combat scene
  - (Done) https://godotshaders.com/shader/random-displacement-animation-easy-ui-animation/  Enemies and player on world map
  - https://godotshaders.com/shader/universal-transition-shader/ Switching between main menu and game
  - (Done) https://godotshaders.com/shader/moving-circles-effect-with-size-depending-on-a-gradient/ Background of reward screen and main menu?
  - (Done) https://godotshaders.com/shader/2dradial-shine-2/ When picking rewards
  - https://godotshaders.com/shader/2d-vertical-pixel-dissolving-wave/ death animation in combat scene?
  - https://godotshaders.com/shader/2d-burn-dissolve-from-point-v-1-0/ burn the rewards not taken?
 - (Done) Line of Sight have previously discovered tiles just faded out not invisible
 - Intro cutscene
  - Voiced
  - Use animated sprite2d to have basic slides for it?
 - Tutorial
  - Show the player
  - Show the controls
  - Show the clock
  - Show the stats
  - Show the inventory
 - Settings menu: Add input box for initial seed
 - Settings menu: Add option to skip tutorial
 - Game title: He Is Looping
 - Handle case where if you Reject the reward for the boss kill you get softlocked? (I think you would anyways)
 - Switch to the faster BGM for the last segement of the timer
 - Have boss react to player fighting them again after the player previously lost
 - Hills colours need to change
 - Add visible grass to the empty tiles
- Upload to itch as an unlisted game (people watching the stream can play)



Day 5(Plan):
- Test and fix issues
- Setup the itch.io page

Stretch goals:
- Trapped items
- Fights with multiple enemies
- Possibly day/night cycle
- Make combat have random dice rolls, items can affect how many dice you get
- Add additional modifiers to the game for each boss you defeat
	EG: Enemies are invisible, you cannot see them so have to memorize their locations when you learn of them
- Have items that can perma change the terrain or other effects
- Dynamic enemy art by mashing together body part images based on their stats
- Save/load progress
- Mouse controls for game
- Some way to see what your current items do after you have them in your rewards inventory