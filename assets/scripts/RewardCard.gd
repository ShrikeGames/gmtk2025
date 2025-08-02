extends Node2D

class_name RewardCard

@export var title_text:RichTextLabel
@export var description_text:RichTextLabel
@export var rarity_text:RichTextLabel
@export var reward_config:Dictionary
@export var card_background:Sprite2D
var texture_size:Vector2
var burn_duration:float = 1.5

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
	reset()

func reset():
	position.y = 111.0
	modulate.a = 1
	if card_background:
		texture_size = card_background.texture.get_size()
		card_background.get_material().set_shader_parameter("position", 0)
		card_background.get_material().set_shader_parameter("radius", 0)

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

func burn(reward_id:int):
	print("burn the card")
	var random_burn_position:Vector2 = Vector2(reward_id*0.25, reward_id*0.25) * texture_size
	var uv = get_uv_from_position(random_burn_position)
	burnCard(uv)

func get_uv_from_position(local_click_pos: Vector2) -> Vector2:
	var top_left_pos = local_click_pos + (texture_size) / 2
	var uv = top_left_pos / (texture_size)
	return uv

func burnCard(uv):
	if card_background.get_material() and card_background.get_material() is ShaderMaterial:
		var tween = create_tween()
		# set the uvs in the shader
		card_background.get_material().set_shader_parameter("position", uv)
		# use tweens to animate the radius value
		tween.tween_method(update_radius, 0.0, 2.0, burn_duration)

func update_radius(value: float):
	if card_background.get_material():
		card_background.get_material().set_shader_parameter("radius", value)
