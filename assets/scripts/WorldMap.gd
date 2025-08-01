extends Node2D

class_name WorldMap

@export var reward_choice_screen:RewardChoiceScreen
@export var combat_screen:CombatScreen
@export var tiles_node:Node2D
@export var player_image:Sprite2D
@export var loop_splash_screen:LoopSplashScreen
@export var regular_music:AudioStreamPlayer
@export var faster_music:AudioStreamPlayer

# map settings
# TODO allow user to enter one of their own
@export var map_width:int = 32
@export var map_height:int = 14
@export var tile_width:int = 50
@export var tile_height:int = 50
var spread_range:int = 2
var number_of_random_seed_points:int = 40
# stats
@export var side_bar:SideBar
@export var steps:float = 99
var play_faster_music:bool = false

@export var number_of_enemies:int = 10
var last_selected_reward_id:int
var rewards:Array[Dictionary]

var map_tiles:Array[Array]
var map_tile_resource:Resource = preload("res://assets/scenes/MapTile.tscn")
var inventory_item_resource:Resource = preload("res://assets/scenes/InventoryItem.tscn")
var player_position:Vector2i

var fighting_boss:bool = false

var boss_enemy_stats:Dictionary = {}

var HAS_ITEM_CHANCE:float = 0.05

var DIRECTION_NONE:int = 0
var DIRECTION_UP:int = 1
var DIRECTION_RIGHT:int = 2
var DIRECTION_DOWN:int = 3
var DIRECTION_LEFT:int = 4
var move_direction:int = DIRECTION_NONE
var time_since_last_moved:float
var movement_delay_time_sec:float = 0.1

var TILE_EMPTY:int = 0
var TILE_WALL:int = 1
var TILE_WATER:int = 2
var TILE_HILLS:int = 3
var TILE_FOREST:int = 4
var TILE_ROAD:int = 5
var TILE_PLAYER:int = 9
var ROOM_WALL_TILE_TYPES:Array[int] = [TILE_WALL, TILE_WATER, TILE_FOREST, TILE_HILLS]

var combat_timer:float
var combat_auto_timer:float = 1.5

var time_since_selected_reward:float
var time_to_wait_before_closing_reward_screen:float = 1.5

func _on_ready() -> void:
	seed(Global.rng_seed.hash())
	init_loop()

func init_loop():
	time_since_selected_reward = 0
	var last_reward:Dictionary = {}
	if rewards.size() > 0:
		last_reward = rewards[rewards.size()-1]
		var special:String = last_reward.get("special", "")
		if special == "flippers":
			Global.has_flippers = true
		elif special == "climbing_gear":
			Global.has_climbing_gear = true
	rewards = []
	last_selected_reward_id = -1
	fighting_boss = false
	Global.has_flippers = false
	Global.has_climbing_gear = false
	for tile in tiles_node.get_children():
		tile.queue_free()
	var inventory_id:int = 0
	for inventory_item in side_bar.inventory_items_node.get_children():
		if inventory_id == side_bar.inventory_items_node.get_child_count()-1:
			inventory_item.position.x = 75
		else:
			inventory_item.queue_free()
		inventory_id += 1
	
	side_bar.update_stats(self)
	# Create 2d array of tiles
	# use rules to generate the different types of tiles
	map_tiles = generate_map(tiles_node, map_width, map_height, tile_width, tile_height)
	time_since_last_moved = 0
	# set the player starting location
	var starting_x:int = int(map_width*0.5)
	var starting_y:int = int(map_height*0.5)
	player_position = Vector2i(starting_x, starting_y)
	if Global.hp < 12:
		Global.hp = 12
	Global.max_steps = 99
	steps = 99
	if play_faster_music:
		faster_music.stop()
		regular_music.play()
		
	play_faster_music = false
	reward_choice_screen.visible = false
	for reward_card in reward_choice_screen.reward_cards:
		reward_card.reset()
	combat_screen.visible = false
	combat_screen.combat_results_screen.visible = false
	loop_splash_screen.visible=true
	loop_splash_screen.title_text.text = "[center]Now Starting Loop %d![/center]"%[Global.loop]
	var base_boss_enemy_stats:Dictionary = {
		"hp": 50,
		"armor": 5,
		"speed": 5,
		"damage": 5,
		"strength": 4,
		"image": "res://assets/images/sprite_sheets/Boss.png"
	}
	boss_enemy_stats = generate_enemy_stats(base_boss_enemy_stats, 50*(Global.boss_kills+1))
	loop_splash_screen.boss_image.texture = load(base_boss_enemy_stats["image"])
	loop_splash_screen.enemy_stats_text.text = combat_screen.update_enemy_stats_text(boss_enemy_stats)
	
	# draw the tiles to the screen around the player
	update_screen(player_position, side_bar.calculated_stats["vision"])
	Global.save_settings()

