extends Node2D

class_name InventoryItem

@export var icon:Sprite2D
@export var title:RichTextLabel

func update(icon_path:String, item_name:String):
	icon.texture = load(icon_path)
	title.text = "[center]%s[/center]"%[item_name]



func _on_ready() -> void:
	
	pass # Replace with function body.
