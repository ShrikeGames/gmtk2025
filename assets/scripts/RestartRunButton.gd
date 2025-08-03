extends TextureButton
class_name P5TextureButton

@export var button_text:String = "Text"
@export var audio_player: AudioStreamPlayer
@export var text_label:RichTextLabel
@export var random_rotation_amount:float = 10.0
@export var submenu_node:Node2D
@export var button_text_action_completed:String = "Done!"
var normal_texture:Texture2D
# Called when the node enters the scene tree for the first time.
func _on_ready():
	text_label.text = "[center]%s[/center]"%[button_text]

func _on_mouse_entered():
	text_label.rotation_degrees = randf_range(-random_rotation_amount, random_rotation_amount)
	if audio_player:
		audio_player.play()

func _on_mouse_exited() -> void:
	text_label.rotation_degrees = 0

func _on_button_down():
	text_label.rotation_degrees = randf_range(-random_rotation_amount, random_rotation_amount)

func _on_button_up():
	do_action()
	text_label.rotation_degrees = 0

func do_action():
	Global.reset_run()
	text_label.text = "[center]%s[/center]"%[button_text_action_completed]