func generate_map(p_tiles_node:Node2D, p_map_width:int, p_map_height:int, p_tile_width:int, p_tile_height:int) -> Array[Array]:
	var new_map_tiles:Array[Array] = []
	# populate the map array with tiles
	for y in range(0, p_map_height):
		new_map_tiles.append([])
		for x in range(0, p_map_width):
			var new_tile:MapTile = generate_tile(map_tile_resource.instantiate(), x, y, p_tile_width, p_tile_height)
			# add to the array
			new_map_tiles[y].append(new_tile)
			# add to the stage
			p_tiles_node.add_child(new_tile)
	
	# put random tiles ofrandom types in random spots
	# keep track of those spots in a list
	# gothrough that list and recursssively check nearby tiles and have a % chance
	# to convert them to the same tile type if they are TILE_EMPTY
	var random_seed_points:Array[MapTile] = []
	for i in range(0, number_of_random_seed_points):
		var random_seed_point:Vector2i = Vector2i(randi_range(0, map_width-1), randi_range(0, map_height-1))
		var type:int = ROOM_WALL_TILE_TYPES[randi_range(0, ROOM_WALL_TILE_TYPES.size()-1)]
		var item_id:int = -1
		if randf() < 0.5:
			item_id = 0
		var new_tile:MapTile = generate_tile(new_map_tiles[random_seed_point.y][random_seed_point.x], random_seed_point.x, random_seed_point.y, p_tile_width, p_tile_height, type, item_id)
		random_seed_points.append(new_tile)
	
	random_spread(new_map_tiles, random_seed_points, p_tile_width, p_tile_height)
	
	# a winding road around the permeter of the map
	var road_x:int = 2
	var road_y:int = 2
	var road_tile_count:int = 0
	
	while road_x < map_width-4:
		if road_tile_count > 1 and road_tile_count%4 == 0:
			road_y += randi_range(-1, 1)
			road_x -= 1
		road_x = wrapi(road_x, 0, map_width)
		road_y = wrapi(road_y, 0, map_height)
		generate_tile(new_map_tiles[road_y][road_x], road_x, road_y, p_tile_width, p_tile_height, TILE_ROAD, -1)
		road_tile_count += 1
		road_x += 1
		
	while road_y < map_height-4:
		if road_tile_count%4 == 0:
			road_x += randi_range(-1, 1)
			road_y -= 1
		road_x = wrapi(road_x, 0, map_width)
		road_y = wrapi(road_y, 0, map_height)
		generate_tile(new_map_tiles[road_y][road_x], road_x, road_y, p_tile_width, p_tile_height, TILE_ROAD, -1)
		road_tile_count += 1
		road_y += 1
	while road_x > 3:
		if road_tile_count > 1 and road_tile_count%4 == 0:
			road_y += randi_range(-1, 1)
			road_x += 1
		road_x = wrapi(road_x, 0, map_width)
		road_y = wrapi(road_y, 0, map_height)
		generate_tile(new_map_tiles[road_y][road_x], road_x, road_y, p_tile_width, p_tile_height, TILE_ROAD, -1)
		road_tile_count += 1
		road_x -= 1
	while road_y > 2:
		if road_tile_count%4 == 0:
			road_x += randi_range(-1, 1)
			road_y += 1
		road_x = wrapi(road_x, 0, map_width)
		road_y = wrapi(road_y, 0, map_height)
		generate_tile(new_map_tiles[road_y][road_x], road_x, road_y, p_tile_width, p_tile_height, TILE_ROAD, -1)
		road_tile_count += 1
		road_y -= 1
	
	road_x = int(map_width*0.5)
	road_y = int(map_height*0.5)
	
	while road_x < map_width-4:
		if road_tile_count > 1 and road_tile_count%4 == 0:
			road_y += randi_range(-1, 1)
			road_x -= 1
		road_x = wrapi(road_x, 0, map_width)
		road_y = wrapi(road_y, 0, map_height)
		generate_tile(new_map_tiles[road_y][road_x], road_x, road_y, p_tile_width, p_tile_height, TILE_ROAD, -1)
		road_tile_count += 1
		road_x += 1
		
	
	# add random enemies to the map
	for enemy_id in range(0, number_of_enemies):
		# select a random tile to put the enemy on
		var random_x:int = randi_range(0, map_width-1)
		var random_y:int = randi_range(0, map_height-1)
		var existing_tile:MapTile = new_map_tiles[random_y][random_x]
		existing_tile.item_id = 1
		# generate a random enemy
		var base_enemy_stats:Dictionary = {
			"hp": 3,
			"armor": 0,
			"speed": 1,
			"damage": 1,
			"strength": 1,
			"image": "res://assets/images/sprite_sheets/Enemy%d.png"%[randi_range(0, 2)]
		}
		var enemy_stats:Dictionary = generate_enemy_stats(base_enemy_stats, 10*pow(Global.boss_kills+1,2))
		
		existing_tile.enemy_stats = enemy_stats
		existing_tile.update_texture()
	
	return new_map_tiles

