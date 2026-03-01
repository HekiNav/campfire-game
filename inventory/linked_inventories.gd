class_name LinkedInventories
extends Control

@export var player: Player
@onready var inventory: Inventory = $VBoxContainer/Inventory
@onready var inventory2: Inventory = $VBoxContainer/Inventory2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not player:
		return

	
func load():
	inventory2.inventory_data = player.inventory.inventory_data
	inventory2.update_inventory_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
