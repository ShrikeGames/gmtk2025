extends Node

var volume_master:float = 100.0
var volume_sfx:float = 50.0
var volume_music:float = 50.0
var volume_voice:float = 50.0
var settings_config_location: String = "user://user_settings.json"
var default_settings_config_location: String = "res://user_settings.json"
var rng_seed:String = "GMTK2025"
var loop:int = 0
var boss_kills:float = 0
var hp:int = 12
var armor:int = 0
var armor_regen:int = 0
var speed:int = 3
var strength:int = 1
var damage:int = 1
var sight_radius:int = 4
var max_steps:float = 99
var max_speed_bonus_turns_allowed:int = 2
var has_flippers:bool = false
var has_climbing_gear:bool = false


func read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var json_string = FileAccess.get_file_as_string(path)
	var json_dict = JSON.parse_string(json_string)
	
	return json_dict
	
func load_settings():
	var config_json: Dictionary = read_json(settings_config_location)
	var default_config_json: Dictionary = read_json(default_settings_config_location)
	if config_json.is_empty():
		config_json = default_config_json
	# audio sliders 0.0 - 100.0
	volume_master = config_json.get("volume_master", volume_master)
	volume_sfx = config_json.get("volume_sfx", volume_sfx)
	volume_music = config_json.get("volume_music", volume_music)
	volume_voice = config_json.get("volume_voice", volume_voice)
	rng_seed = config_json.get("rng_seed", rng_seed)
	boss_kills = config_json.get("boss_kills", boss_kills)
	loop = config_json.get("loop", loop)
	
	hp = config_json.get("hp", hp)
	armor = config_json.get("armor", armor)
	armor_regen = config_json.get("armor_regen", armor_regen)
	speed = config_json.get("speed", speed)
	strength = config_json.get("strength", strength)
	damage = config_json.get("damage", damage)
	sight_radius = config_json.get("sight_radius", sight_radius)
	max_steps = config_json.get("max_steps", max_steps)
	max_speed_bonus_turns_allowed = config_json.get("max_speed_bonus_turns_allowed", max_speed_bonus_turns_allowed)
	has_flippers = config_json.get("has_flippers", has_flippers)
	has_climbing_gear = config_json.get("has_climbing_gear", has_climbing_gear)
	
func save_settings():
	var config_json: Dictionary = read_json(settings_config_location)
	# audio sliders 0.0 - 100.0
	config_json["volume_master"] = volume_master
	config_json["volume_sfx"] = volume_sfx
	config_json["volume_music"] = volume_music
	config_json["volume_voice"] = volume_voice
	
	config_json["rng_seed"] = rng_seed
	config_json["boss_kills"] = boss_kills
	config_json["loop"] = loop
	
	config_json["hp"] = hp
	config_json["armor"] = armor
	config_json["armor_regen"] = armor_regen
	config_json["speed"] = speed
	config_json["strength"] = strength
	config_json["damage"] = damage
	config_json["sight_radius"] = sight_radius
	config_json["max_steps"] = max_steps
	config_json["max_speed_bonus_turns_allowed"] = max_speed_bonus_turns_allowed
	config_json["has_flippers"] = has_flippers
	config_json["has_climbing_gear"] = has_climbing_gear
	
	# save the results
	var json_string := JSON.stringify(config_json)
	# We will need to open/create a new file for this data string
	var file_access := FileAccess.open(settings_config_location, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
		
	file_access.store_line(json_string)
	file_access.close()
