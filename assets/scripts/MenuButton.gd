extends TextureButton
class_name P5TextureButton

@export var button_text:String = "Text"
@export var scene_to_change_to: String = ""
@export var audio_player: AudioStreamPlayer
@export var text_label:RichTextLabel
@export var random_rotation_amount:float = 10.0
@export var toggle_visiblity_node:Node2D
@export var submenu_node:Node2D

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
	if scene_to_change_to != null and not scene_to_change_to.is_empty():
		Global.save_settings()
		get_tree().change_scene_to_file(scene_to_change_to)
	elif submenu_node != null and toggle_visiblity_node != null:
		for child in submenu_node.get_children():
			child.visible = false
		toggle_visiblity_node.visible = true
