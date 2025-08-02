extends Sprite2D
class_name MapTile

@export var item_sprite:Sprite2D
@export var walkable:bool = false
@export var step_cost:float = 1
@export var blocks_sight:bool = false
@export var type:int = 0
@export var title:String = "Tile"
@export var x:int
@export var y:int
@export var texture_path:String
@export var item_id:int = 0
@export var item_texture_path:String
@export var discovered:bool

var rewards:Array[Dictionary]
var enemy_stats:Dictionary

func init(p_x:int, p_y:int, p_position:Vector2, p_type:int, p_item_id:int, p_walkable:bool, p_blocks_sight:bool, p_step_cost:float, p_enemy_stats:Dictionary = {}):
	self.x = p_x
	self.y = p_y
	self.position = p_position
	self.type = p_type
	self.texture_path = "res://assets/images/sprite_sheets/MapTile%d.png"%[self.type]
	self.item_id = p_item_id
	
	self.walkable = p_walkable
	self.blocks_sight = p_blocks_sight
	self.step_cost = p_step_cost
	self.enemy_stats = p_enemy_stats
	self.discovered = false
	# so they don't all shake the same (had to set Local to Scene=True on the material and resource)
	self.item_sprite.get_material().set_shader_parameter("timeDelay", self.x*0.5 + self.y*0.5)
	self.update_texture()

func update_texture():
	if self.item_id >= 0:
		self.item_texture_path = "res://assets/images/sprite_sheets/Item%d.png"%[self.item_id]
	else:
		self.item_texture_path = ""
	self.texture = load(self.texture_path)
	if self.item_texture_path:
		self.item_sprite.visible = true
		self.item_sprite.texture = load(self.item_texture_path)
	else:
		self.item_sprite.visible = false
	self.queue_redraw()
