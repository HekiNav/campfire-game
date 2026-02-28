class_name Inventory
extends Control

@export var WIDTH = 8
@export var MAX_STACK_SIZE = 10
@onready var SIZE = global.inventory_size
var inventory_tile = preload("res://inventory/inventory_tile.tscn")
@onready var grid_container: GridContainer = $CenterContainer/GridContainer

func add_items(item: String, count = 1):
	pass

var inventory_data = [["test",10], null, ["test", 9], null, null, null, ["test",6]]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = !visible
		global.is_menu_open = visible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_container.columns = WIDTH
	for x in range(SIZE):
		if inventory_data.size() <= x: 
			inventory_data.push_back(null)
		grid_container.add_child(inventory_tile.instantiate())
	print(inventory_data)
	update_inventory_ui()

func update_inventory_ui():
	for i in range(inventory_data.size()):
		print(i, inventory_data[i])
		(grid_container.get_child(i) as InventoryTile).item = inventory_data[i]
		(grid_container.get_child(i) as InventoryTile).reload()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
