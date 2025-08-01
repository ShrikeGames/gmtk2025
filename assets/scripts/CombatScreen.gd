extends Node2D

class_name CombatScreen

@export var side_bar:SideBar
@export var world_map:WorldMap
@export var enemy_stats_text:RichTextLabel
@export var combat_log_text:RichTextLabel
@export var combat_results_screen:CombatResults
@export var enemy_sprite:Sprite2D

var turn:int
var enemy_stats:Dictionary
var player_speed:int
var enemy_speed: int 
var player_speed_bonus_turns:int
var enemy_speed_bonus_turns:int
var max_speed_bonus_turns_allowed:int
func start_combat(p_enemy_stats:Dictionary):
	turn = 0
	self.enemy_stats = p_enemy_stats
	self.player_speed = side_bar.calculated_stats["speed"]
	self.enemy_speed = enemy_stats["speed"]
	var enemy_image:String = enemy_stats.get("image", "res://assets/images/sprite_sheets/Enemy0.png")
	enemy_sprite.texture = load(enemy_image)
	self.player_speed_bonus_turns=0
	self.enemy_speed_bonus_turns=0
	self.max_speed_bonus_turns_allowed = side_bar.calculated_stats["max_speed_bonus_turns_allowed"]
	
	combat_log_text.text = ""
	update_enemy_stats_text()
	
func next_turn(_delta:float) -> bool:
	turn += 1
	var player_hp: int = side_bar.calculated_stats["hp"]
	var enemy_hp: int = enemy_stats["hp"]
	# determine who is faster
	var strength_damage_modifier:float = 0.5
	if (player_speed >= enemy_speed or (player_speed< enemy_speed and enemy_speed_bonus_turns > max_speed_bonus_turns_allowed)) and player_speed_bonus_turns <= max_speed_bonus_turns_allowed:
		player_speed_bonus_turns+=1
		enemy_speed_bonus_turns=0
		enemy_speed = enemy_stats["speed"]
		# player goes
		# calculate total damage
		var base_damage:int = side_bar.calculated_stats["damage"]
		var strength:int = side_bar.calculated_stats["strength"]
		var bonus_damage:int = 0
		# check items that affect damage
		for reward_config in world_map.rewards:
			var combat_effects:Array = reward_config.get("combat_effects", [])
			for combat_effect in combat_effects:
				var damage_modifier:Dictionary = combat_effect.get("damage", {})
				if not damage_modifier.is_empty():
					var stats_modifiers:Array = damage_modifier.get("stats", [])
					for stat_modifier in stats_modifiers:
						var stat_modifier_name:String = stat_modifier.get("name", "")
						var use_other_stat_name:String = stat_modifier.get("use_other_stat", "")
						if stat_modifier_name == "damage":
							if use_other_stat_name != "":
								if use_other_stat_name == "speed":
									bonus_damage += side_bar.calculated_stats["speed"]
								elif use_other_stat_name == "hp":
									bonus_damage += side_bar.calculated_stats["hp"]
								elif use_other_stat_name == "armor":
									bonus_damage += side_bar.calculated_stats["armor"]
								elif use_other_stat_name == "armor_regen":
									bonus_damage += side_bar.calculated_stats["armor_regen"]
								elif use_other_stat_name == "strength":
									bonus_damage += side_bar.calculated_stats["strength"]
								elif use_other_stat_name == "damage":
									bonus_damage += side_bar.calculated_stats["damage"]
							else:
								bonus_damage += randi_range(stat_modifier["min_amount"], stat_modifier["max_amount"])
						if stat_modifier_name == "hp":
							if use_other_stat_name != "":
								if use_other_stat_name == "speed":
									player_hp += side_bar.calculated_stats["speed"]
								elif use_other_stat_name == "hp":
									player_hp += side_bar.calculated_stats["hp"]
								elif use_other_stat_name == "armor":
									player_hp += side_bar.calculated_stats["armor"]
								elif use_other_stat_name == "armor_regen":
									player_hp += side_bar.calculated_stats["armor_regen"]
								elif use_other_stat_name == "strength":
									player_hp += side_bar.calculated_stats["strength"]
								elif use_other_stat_name == "damage":
									player_hp += side_bar.calculated_stats["damage"]
							else:
								player_hp += randi_range(stat_modifier["min_amount"], stat_modifier["max_amount"])
							world_map.hp = player_hp
							combat_log_text.text += "The player healed!\n"
		var total_damage:int = 	base_damage + int(strength*strength_damage_modifier) + bonus_damage
		# deal the damage first to armor
		var enemy_armor: int = enemy_stats["armor"]
		if enemy_armor > 0:
			combat_log_text.text += "The enemy armor blocks some damage!\n"
			var armor_before:int = enemy_armor
			enemy_armor = max(0, enemy_armor-total_damage)
			total_damage = max(0, total_damage-armor_before)
		if total_damage <= 0:
			total_damage = 1
		
		# deal remainder of damage to hp
		if total_damage > 0:
			combat_log_text.text += "Player deals %d damage!\n"%[total_damage]
			enemy_hp -= total_damage
		
		enemy_stats["hp"] = enemy_hp
		enemy_stats["armor"] = enemy_armor
		# reduce their speed
		player_speed -= enemy_speed
	elif enemy_speed_bonus_turns <= max_speed_bonus_turns_allowed:
		enemy_speed_bonus_turns+=1
		player_speed_bonus_turns=0
		player_speed = side_bar.calculated_stats["speed"]
		# enemy goes
		var base_damage:int = enemy_stats["damage"]
		var strength:int = enemy_stats["strength"]
		# for now don't give enemies a strength modifier
		var enemy_strength_damage_modifier:float = 0.5
		
		var total_damage:int = base_damage + int(strength*enemy_strength_damage_modifier)
		# deal the damage first to armor
		var player_armor: int = side_bar.calculated_stats["armor"]
		if player_armor > 0:
			var armor_before:int = player_armor
			player_armor = max(0, player_armor-total_damage)
			total_damage =  max(0, total_damage-armor_before)
			world_map.armor = player_armor
			
		var thorns_damage:int = 0
		for reward_config in world_map.rewards:
			var combat_effects:Array = reward_config.get("combat_effects", [])
			for combat_effect in combat_effects:
				var damage_modifier:Dictionary = combat_effect.get("damage", {})
				if not damage_modifier.is_empty():
					var stats_modifiers:Array = damage_modifier.get("stats", [])
					for stat_modifier in stats_modifiers:
						var stat_modifier_name:String = stat_modifier.get("name", "")
						var use_other_stat_name:String = stat_modifier.get("use_other_stat", "")
						if stat_modifier_name == "thorns":
							if use_other_stat_name != "":
								if use_other_stat_name == "speed":
									thorns_damage += side_bar.calculated_stats["speed"]
								elif use_other_stat_name == "hp":
									thorns_damage += side_bar.calculated_stats["hp"]
								elif use_other_stat_name == "armor":
									thorns_damage += side_bar.calculated_stats["armor"]
								elif use_other_stat_name == "armor_regen":
									thorns_damage += side_bar.calculated_stats["armor_regen"]
								elif use_other_stat_name == "strength":
									thorns_damage += side_bar.calculated_stats["strength"]
								elif use_other_stat_name == "damage":
									thorns_damage += side_bar.calculated_stats["damage"]
							else:
								thorns_damage += randi_range(stat_modifier["min_amount"], stat_modifier["max_amount"])
						
		
		if total_damage <= 0:
			total_damage = 1
		# deal remainder of damage to hp
		if total_damage > 0:
			player_hp -= total_damage
			combat_log_text.text += "Enemy deals %d damage!\n"%[total_damage]
		
		if thorns_damage > 0:
			enemy_hp -= thorns_damage
			combat_log_text.text += "The Enemy takes %d thorn damage!\n"%[thorns_damage]
			enemy_stats["hp"] = enemy_hp
		world_map.hp = player_hp
		
		# reduce their speed
		enemy_speed -= player_speed
	
	side_bar.update_stats(world_map)
	update_enemy_stats_text()
	if is_combat_won() or is_combat_lost():
		combat_results_screen.visible = true
		world_map.armor += side_bar.calculated_stats["armor_regen"]
		return true
	
	return false

