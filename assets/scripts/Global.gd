extends Node

var volume_master:float = 100.0
var volume_sfx:float = 50.0
var volume_music:float = 50.0
var volume_voice:float = 50.0
var settings_config_location: String = "user://user_settings.json"
var default_settings_config_location: String = "res://user_settings.json"

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
	
func save_settings():
	var config_json: Dictionary = read_json(settings_config_location)
	# audio sliders 0.0 - 100.0
	config_json["volume_master"] = volume_master
	config_json["volume_sfx"] = volume_sfx
	config_json["volume_music"] = volume_music
	config_json["volume_voice"] = volume_voice
	
	# save the results
	var json_string := JSON.stringify(config_json)
	# We will need to open/create a new file for this data string
	var file_access := FileAccess.open(settings_config_location, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
		
	file_access.store_line(json_string)
	file_access.close()