func generate_enemy_stats(enemy_stats:Dictionary, points_to_spend:int=10) -> Dictionary:
	var max_points_to_spend:int = points_to_spend
	while points_to_spend > 0:
		# pick random stat
		var random_stat_name: String = ["hp", "armor", "speed", "damage", "strength"][randi_range(0, 4)]
		# pick a random amount of points to spend
		var investment_points: int = randi_range(1, min(max_points_to_spend*0.25, points_to_spend))
		enemy_stats[random_stat_name] += investment_points
		points_to_spend -= investment_points
	return enemy_stats

func random_spread(new_map_tiles:Array[Array], random_seed_points:Array[MapTile], p_tile_width:int, p_tile_height:int):
	for random_seed_point in random_seed_points:
		var type:int = random_seed_point.type
		for x in range(-spread_range, spread_range+1):
			for y in range(-spread_range, spread_range+1):
				if x == 0 and y ==0:
					continue
				if randf() < 0.5:
					var item_id:int = -1
					if randf() < 0.05:
						item_id = 0
					var new_position:Vector2i = validate_position(Vector2i(random_seed_point.x+x, random_seed_point.y+y))
					generate_tile(new_map_tiles[new_position.y][new_position.x], new_position.x, new_position.y, p_tile_width, p_tile_height, type, item_id)
					
	
func generate_tile(new_tile:MapTile, x:int, y:int, p_tile_width:int, p_tile_height:int, type:int = TILE_EMPTY, item_id:int = -1) -> MapTile:
	var walkable:bool = true
	var blocks_vision:bool = false
	var step_cost:float = 1
	
	if type == TILE_WALL:
		walkable = false
		blocks_vision = true
		step_cost = 3
	elif type == TILE_WATER:
		walkable = false
		blocks_vision = false
		step_cost = 2
	elif type == TILE_HILLS:
		walkable = true
		blocks_vision = false
		step_cost = 2
	elif type == TILE_FOREST:
		walkable = true
		blocks_vision = true
		step_cost = 2
	elif type == TILE_ROAD:
		walkable = true
		blocks_vision = false
		step_cost = 0.5
	
	var tile_position:Vector2 = Vector2((p_tile_width*0.5) + x * p_tile_width, (p_tile_height*0.5) + y * p_tile_height)
	new_tile.init(x, y, tile_position, type, item_id, walkable, blocks_vision, step_cost)
	new_tile.visible = false
	if item_id >= 0:
		new_tile.rewards = reward_choice_screen.generate_rewards_for_tile()
	return new_tile

