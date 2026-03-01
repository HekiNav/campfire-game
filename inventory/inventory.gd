class_name Inventory
extends Control

@export var WIDTH = 8
@export var MAX_STACK_SIZE = 10
@export var BACKGROUND = true
@export var LINKED_INV: Inventory
@export var TYPE = "inv"
var inventory_tile = preload("res://inventory/inventory_tile.tscn")
@onready var grid_container: GridContainer = $CenterContainer/Control/GridContainer
@onready var moving_tile: InventoryTile = $movingTile
@onready var background: ColorRect = $Background

var picked_up_item = null

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


var SIZE = 0
# Called when the node enters the scene tree for the first time.
func get_inv_size():
	return global.inventory_size * (global.inventory_upgrades + 1) if TYPE == "inv" else global.locker_size + (global.inventory_upgrades *8)
func _ready() -> void:
	SIZE = get_inv_size()
	background.visible = BACKGROUND
	grid_container.columns = WIDTH
	for x in range(SIZE):
		if inventory_data.size() <= x: 
			inventory_data.push_back(null)
		var new_tile = inventory_tile.instantiate()
		new_tile.background = true
		grid_container.add_child(new_tile)
	update_inventory_ui()
	if (TYPE == "locker"):
		add_items("iron",8)
		add_items("support",2)
		add_items("aluminium",1)
		add_items("fossil",1)

func update_inventory_ui():
	for i in range(inventory_data.size()):
		(grid_container.get_child(i) as InventoryTile).item = inventory_data[i]
		(grid_container.get_child(i) as InventoryTile).reload()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for s in inventory_data:
		if s and s[1] == 0:
			var i = inventory_data.find(s)
			inventory_data[i] = null
			update_inventory_ui()
	if SIZE != get_inv_size():
		
		SIZE = get_inv_size()
		for c in grid_container.get_children():
			c.queue_free()
		print(inventory_data)
		
		for x in range(SIZE):
			if inventory_data.size() <= x: 
				print("kiojokipfdkoidf")
				inventory_data.push_back(null)
			var new_tile = inventory_tile.instantiate()
			new_tile.background = true
			grid_container.add_child(new_tile)
		update_inventory_ui()
	pass

func _on_grid_container_gui_input(event: InputEvent) -> void:
	const TILE_WIDTH = 12*4
	
	if event is InputEventMouse and visible:
		var x = floor(event.position.x / TILE_WIDTH)
		var y = floor(event.position.y / TILE_WIDTH)
		var i = y*WIDTH+x
		print(i)
		if i >= inventory_data.size() or i < 0: 
			for c in grid_container.get_children():
				c.set_hovered(false)
			return
		for c in grid_container.get_children():
			c.set_hovered(false)
		grid_container.get_child(i).set_hovered(true)
		
		if event.button_mask == 2 and event.is_pressed() and inventory_data[i] and (not picked_up_item) and LINKED_INV:
			var response = LINKED_INV.add_items(inventory_data[i][0], inventory_data[i][1])
			if (response): inventory_data[i] = null
			update_inventory_ui()
		elif event.button_mask == 1 and event.is_pressed() and inventory_data[i] and not picked_up_item:
			picked_up_item = inventory_data[i]
			inventory_data[i] = null
			update_inventory_ui()
			print("pickup")
		elif event.button_mask == 0 and event.is_released() and picked_up_item:
			inventory_data[i] = picked_up_item
			picked_up_item = null
			update_inventory_ui()
			
		if picked_up_item:
			moving_tile.visible = true
			moving_tile.item = picked_up_item
			moving_tile.global_position = event.global_position + Vector2(TILE_WIDTH* -0.5,TILE_WIDTH* -0.5)
			moving_tile.reload()
			print(moving_tile.global_position)
		else:
			moving_tile.visible = false
		
func clear():
	print("eero")
	inventory_data = []
	for x in range(SIZE):
		if inventory_data.size() <= x: 
			inventory_data.push_back(null)
