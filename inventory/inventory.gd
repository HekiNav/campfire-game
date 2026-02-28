class_name Inventory
extends Control

@export var WIDTH = 8
@export var MAX_STACK_SIZE = 10
@onready var SIZE = global.inventory_size
var inventory_tile = preload("res://inventory/inventory_tile.tscn")
@onready var grid_container: GridContainer = $CenterContainer/GridContainer

func add_items(item: String, count = 1):
	var inclomplete_stack = inventory_data.find_custom(func (e):  return e and e[0] == item && e[1] < MAX_STACK_SIZE)
	if inclomplete_stack >= 0:
		var to_add = min(MAX_STACK_SIZE - inventory_data[inclomplete_stack][1],count)
		inventory_data[inclomplete_stack][1] += to_add
		if (count - to_add > 0): 
			add_items(item, count-to_add)
		else:
			update_inventory_ui()
	else:
		var empty_slot = inventory_data.find_custom(func (e): return e == null)
		if empty_slot >= 0:
			var to_add = min(MAX_STACK_SIZE,count)
			inventory_data[empty_slot] = [item, to_add]
			if (count - to_add > 0): 
				add_items(item, count-to_add)
			else:
				update_inventory_ui()
		else:
			print(empty_slot)
			return false
	return true

var inventory_data = []



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_container.columns = WIDTH
	for x in range(SIZE):
		if inventory_data.size() <= x: 
			inventory_data.push_back(null)
		grid_container.add_child(inventory_tile.instantiate())
	update_inventory_ui()
	add_items("test",2)
	add_items("test",9)
	add_items("test",67)
	print(inventory_data)

func update_inventory_ui():
	for i in range(inventory_data.size()):
		(grid_container.get_child(i) as InventoryTile).item = inventory_data[i]
		(grid_container.get_child(i) as InventoryTile).reload()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = !visible
		global.is_menu_open = visible

func _on_grid_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print(event.position)
