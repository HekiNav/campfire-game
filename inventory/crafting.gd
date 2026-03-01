class_name CraftingUI
extends Control

@export var player: Player
@onready var inventory: Inventory = $VBoxContainer/Inventory
@onready var recipe_container: VBoxContainer = $VBoxContainer/CenterContainer/ScrollContainer/recipeContainer
const CRAFTING_RECIPE = preload("res://inventory/crafting_recipe.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not player:
		return

	
func load():
	inventory.inventory_data = player.inventory.inventory_data
	inventory.update_inventory_ui()
	for c in recipe_container.get_children():
		c.queue_free()
	for r in global.crafting_recipes:
		var new_recipe = CRAFTING_RECIPE.instantiate()
		new_recipe.RECIPE = r
		recipe_container.add_child(new_recipe)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
