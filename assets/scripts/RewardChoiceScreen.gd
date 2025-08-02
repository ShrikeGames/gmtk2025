extends Node2D

class_name RewardChoiceScreen

@export var reward_cards:Array[RewardCard] = []

var reward_options:Dictionary = {
	"common": {
		"wooden_sword": {
			"title": "Wooden Sword",
			"description": "A simple wooden sword used for training. Increases your [color=991177]Damage[/color] by 1 and heals for 1 [color=#992211]hp[/color] per attack.",
			"type": "item",
			"color": "991177",
			"icon_path": "res://assets/images/sprite_sheets/items/wooden_sword.png",
			"stats": [{
				"name": "damage",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 1
			}],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "hp",
							"type": "modify",
							"min_amount": 1,
							"max_amount": 1
						}]
					}
					
				}
			]
		},
		"wooden_shield": {
			"title": "Wooden Shield",
			"description": "A simple wooden shield used for training. Increases your [color=991177]Armor[/color] by 1 and provides [color=991177]Armor Regen[/color] 1.",
			"type": "item",
			"color": "997700",
			"stats": [{
				"name": "armor",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 1
			},
			{
				"name": "armor_regen",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 1
			}]
		},
		"spy_glass": {
			"title": "Spy Glass",
			"description": "Eye spy with my little eye. Increases your [color=997700]Vision[/color] by 2.",
			"type": "item",
			"color": "997700",
			"stats": [{
				"name": "vision",
				"type": "modify",
				"min_amount": 2,
				"max_amount": 2
			}]
		},
		"running_shoes": {
			"title": "Running Shoes",
			"description": "Gotta go fast. Increases your [color=119911]Speed[/color] by 2.",
			"type": "item",
			"icon_path": "res://assets/images/sprite_sheets/items/running_shoes.png",
			"color": "119911",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 2,
				"max_amount": 2
			}]
		},
		"big_stick": {
			"title": "Big Stick",
			"type": "item",
			"description": "Increases damage by 6 but lower speed by 2.",
			"color": "991177",
			"stats": [{
				"name": "damage",
				"type": "modify",
				"min_amount": 6,
				"max_amount": 6
			},
			{
				"name": "speed",
				"type": "modify",
				"min_amount": -2,
				"max_amount": -2
			}]
		},
		"bone_charm": {
			"title": "Bone Charm",
			"description": "Increases your [color=991177]Damage[/color] by 1 and your max [color=#992211]HP[/color] by 5.",
			"type": "item",
			"color": "991177",
			"stats": [{
				"name": "damage",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 1
			},
			{
				"name": "hp",
				"type": "modify",
				"min_amount": 5,
				"max_amount": 5
			}]
		},
		"armor_spike": {
			"title": "Armor Spike",
			"description": "This spike attaches to your armor! Enemies take 1 damage when you get hit.",
			"type": "item",
			"color": "000099",
			"stats": [],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "thorns",
							"type": "modify",
							"min_amount": 1,
							"max_amount": 1
						}]
					}
					
				}
			] 
		},
		"perma_stat_increase_speed": {
			"title": "Weak Potion of [color=119911]Speed[/color] +1",
			"description": "Increase your [color=119911]Speed[/color] by 1",
			"type": "consumable",
			"color": "19911",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 1
			}],
			"special": ""
		},
		"perma_stat_increase_strength": {
			"title": "Weak Potion of [color=994411]Strength[/color] +1",
			"description": "Increase your [color=994411]Strength[/color] by 1",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "strength",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 1
			}],
			"special": ""
		},
		"perma_stat_increase_hp": {
			"title": "Healing Potion [color=992211]HP[/color] +5",
			"description": "Increase your [color=992211]HP[/color] by 5",
			"type": "consumable",
			"color": "992211",
			"stats": [{
				"name": "hp",
				"type": "modify",
				"min_amount": 5,
				"max_amount": 5
			}],
			"special": ""
		},
		
	},
	"uncommon": {
		"flippers": {
			"title": "Flippers",
			"description": "This lets you travel through water. (TODO make more interesting)",
			"type": "item",
			"color": "000099",
			"stats": [],
			"special": "flippers"
		},
		"climbing_gear": {
			"title": "Climbing Gear",
			"description": "This lets you travel across mountains. (TODO make more interesting)",
			"type": "item",
			"color": "705f1c",
			"stats": [],
			"special": "climbing_gear"
		},
		"perma_stat_increase_speed": {
			"title": "Potion of [color=119911]Speed[/color]",
			"description": "Increase your [color=119911]Speed[/color] by 1d3 but reduce your [color=#991177]Damage[/color] by 1d3.",
			"type": "consumable",
			"color": "19911",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 3
			},
			{
				"name": "damage",
				"type": "modify",
				"min_amount": -3,
				"max_amount": -1
			}],
			"special": ""
		},
		"perma_stat_increase_strength": {
			"title": "Potion of [color=994411]Strength[/color] +1d6.",
			"description": "Increase your [color=994411]Strength[/color] by 1d6 but reduce your [color=119911]Speed[/color] by 1d3.",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "strength",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 6
			},
			{
				"name": "speed",
				"type": "modify",
				"min_amount": -3,
				"max_amount": -1
			}],
			"special": ""
		},
		"perma_stat_increase_armor": {
			"title": "Potion of [color=994411]Armor[/color] +1d6.",
			"description": "Increase your [color=#000099]Armor[/color] by 1d6.",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "armor",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 6
			}],
			"special": ""
		},
		"great_sword": {
			"title": "Great Sword",
			"type": "item",
			"description": "Increases damage by 12 and does bonus damage equal to your [color=#994411]Strength[/color], but lowers [color=#119911]Speed[/color] by 10.",
			"color": "991177",
			"stats": [{
				"name": "damage",
				"type": "modify",
				"min_amount": 12,
				"max_amount": 12
			},
			{
				"name": "speed",
				"type": "modify",
				"min_amount": -10,
				"max_amount": -10
			}],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "damage",
							"type": "modify",
							"use_other_stat": "strength",
							"min_amount": 0,
							"max_amount": 0
						}]
					}
					
				}
			] 
		},
		"rapier": {
			"title": "Rapier",
			"type": "item",
			"description": "Does bonus damage equal to your [color=#119911]Speed[/color], but lowers [color=#994411]Strength[/color] by 10.",
			"color": "991177",
			"stats": [
			{
				"name": "strength",
				"type": "modify",
				"min_amount": -10,
				"max_amount": -10
			}],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "damage",
							"type": "modify",
							"use_other_stat": "speed",
							"min_amount": 0,
							"max_amount": 0
						}]
					}
				}
			] 
		},
	},
	"rare": {
		"muleback_cords": {
			"title": "Muleback Cords",
			"description": "Increases your [color=994411]Strength[/color] by 8.",
			"type": "item",
			"color": "994411",
			"stats": [{
				"name": "strength",
				"type": "modify",
				"min_amount": 8,
				"max_amount": 8
			}]
		},
		
		"healthy_mace": {
			"title": "Healthy Mace",
			"description": "This mace heals you 2 [color=#992211]HP[/color] per hit and increases your [color=#994411]Strength[/color] by 6.",
			"type": "item",
			"color": "FF0000",
			"stats": [],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "hp",
							"type": "modify",
							"min_amount": 2,
							"max_amount": 2
						},
						{
							"name": "strength",
							"type": "modify",
							"min_amount": 6,
							"max_amount": 6
						}]
					}
					
				}
			] 
		},
		"cursed_dagger": {
			"title": "Cursed Dagger",
			"description": "This dagger hurts you for 2 [color=#992211]HP[/color] per hit but increases your [color=#119911]Maximum Speed Bonus Attacks [/color] by 2",
			"type": "item",
			"color": "991177",
			"stats": [],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "hp",
							"type": "modify",
							"min_amount": -2,
							"max_amount": -2
						},
						{
							"name": "max_speed_bonus_turns_allowed",
							"type": "modify",
							"min_amount": 2,
							"max_amount": 2
						}]
					}
				}
			] 
		},
		"cursed_longsword": {
			"title": "Cursed Longsword",
			"description": "This sword hurts you for 2 [color=#992211]HP[/color] per hit but deals 20 extra bonus [color=#991177]Damage[/color].",
			"type": "item",
			"color": "991177",
			"stats": [],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "hp",
							"type": "modify",
							"min_amount": -2,
							"max_amount": -2
						},
						{
							"name": "damage",
							"type": "modify",
							"min_amount": 20,
							"max_amount": 20
						}]
					}
				}
			] 
		},
		"lole_random": {
			"title": "Randomize all stats",
			"type": "consumable",
			"description": "Randomize all of your core stats to be between 3 and 18. (TODO make more interesting)",
			"color": "ffffff",
			"stats": [{
				"name": "damage",
				"type": "set",
				"min_amount": 3,
				"max_amount": 18
			},
			{
				"name": "speed",
				"type": "set",
				"min_amount": 3,
				"max_amount": 18
			},
			{
				"name": "hp",
				"type": "set",
				"min_amount": 3,
				"max_amount": 18
			},
			{
				"name": "armor",
				"type": "set",
				"min_amount": 3,
				"max_amount": 18
			},
			{
				"name": "strength",
				"type": "set",
				"min_amount": 3,
				"max_amount": 18
			}]
		},
		"perma_stat_increase_speed": {
			"title": "Elixer of [color=119911]Speed[/color]",
			"description": "Increase your [color=119911]Speed[/color] by 1d10 but reduce your [color=#991177]Damage[/color] by 1d3.",
			"type": "consumable",
			"color": "19911",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 10
			},
			{
				"name": "damage",
				"type": "modify",
				"min_amount": -3,
				"max_amount": -1
			}],
			"special": ""
		},
		"perma_stat_increase_strength": {
			"title": "Elixer of [color=994411]Strength[/color] +1d20.",
			"description": "Increase your [color=994411]Strength[/color] by 1d20 but reduce your [color=119911]Speed[/color] by 1d3.",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "strength",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 20
			},
			{
				"name": "speed",
				"type": "modify",
				"min_amount": -3,
				"max_amount": -1
			}],
			"special": ""
		},
		"perma_stat_increase_armor": {
			"title": "Elixer of [color=994411]Armor[/color] +1d20.",
			"description": "Increase your [color=#000099]Armor[/color] by 1d20.",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "armor",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 20
			}],
			"special": ""
		},
	},
	"legendary": {
		"thorns_armor": {
			"title": "Thorns Armor",
			"description": "This armor is covered in thorns! Enemies take damage equal to your [color=#000099]Armor[/color] when you get hit.",
			"type": "item",
			"color": "000099",
			"stats": [],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "thorns",
							"type": "modify",
							"use_other_stat": "armor",
							"min_amount": 0,
							"max_amount": 0
						}]
					}
					
				}
			] 
		},
		"ambush_dagger": {
			"title": "Ambush Dagger",
			"description": "Increase your [color=#119911]Speed[/color] by 6 and deal bonus damage equal to your speed.",
			"type": "item",
			"color": "997700",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 6,
				"max_amount": 6
			}],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "damage",
							"type": "modify",
							"use_other_stat": "speed",
							"min_amount": 0,
							"max_amount": 0
						}]
					}
				}
			] 
		},
		"strong_mage": {
			"title": "Wizard Staff for Gym Rats",
			"description": "Increase your [color=#997700]Vision[/color] by 3 and deal bonus damage equal to your [color=#992211]HP[/color].",
			"type": "item",
			"color": "997700",
			"stats": [{
				"name": "vision",
				"type": "modify",
				"min_amount": 3,
				"max_amount": 3
			}],
			"combat_effects": [
				{
					"damage": {
						"stats": [{
							"name": "damage",
							"type": "modify",
							"use_other_stat": "hp",
							"min_amount": 0,
							"max_amount": 0
						}]
					}
				}
			] 
		},
		"rapid_quiver": {
			"title": "Rapid Quiver",
			"description": "Increase the maximum number of bonus attacks due to [color=#119911]Speed[/color] by 1.",
			"type": "item",
			"color": "997700",
			"stats": [{
				"name": "max_speed_bonus_turns_allowed",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 1
			}],
		},
		"perma_stat_increase_speed": {
			"title": "Large Elixer of [color=119911]Speed[/color]",
			"description": "Increase your [color=119911]Speed[/color] by 1d12.",
			"type": "consumable",
			"color": "19911",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 12
			}],
			"special": ""
		},
		"perma_stat_increase_strength": {
			"title": "Elixer of [color=994411]Strength[/color] +1d20.",
			"description": "Increase your [color=994411]Strength[/color] by 1d20.",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "strength",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 20
			}],
			"special": ""
		},
		"perma_stat_increase_armor": {
			"title": "Elixer of [color=994411]Armor[/color] +1d20.",
			"description": "Increase your [color=#000099]Armor[/color] by 2d20.",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "armor",
				"type": "modify",
				"min_amount": 2,
				"max_amount": 40
			}],
			"special": ""
		},
	},
	"unique": {
		"perma_stat_increase_speed": {
			"title": "Ultimate Potion of [color=119911]Speed[/color] +20",
			"description": "Increase your [color=119911]Speed[/color] by 20!",
			"type": "consumable",
			"color": "19911",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 20,
				"max_amount": 20
			}],
			"special": ""
		},
		"perma_stat_increase_strength": {
			"title": "Ultimate Potion of [color=994411]Strength[/color] +40",
			"description": "Increase your [color=994411]Strength[/color] by 40!",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "strength",
				"type": "modify",
				"min_amount": 40,
				"max_amount": 40
			}],
			"special": ""
		},
		"perma_stat_increase_armor": {
			"title": "Ultimate Potion of [color=000099]Armor[/color] +20",
			"description": "Increase your [color=000099]Armor[/color] by 20!",
			"type": "consumable",
			"color": "000099",
			"stats": [{
				"name": "armor",
				"type": "modify",
				"min_amount": 20,
				"max_amount": 20
			}],
			"special": ""
		},
		"perma_stat_increase_hp": {
			"title": "Ultimate Potion of [color=#992211]HP[/color] +25",
			"description": "Increase your [color=#992211]HP[/color] by 25!",
			"type": "consumable",
			"color": "000099",
			"stats": [{
				"name": "hp",
				"type": "modify",
				"min_amount": 25,
				"max_amount": 25
			}],
			"special": ""
		},
	}
}

