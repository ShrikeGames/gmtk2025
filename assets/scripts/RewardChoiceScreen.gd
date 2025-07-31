extends Node2D

class_name RewardChoiceScreen

@export var reward_cards:Array[RewardCard] = []

var reward_options:Dictionary = {
	"common": {
		"spy_glass": {
			"title": "Spy Glass",
			"description": "This spy glass blah blah. Increases your [color=997700]Vision[/color] by 1. (TODO make more interesting)",
			"type": "item",
			"color": "997700",
			"stats": [{
				"name": "vision",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 1
			}]
		},
		"running_shoes": {
			"title": "Running Shoes",
			"description": "Gotta go fast. Increases your [color=119911]Speed[/color] by 3. (TODO make more interesting)",
			"type": "item",
			"color": "119911",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 3,
				"max_amount": 3
			}]
		},
		"big_stick": {
			"title": "Big Stick",
			"type": "item",
			"description": "Increases damage by 3 but lower speed by 1. (TODO make more interesting)",
			"color": "991177",
			"stats": [{
				"name": "damage",
				"type": "modify",
				"min_amount": 3,
				"max_amount": 3
			},
			{
				"name": "speed",
				"type": "modify",
				"min_amount": -1,
				"max_amount": -1
			}]
		},
	},
	"uncommon": {
		"perma_stat_increase_speed": {
			"title": "[color=119911]Speed[/color] +1d3",
			"description": "Increase your [color=119911]Speed[/color] by a random amount between 1 and 3, forever!",
			"type": "consumable",
			"color": "19911",
			"stats": [{
				"name": "speed",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 3
			}],
			"special": ""
		},
		"perma_stat_increase_strength": {
			"title": "[color=994411]Strength[/color] +1d3",
			"description": "Increase your [color=994411]Strength[/color] by a random amount between 1 and 3, forever!",
			"type": "consumable",
			"color": "994411",
			"stats": [{
				"name": "strength",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 3
			}],
			"special": ""
		},
		"perma_stat_increase_armor": {
			"title": "[color=000099]Armor[/color] +1d3",
			"description": "Increase your [color=000099]Armor[/color] by a random amount between 1 and 3, forever!",
			"type": "consumable",
			"color": "000099",
			"stats": [{
				"name": "armor",
				"type": "modify",
				"min_amount": 1,
				"max_amount": 3
			}],
			"special": ""
		},
	},
	"rare": {
		"ambush_dagger": {
			"title": "Ambush Dagger",
			"description": "This dagger deals damage equal to your speed. (TODO make more interesting)",
			"type": "item",
			"color": "997700",
			"stats": [],
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
		"muleback_cords": {
			"title": "Muleback Cords",
			"description": "Increases your [color=994411]Strength[/color] by 8 allowing you to carry larger weapons. (TODO make more interesting)",
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
			"description": "This mace heals you 1 hp per hit. (TODO make more interesting)",
			"type": "item",
			"color": "FF0000",
			"stats": [],
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
	},
	"legendary": {
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
		}
	},
	"unique": {
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
		}
	}
}

func generate_reward_options(rarity:String=""):
	var temp_reward_options:Dictionary = reward_options.duplicate(true)
	if rarity == "":
		var rarities:Array[String] = ["common", "common", "common", "common", "common", "uncommon", "uncommon", "uncommon", "uncommon", "rare", "rare", "rare", "legendary", "legendary", "unique"]
		rarity = rarities[randi_range(0, rarities.size()-1)]
	for reward_card in reward_cards:
		temp_reward_options[rarity] = reward_card.display_random_choice(temp_reward_options.get(rarity))
