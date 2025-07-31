extends Sprite2D
class_name MapTile

@export var item_sprite:Sprite2D
@export var walkable:bool = false
@export var step_cost:int = 1
@export var blocks_sight:bool = false
@export var type:int = 0
@export var title:String = "Tile"
@export var x:int
@export var y:int
@export var texture_path:String
@export var item_id:int = 0
@export var item_texture_path:String

func init(p_x:int, p_y:int, p_position:Vector2, p_type:int, p_item_id:int, p_walkable:bool, p_blocks_sight:bool, p_step_cost:int):
	self.x = p_x
	self.y = p_y
	self.position = p_position
	self.type = p_type
	self.texture_path = "res://assets/images/sprite_sheets/MapTile%d.png"%[self.type]
	self.item_id = p_item_id
	if self.item_id >=0:
		self.item_texture_path = "res://assets/images/sprite_sheets/Item%d.png"%[self.item_id]
	
	self.walkable = p_walkable
	self.blocks_sight = p_blocks_sight
	self.step_cost = p_step_cost
	self.update_texture()
	
func update_texture():
	self.texture = load(self.texture_path)
	if self.item_texture_path:
		self.item_sprite.texture = load(self.item_texture_path)
	self.queue_redraw()
