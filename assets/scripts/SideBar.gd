extends Node2D
class_name SideBar

@export var stats_text:RichTextLabel

func update_stats(steps:float, max_steps:float, hp:int, armor:int, speed:int, build:int, damage:int, vision:int):
	var steps_rich_text:String = "[color=#222222]Steps: %d/%d[/color]"%[int(steps), int(max_steps)]
	var hp_rich_text:String = "[color=#992211]HP: %d[/color]"%[hp]
	var armor_rich_text:String = "[color=#000099]Armor: %d[/color]"%[armor]
	var speed_rich_text:String = "[color=#119911]Speed: %d[/color]"%[speed]
	var build_rich_text:String = "[color=#994411]Build: %d[/color]"%[build]
	var damage_rich_text:String = "[color=#991177]Damage: %d[/color]"%[damage]
	var vision_rich_text:String = "[color=#997700]Vision: %d[/color]"%[vision]
	var rich_text:String = "%s\n%s\n%s\n%s\n%s\n%s\n%s\n"%[steps_rich_text, hp_rich_text, armor_rich_text, speed_rich_text, build_rich_text, damage_rich_text, vision_rich_text]
	
	stats_text.text = rich_text