func update_screen(p_player_position:Vector2i, p_sight_radius:int) -> void:
	if p_player_position.x <= 3 and p_player_position.y <= 1:
		side_bar.clock.visible = false
	else:
		side_bar.clock.visible = true
	for y:int in range(0, map_height):
		for x:int in range(0, map_width):
			var map_tile:MapTile = map_tiles[y][x]
			# if the map tile is within sight of the player position then show it
			# otherwise hide it
			var map_position:Vector2i = Vector2i(x, y)
			# TODO SHOW STREAM
			var in_los:bool = is_visible_to_player(map_tile, map_position, p_player_position, p_sight_radius)
			if in_los:
				# if directly in LOS then fully visible
				map_tile.visible = true
				map_tile.discovered = true
				map_tile.modulate.a = 1
			else:
				# should be partially shown if previously discovered
				if map_tile.discovered:
					map_tile.modulate.a = 0.25
					map_tile.visible = true
				else:
					# otherwise not in LOS or previously discovered so hide it
					map_tile.visible = false
	player_image.position = Vector2i(int(tile_width*0.5) + p_player_position.x * tile_width, int(tile_height*0.5) + p_player_position.y * tile_height)
	
	side_bar.update_stats(self)

func is_visible_to_player(_map_tile:MapTile, p_tile_position:Vector2i, p_player_position:Vector2i, p_sight_radius:int):
	var distance:float = p_player_position.distance_to(p_tile_position)
	var players_tile:MapTile = map_tiles[p_player_position.y][p_player_position.x]
	if distance <2 and players_tile.type == TILE_FOREST:
		return true
	if distance <= Global.sight_radius+2 and players_tile.type == TILE_WALL:
		return true
	if distance <= 1:
		return true
	var is_within_distance:bool = distance <= p_sight_radius
	var is_tile_visible:bool = true
	# https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
	var x0:int = p_tile_position.x
	var x1:int = p_player_position.x
	var y0:int = p_tile_position.y
	var y1:int = p_player_position.y
	var dx:int = abs(x1 - x0)
	var sx:int = -1
	if x0 < x1:
		sx = 1
		
	var dy:int = -abs(y1 - y0)
	var sy:int = -1
	if y0 < y1:
		sy = 1
	var error:int = dx + dy
	
	while true:
		var e2:int = 2 * error
		if e2 >= dy:
			if x0 == x1:
				break
			error = error + dy
			x0 = x0 + sx
		if e2 <= dx:
			if y0 == y1:
				break
			error = error + dx
			y0 = y0 + sy
		
		var candidate_map_tile:MapTile = map_tiles[y0][x0]
		if candidate_map_tile.blocks_sight:
			is_tile_visible = false
			break
	
	return is_within_distance and is_tile_visible

