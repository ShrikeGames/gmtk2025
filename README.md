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
 - TODO add random modifiers to the bosses
- Items can be perma or just for the loop
- Items need rarities
- "Though, there has to be some way to tell the player that there is more to discover." If we number each item and show the total for that rarity people will know how much to expect. Like you might see on trading cards.
- Need a way to process inventory of items in order to apply to combat
- Add reset loop logic for when losing or beating boss
- Add ability to carry over some equipment
- Add ability to see equipment and what they do
- For stats
 - HP is obvious
 - Armor is damage reduction (flat) but doesn't restore normally
 - Speed: If you outspeed the enemy enough you get extra attacks (like FE)
 - Build: Weapon loot should require certain "Build" stat or others as requirements. Build allows you to use larger weapons. If you do not meet the requirements for build you can use it but it subtracts from your speed. And enemies could end up getting extra attacks on you instead.
 Rename Build to Strength
 - Damage self expanitory
 - Vision also self expanitory
- If you can't move with your remaining steps it needs to be treated as 0, or click a button to give up

Day3 (Plan):
- Make menus (including options)
- Mouse controls for game
- Make art for the actual game part
- Keep adding new items, enemies, loot, etc

Day 4(Plan):
- Music
- Sound effects
- keep adding new items, enemies, loot, etc
- Polish and test

Day 5(Plan):
- Test and fix issues
- Setup the itch.io page

Stretch goals:
- Trapped items
- Fights with multiple enemies
- Possibly day/night cycle