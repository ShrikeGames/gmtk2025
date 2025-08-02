extends Node2D

class_name DamageIndicator
@export var damage_container:Node2D
@export var damage_text:RichTextLabel
@export var upper_y_limit: float = -50
@export var rising_speed: float = 25

func _process(delta: float) -> void:
	if damage_container.position.y > upper_y_limit:
		damage_container.position.y -= rising_speed * delta
	else:
		self.queue_free()
