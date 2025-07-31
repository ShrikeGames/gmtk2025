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

Day 2 (Plan):
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

Day3 (Plan):
- Make menus (including options)
- Step counter: Make it a visual graphic of a clock or something with a dramatic boss face
- Splash screen for the loop progressing
- Intro cutscene
- Tutorial???
- Add random modifiers to the bosses
- Give additional attacks due to increased speed AFTER the other character gets their turn (like in old FE)
- Keep adding new items, enemies, loot, etc
- Mouse controls for game
- Make art for the actual game part
- Upload to itch as an unlisted game (people watching the stream can play)
- keep the last reward you got for killing the boss if it was a boss fight
- Some way to see what your current items do after you have them in your rewards inventory
- Have some other benefit to Strength because Speed is so good in comparison

Item ideas:
- Weapon that scales off of HP
- 


 Day 4(Plan):
- Music
- Sound effects
- keep adding new items, enemies, loot, etc
- Polish and test
 - Partical effects, animations, etc

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