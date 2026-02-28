extends Control

@export var WIDTH = 8
@onready var SIZE = global.inventory_size
var inventory_tile = preload("res://inventory/inventory_tile.tscn")
@onready var grid_container: GridContainer = $CenterContainer/GridContainer

var inventory_data = []

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = !visible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(grid_container)
	grid_container.columns = WIDTH
	for x in range(SIZE):
		inventory_data.push_front(null)
		grid_container.add_child(inventory_tile.instantiate())
	update_inventory_ui()
	
func update_inventory_ui():
	for i in range(inventory_data.size()):
		print(grid_container.get_child(i))
		(grid_container.get_child(i) as InventoryTile).item = inventory_data[i]
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
