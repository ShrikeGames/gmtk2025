extends Node2D

class_name RewardCard

@export var title_text:RichTextLabel
@export var description_text:RichTextLabel
@export var rarity_text:RichTextLabel
@export var reward_config:Dictionary

func display_tile_rewards_choice(p_reward_config:Dictionary, rarity:String, rarity_count:int):
	var title:String = p_reward_config.get("title", "NO TITLE FOUND")
	var description:String = p_reward_config.get("description", "NO DESCRIPTION FOUND")
	var color:String = p_reward_config.get("color", "NO COLOR FOUND")
	var title_rich_text:String = "[center][color=%s]%s[/color][/center]"%[color, title]
	var description_rich_text:String = "%s"%[description]
	var rarity_rich_text:String = "%s (%s)"%[rarity, rarity_count]
	title_text.text = title_rich_text
	description_text.text = description_rich_text
	rarity_text.text = rarity_rich_text
	reward_config = p_reward_config
	

func display_random_choice(reward_options:Dictionary, rarity:String, rarity_count:int) -> Dictionary:
	
	var number_of_options:int = reward_options.size()
	var rarity_index:int = randi_range(0, number_of_options-1)
	var random_option_key:String = reward_options.keys()[rarity_index]
	var randomly_selected_reward_config:Dictionary = reward_options[random_option_key]
	reward_config = randomly_selected_reward_config
	
	var title:String = randomly_selected_reward_config.get("title", "NO TITLE FOUND")
	var description:String = randomly_selected_reward_config.get("description", "NO DESCRIPTION FOUND")
	var color:String = randomly_selected_reward_config.get("color", "NO COLOR FOUND")
	var title_rich_text:String = "[center][color=%s]%s[/color][/center]"%[color, title]
	var description_rich_text:String = "%s"%[description]
	var rarity_rich_text:String = "%s (%s)"%[rarity, rarity_count]
	title_text.text = title_rich_text
	description_text.text = description_rich_text
	rarity_text.text = rarity_rich_text
	
	# we have used it so remove from potential rewards of the other cards
	reward_options.erase(random_option_key)
	return reward_options
