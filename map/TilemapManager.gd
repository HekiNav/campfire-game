extends Node2D

@onready var foreground = self.get_node("MapForeground")
@onready var background = self.get_node("MapBackground")


func _ready() -> void:
	var coords: Vector2i
	coords.x=0
	coords.y=3
	foreground.set_cell(coords, 0, Vector2i(2, 0), 0)
	coords.y=2
	foreground.set_cell(coords, 0, Vector2i(1, 0), 0)
	coords.y=1
	foreground.set_cell(coords, 0, Vector2i(0, 0), 0)
	coords.y=0
	foreground.set_cell(coords, 0, Vector2i(0, 1), 0)
	print(foreground.get_cell_tile_data(coords))