func _process(delta: float) -> void:
	
	if loop_splash_screen.visible:
		if Input.is_action_just_pressed("Interact"):
			loop_splash_screen.visible = false
		else:
			return
			
	if combat_screen.visible:
		if combat_screen.is_combat_lost():
			combat_screen.combat_results_screen.results_test.text="[center]Defeat!\nYou were defeated in battle.\nPress the Interact key to restart the loop and try again.[/center]"
			combat_screen.combat_results_screen.visible=true
			combat_screen.combat_results_screen.combat_type = "Defeat"
			
		elif combat_screen.is_combat_won():
			combat_screen.combat_results_screen.results_test.text="[center]Victory!\nYou were victorious in battle.\nPress the Interact key to claim your reward.[/center]"
			combat_screen.combat_results_screen.visible=true
			combat_screen.combat_results_screen.combat_type = "Victory"
			
	if Global.hp <= 0:
		if combat_screen.visible and combat_screen.combat_results_screen.visible and combat_screen.is_combat_lost():
			if Input.is_action_just_pressed("Interact"):
				# TODO lost combat so restart the loop
				print("restart loop")
				combat_screen.visible = false
				seed(Global.rng_seed.hash())
				Global.loop += 1
				init_loop()
		return
	
	if combat_screen.visible and not combat_screen.combat_results_screen.visible:
		if Input.is_action_just_pressed("Interact") or combat_timer >= combat_auto_timer:
			combat_screen.next_turn(delta)
			combat_timer = 0
		combat_timer += delta
		return
	
	if combat_screen.visible and combat_screen.combat_results_screen.visible:
		if Input.is_action_just_pressed("Interact"):
			if combat_screen.is_combat_lost():
				# TODO lost combat so restart the loop
				print("restart loop")
				combat_screen.visible = false
				seed(Global.rng_seed.hash())
				Global.loop += 1
				init_loop()
			elif combat_screen.is_combat_won():
				if fighting_boss:
					print("Beat the boss")
					Global.boss_kills+=1
					Global.loop += 1
				combat_screen.combat_results_screen.visible = false
				combat_screen.visible = false
				show_reward_choice_screen()
		return
	if steps >=0 and steps <= Global.max_steps * 0.25 and not play_faster_music:
		regular_music.stop()
		faster_music.play()
		play_faster_music = true
		
	if not reward_choice_screen.visible and steps > 0:
		if Input.is_action_pressed("MoveUp"):
			move_direction = DIRECTION_UP
		elif Input.is_action_pressed("MoveRight"):
			move_direction = DIRECTION_RIGHT
		elif Input.is_action_pressed("MoveDown"):
			move_direction = DIRECTION_DOWN
		elif Input.is_action_pressed("MoveLeft"):
			move_direction = DIRECTION_LEFT
		else:
			move_direction = DIRECTION_NONE
		if time_since_last_moved >= movement_delay_time_sec:
			var moved:bool = false
			var target_position:Vector2i = Vector2i(player_position.x, player_position.y)
			if move_direction == DIRECTION_UP:
				time_since_last_moved = 0
				target_position.y -= 1
				moved = true
			elif move_direction == DIRECTION_RIGHT:
				time_since_last_moved = 0
				target_position.x += 1
				moved = true
			elif move_direction == DIRECTION_DOWN:
				time_since_last_moved = 0
				target_position.y += 1
				moved = true
			elif move_direction == DIRECTION_LEFT:
				time_since_last_moved = 0
				target_position.x -= 1
				moved = true
			
			var validated_target_position:Vector2i = validate_position(target_position)
			var current_map_tile:MapTile = map_tiles[validated_target_position.y][validated_target_position.x]
			if moved and steps >= current_map_tile.step_cost and is_walkable(validated_target_position):
				steps -= current_map_tile.step_cost
				player_position = validated_target_position
				# check the tile we walked onto
				# if it has an item, remove the item and gain effect based on the item
				if current_map_tile.item_id >= 0:
					interact_with_item(current_map_tile)
				
				if steps <= 0 or not has_valid_movements():
					trigger_boss_fight()
				update_screen(player_position, side_bar.calculated_stats["vision"])
			
	time_since_last_moved += delta
	
	if reward_choice_screen.visible:
		if last_selected_reward_id >= 0 and time_since_selected_reward < time_to_wait_before_closing_reward_screen:
			time_since_selected_reward += delta
			reward_choice_screen.reward_cards[last_selected_reward_id].position.y += 50 * delta
			reward_choice_screen.reward_cards[last_selected_reward_id].modulate.a -= delta
			var i:int = 0
			for reward_card in reward_choice_screen.reward_cards:
				if i != last_selected_reward_id:
					reward_choice_screen.reward_cards[i].position.y -= 25 * delta
					reward_choice_screen.reward_cards[i].modulate.a -= delta
				i += 1
		
		if last_selected_reward_id >=0 and time_since_selected_reward >= time_to_wait_before_closing_reward_screen:
			time_since_selected_reward = 0
			reward_choice_screen.visible = false
			for reward_card in reward_choice_screen.reward_cards:
				reward_card.reset()
			last_selected_reward_id = -1
		
		if Input.is_action_just_pressed("Option1"):
			give_reward(0)
			if fighting_boss:
				randomize()
				Global.rng_seed = "%d"%[randi()]
				seed(Global.rng_seed.hash())
				Global.loop += 1
				init_loop()
		elif Input.is_action_just_pressed("Option2"):
			give_reward(1)
			if fighting_boss:
				randomize()
				Global.rng_seed = "%d"%[randi()]
				seed(Global.rng_seed.hash())
				Global.loop += 1
				init_loop()
		elif Input.is_action_just_pressed("Option3"):
			give_reward(2)
			if fighting_boss:
				randomize()
				Global.rng_seed = "%d"%[randi()]
				seed(Global.rng_seed.hash())
				Global.loop += 1
				init_loop()
		elif Input.is_action_just_pressed("Undo"):
			# if they don't take any of the rewards from the boss still have to restart loop
			if fighting_boss:
				randomize()
				Global.rng_seed = "%d"%[randi()]
				seed(Global.rng_seed.hash())
				Global.loop += 1
				init_loop()
	
	if Input.is_action_just_pressed("Undo"):
		reward_choice_screen.visible = false
		for reward_card in reward_choice_screen.reward_cards:
			reward_card.reset()