func generate_reward_options(current_map_tile:MapTile, rarity:String=""):
	
	var temp_reward_options:Dictionary = reward_options.duplicate(true)
	var randomly_select_rarity:bool = false
	if rarity == "":
		randomly_select_rarity = true
	var rarities:Array[String] = ["common", "uncommon", "rare", "legendary", "unique"]
	var probabilities:Array[float] = [0.5, 0.5, 0.5, 0.5, 1]
	if current_map_tile.rewards:
		var i:int = 0
		for reward_card in reward_cards:
			var reward:Dictionary = current_map_tile.rewards.get(i).get("reward")
			var tile_reward_rarity:String = current_map_tile.rewards.get(i).get("rarity", rarity)
			reward_card.display_tile_rewards_choice(reward, tile_reward_rarity, reward_options.get(tile_reward_rarity).size())
			i += 1
	else:
		for reward_card in reward_cards:
			if randomly_select_rarity:
				var i:int = 0
				for prob in probabilities:
					var random_chance:float = randf()
					if random_chance <= prob:
						rarity = rarities[i]
						break
					i += 1
			temp_reward_options[rarity] = reward_card.display_random_choice(temp_reward_options.get(rarity), rarity, reward_options.get(rarity).size())
	
func generate_rewards_for_tile(p_rarity:String="") -> Array[Dictionary]:
	var rewards:Array[Dictionary] = []
	var randomly_select_rarity:bool = false
	if p_rarity == "":
		randomly_select_rarity = true
	var rarity:String = p_rarity
	for reward_id in range(0, 3):
		var rarities:Array[String] = ["common", "uncommon", "rare", "legendary", "unique"]
		var probabilities:Array[float] = [0.5, 0.5, 0.5, 0.5, 1]
		if randomly_select_rarity:
			var i:int = 0
			for prob in probabilities:
				var random_chance:float = randf()
				if random_chance <= prob:
					rarity = rarities[i]
					break
				i += 1
		print(rarity)
		var randomly_selected_reward_config:Dictionary = reward_options[rarity]
		var reward_config:Dictionary = randomly_selected_reward_config
		var num:int = reward_config.keys().size()
		var random_index:int = randi_range(0, num-2)
		var random_key:String = reward_config.keys()[random_index]
		rewards.append({
			"reward": reward_config[random_key],
			"rarity": rarity
		})
	return rewards
