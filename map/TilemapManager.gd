extends Node2D

@onready var foreground = self.get_node("MapForeground")
@onready var background = self.get_node("MapBackground")

var minedCell: Vector2i
var miningProgress: float


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
	print(foreground.get_cell_atlas_coords(coords))

	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("mine"):
		var selectedCell = foreground.local_to_map(foreground.get_local_mouse_position())
		if(minedCell==selectedCell):
			if(1<=miningProgress):
				print(get_clicked_tile_power())
				mine_cell()
			else:
				miningProgress=miningProgress+delta
		else:
			miningProgress=0
			minedCell=selectedCell
		
func mine_cell():
	var cell = foreground.local_to_map(foreground.get_local_mouse_position())
	var name = get_clicked_tile_power()
	foreground.set_cell(cell,-1,Vector2i(0, 0), 0)
	background.set_cell(cell,0,Vector2i(1, 0), 0)


func get_clicked_tile_power():
	var clicked_cell = foreground.local_to_map(foreground.get_local_mouse_position())
	var data = foreground.get_cell_tile_data(clicked_cell)
	if data:
		return data.get_custom_data("name")
	else:
		return 0
