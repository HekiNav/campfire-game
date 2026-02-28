extends Node2D

@onready var frontground = self.get_node("MapBackground")
@onready var background = self.get_node("MapBackground")


func _ready() -> void:
	var coords: Vector2i
	coords.x=0
	coords.y=3
	set_cell(coords, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0)
