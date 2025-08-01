extends VBoxContainer

class_name AudioSlider
@export var slider_master:Slider
@export var slider_sfx:Slider
@export var slider_music:Slider
@export var slider_voice:Slider


func _on_ready() -> void:
	Global.load_settings()
	slider_master.value = Global.volume_master
	slider_sfx.value = Global.volume_sfx
	slider_music.value = Global.volume_music
	slider_voice.value = Global.volume_voice
	update_all_volumes()

func update_all_volumes():
	update_volume(AudioServer.get_bus_index("Master"), Global.volume_master)
	update_volume(AudioServer.get_bus_index("SFX"), Global.volume_sfx )
	update_volume(AudioServer.get_bus_index("Music"), Global.volume_music)
	update_volume(AudioServer.get_bus_index("Voice"), Global.volume_voice)
	
func update_volume(audio_bus_index: int, linear_value: float):
	var volume_db = 20 * (log(linear_value * 0.01) / log(10))
	AudioServer.set_bus_volume_db(audio_bus_index, volume_db)
	Global.save_settings()
	
func _on_slider_value_changed_master(value: float) -> void:
	Global.volume_master = value
	var audio_bus_index:int = AudioServer.get_bus_index("Master")
	update_volume(audio_bus_index, value)

func _on_slider_value_changed_sfx(value: float) -> void:
	Global.volume_sfx = value
	var audio_bus_index:int = AudioServer.get_bus_index("Master")
	update_volume(audio_bus_index, value)

func _on_slider_value_changed_music(value: float) -> void:
	Global.volume_music = value
	var audio_bus_index:int = AudioServer.get_bus_index("Master")
	update_volume(audio_bus_index, value)
	
func _on_slider_value_changed_voice(value: float) -> void:
	Global.volume_voice = value
	var audio_bus_index:int = AudioServer.get_bus_index("Master")
	update_volume(audio_bus_index, value)
