extends Node2D

class_name RewardChoiceScreen

@export var reward_cards:Array[RewardCard] = []

var reward_options:Dictionary = {
	"spy_glass": {
		"title": "Spy Glass",
		"description": "This spy glass blah blah. Increases your [color=997700]Vision[/color] by 1. (TODO make more interesting)",
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
		"color": "119911",
		"stats": [{
			"name": "speed",
			"type": "modify",
			"min_amount": 3,
			"max_amount": 3
		}]
	},
	"muleback_cords": {
		"title": "Muleback Cords",
		"description": "Increases your [color=994411]Build[/color] by 8 allowing you to carry larger weapons. (TODO make more interesting)",
		"color": "994411",
		"stats": [{
			"name": "build",
			"type": "modify",
			"min_amount": 8,
			"max_amount": 8
		}]
	},
	"big_stick": {
		"title": "Big Stick",
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
	"lole_random": {
		"title": "Randomize all stats",
		"description": "Randomize all of your stats to be between 3 and 18. (TODO make more interesting)",
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
			"name": "build",
			"type": "set",
			"min_amount": 3,
			"max_amount": 18
		},
		{
			"name": "vision",
			"type": "set",
			"min_amount": 3,
			"max_amount": 18
		}]
	}
}

func generate_reward_options():
	var temp_reward_options:Dictionary = reward_options.duplicate(true)
	for reward_card in reward_cards:
		temp_reward_options = reward_card.display_random_choice(temp_reward_options)