func has_valid_movements():
	if steps <= 0:
		return false
	
	if steps > 0:
		# check all tiles around the player if the movement cost would be too much or not
		for coords in [[-1,0],[1,0],[0,1],[0,-1]]:
			var map_tile:MapTile = map_tiles[player_position.y+coords[1]][player_position.x+coords[0]]
			# it is a valid place to move
			if map_tile.step_cost <= steps:
				if map_tile.walkable:
					return true
				else:
					if map_tile.type == TILE_WATER and Global.has_flippers:
						return true
					elif map_tile.type == TILE_WALL and Global.has_climbing_gear:
						return true
						
	
	return false

func trigger_boss_fight():
	fighting_boss = true
	combat_timer = 0
	var rarities:Array[String] = ["unique"]
	var rarity:String = rarities[randi_range(0, rarities.size()-1)]
	var current_map_tile:MapTile = map_tiles[player_position.y][player_position.x]
	current_map_tile.rewards = reward_choice_screen.generate_rewards_for_tile(rarity)
	
	combat_screen.start_combat(boss_enemy_stats)
	combat_screen.visible = true
	


func give_reward(reward_id:int):
	last_selected_reward_id = reward_id
	var reward_card:RewardCard = reward_choice_screen.reward_cards[reward_id]
	#
	var reward_config:Dictionary =  reward_card.reward_config
	# check if it's an item or a one time boost
	var reward_type:String = reward_config.get("type", "consumable")
	var special:String = reward_config.get("special", "")
	if special == "flippers":
		Global.has_flippers = true
		reward_choice_screen.reward_options.erase("flippers")
	elif special == "climbing_gear":
		Global.has_climbing_gear = true
		reward_choice_screen.reward_options.erase("climbing_gear")
	if reward_type == "consumable":
		var stats_affected:Array = reward_config.get("stats", [])
		for stat_affected:Dictionary in stats_affected:
			var min_amount:int = stat_affected.get("min_amount", 0)
			var max_amount:int = stat_affected.get("max_amount", 0)
			
			var amount:int = randi_range(min_amount, max_amount)
			var stat_name:String =  stat_affected.get("name", "")
			var type:String =  stat_affected.get("type", "modify")
			
			if stat_name != "":
				if type == "modify":
					if stat_name == "vision":
						Global.sight_radius = max(1, Global.sight_radius+amount)
					elif stat_name == "hp":
						Global.hp = max(1, Global.hp+amount)
					elif stat_name == "armor":
						Global.armor = max(0, Global.armor+amount)
					elif stat_name == "armor_regen":
						Global.armor_regen = max(0, Global.armor_regen+amount)
					elif stat_name == "speed":
						Global.speed = max(0, Global.speed+amount)
					elif stat_name == "strength":
						Global.strength = max(0, Global.strength+amount)
					elif stat_name == "damage":
						Global.damage = max(0, Global.damage+amount)
					elif stat_name == "steps":
						steps = max(0, steps+amount)
					elif stat_name == "max_steps":
						Global.max_steps = max(0, Global.max_steps+amount)
				elif type == "set":
					if stat_name == "vision":
						Global.sight_radius = amount
					elif stat_name == "hp":
						Global.hp = amount
					elif stat_name == "armor":
						Global.armor = amount
					elif stat_name == "armor_regen":
						Global.armor_regen = amount
					elif stat_name == "speed":
						Global.speed = amount
					elif stat_name == "strength":
						Global.strength = amount
					elif stat_name == "damage":
						Global.damage = amount
					elif stat_name == "steps":
						steps = amount
					elif stat_name == "max_steps":
						Global.max_steps = amount
	else:
		var inventory_item:InventoryItem = inventory_item_resource.instantiate()
		var item_name:String = reward_config.get("title", "No Title Found")
		var icon_path:String = reward_config.get("icon_path", "res://assets/images/sprite_sheets/items/default.png")
		inventory_item.update(icon_path, item_name)
		side_bar.add_inventory_item(inventory_item)
	
	rewards.append(reward_config)
	var i:int = 0
	for other_reward_card in reward_choice_screen.reward_cards:
		if i != reward_id:
			other_reward_card.burn(i)
		i += 1
	
	update_screen(player_position, side_bar.calculated_stats["vision"])
	

