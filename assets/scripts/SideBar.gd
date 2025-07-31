extends Node2D
class_name SideBar

@export var stats_text:RichTextLabel
@export var calculated_stats:Dictionary = {}
@export var inventory_items_node:Node2D

func add_inventory_item(inventory_item:InventoryItem):
	var x:int = 75 + (inventory_items_node.get_child_count() * 150)
	var y:int = 40
	inventory_item.position = Vector2(x,y)
	inventory_items_node.add_child(inventory_item)

func update_stats(rewards:Array[Dictionary], steps:float, max_steps:float, hp:int, armor:int, armor_regen:int, speed:int, strength:int, damage:int, vision:int, loop:int):
	var displayed_hp:int = hp
	var displayed_armor:int = armor
	var displayed_armor_regen:int = armor_regen
	var displayed_speed:int = speed
	var displayed_strength:int = strength
	var displayed_damage:int = damage
	var displayed_vision:int = vision
	var displayed_max_steps:int = max_steps
	for reward_config in rewards:
		var reward_type:String = reward_config.get("type", "consumable")
		if reward_type != "item":
			continue
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
						displayed_vision += amount
					elif stat_name == "hp":
						displayed_hp += amount
					elif stat_name == "armor":
						displayed_armor += amount
					elif stat_name == "armor_regen":
						displayed_armor_regen += amount
					elif stat_name == "speed":
						displayed_speed += amount
					elif stat_name == "strength":
						displayed_strength += amount
					elif stat_name == "damage":
						displayed_damage += amount
					elif stat_name == "steps":
						steps += amount
					elif stat_name == "max_steps":
						displayed_max_steps += amount
				elif type == "set":
					if stat_name == "vision":
						displayed_vision = amount
					elif stat_name == "hp":
						displayed_hp = amount
					elif stat_name == "armor":
						displayed_armor = amount
					elif stat_name == "armor_regen":
						displayed_armor_regen = amount
					elif stat_name == "speed":
						displayed_speed = amount
					elif stat_name == "strength":
						displayed_strength = amount
					elif stat_name == "damage":
						displayed_damage = amount
					elif stat_name == "steps":
						steps = amount
					elif stat_name == "max_steps":
						displayed_max_steps = amount
	
	var steps_rich_text:String = "[color=#222222]Steps: %d/%d[/color]"%[int(steps), int(displayed_max_steps)]
	var hp_rich_text:String = "[color=#992211]HP: %d[/color]"%[displayed_hp]
	var armor_rich_text:String = "[color=#000099]Armor: %d (%d)[/color]"%[displayed_armor, displayed_armor_regen]
	var speed_rich_text:String = "[color=#119911]Speed: %d[/color]"%[displayed_speed]
	var strength_rich_text:String = "[color=#994411]Strength: %d[/color]"%[displayed_strength]
	var damage_rich_text:String = "[color=#991177]Damage: %d[/color]"%[displayed_damage]
	var vision_rich_text:String = "[color=#997700]Vision: %d[/color]"%[displayed_vision]
	var rich_text:String = "Loop: %s - %s\n%s - %s - %s - %s - %s - %s"%[loop, steps_rich_text, hp_rich_text, armor_rich_text, speed_rich_text, strength_rich_text, damage_rich_text, vision_rich_text]
	
	calculated_stats["hp"] = displayed_hp
	calculated_stats["armor"] = displayed_armor
	calculated_stats["armor_regen"] = displayed_armor_regen
	calculated_stats["speed"] = displayed_speed
	calculated_stats["damage"] = displayed_damage
	calculated_stats["strength"] = displayed_strength
	calculated_stats["vision"] = displayed_vision
	
	stats_text.text = rich_text
