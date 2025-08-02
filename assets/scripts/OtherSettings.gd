extends VBoxContainer

class_name OtherSettings
@export var seed_text:TextEdit

func _on_ready() -> void:
	Global.load_settings()
	seed_text.text = Global.rng_seed
	
func _on_seed_text_changed() -> void:
	Global.rng_seed = seed_text.text
	Global.save_settings()