func interact_with_item(current_map_tile:MapTile):
	if current_map_tile.item_id == 0:
		# chest
		reward_choice_screen.generate_reward_options(current_map_tile)
		# populate and show the options for items to get
		show_reward_choice_screen()
		
		#sight_radius += 1
		current_map_tile.item_id = -1
		current_map_tile.item_texture_path = ""
		current_map_tile.item_sprite.visible = false
	elif current_map_tile.item_id == 1:
		reward_choice_screen.generate_reward_options(current_map_tile)
		show_reward_choice_screen()
		start_random_combat(current_map_tile)

func start_random_combat(current_map_tile:MapTile):
	# show the combat screen
	combat_timer = 0
	var enemy_stats:Dictionary = current_map_tile.enemy_stats
	combat_screen.start_combat(enemy_stats)
	current_map_tile.item_id = -1
	current_map_tile.update_texture()
	combat_screen.visible = true
	

func show_reward_choice_screen():
	var current_map_tile:MapTile = map_tiles[player_position.y][player_position.x]
	reward_choice_screen.generate_reward_options(current_map_tile)
	reward_choice_screen.visible = true

func is_walkable(validated_target_position:Vector2i) -> bool:
	var map_tile:MapTile = map_tiles[validated_target_position.y][validated_target_position.x]
	if map_tile.type == TILE_WATER and Global.has_flippers:
		return true
	if map_tile.type == TILE_WALL and Global.has_climbing_gear:
		return true
	return map_tile.walkable 

func validate_position(target_position:Vector2i) -> Vector2i:
	if target_position.x < 0:
		target_position.x = 0
	elif target_position.x > map_width-1:
		target_position.x = map_width-1
	if target_position.y < 0:
		target_position.y = 0
	elif target_position.y > map_height-1:
		target_position.y = map_height-1
	
	return target_position
