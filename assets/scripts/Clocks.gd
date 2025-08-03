extends Node2D

class_name Clock

@export var clock_hand:Node2D


func _on_area_2d_mouse_entered() -> void:
	self.modulate.a = 0.5


func _on_area_2d_mouse_exited() -> void:
	self.modulate.a = 1