func update_enemy_stats_text():
	var displayed_hp:int = enemy_stats["hp"]
	var displayed_armor:int = enemy_stats["armor"]
	var displayed_speed:int = enemy_stats["speed"]
	var displayed_strength:int = enemy_stats["strength"]
	var displayed_damage:int = enemy_stats["damage"]
	
	var hp_rich_text:String = "[color=#992211]HP: %d[/color]"%[displayed_hp]
	var armor_rich_text:String = "[color=#000099]Armor: %d[/color]"%[displayed_armor]
	var speed_rich_text:String = "[color=#119911]Speed: %d[/color]"%[displayed_speed]
	var strength_rich_text:String = "[color=#994411]Strength: %d[/color]"%[displayed_strength]
	var damage_rich_text:String = "[color=#991177]Damage: %d[/color]"%[displayed_damage]
	var rich_text:String = "%s\n%s\n%s\n%s\n%s"%[hp_rich_text, armor_rich_text, speed_rich_text, strength_rich_text, damage_rich_text]
	enemy_stats_text.text = rich_text

func is_combat_won():
	var player_hp: int = side_bar.calculated_stats["hp"]
	var enemy_hp: int = enemy_stats["hp"]
	return player_hp > 0 and enemy_hp <= 0
	
func is_combat_lost():
	var player_hp: int = side_bar.calculated_stats["hp"]
	return player_hp <= 0
