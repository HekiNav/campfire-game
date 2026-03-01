class_name CraftingUI
extends Control

@export var player: Player
@onready var inventory: Inventory = $VBoxContainer/Inventory
@onready var recipe_container: VBoxContainer = $VBoxContainer/CenterContainer/ScrollContainer/recipeContainer
const CRAFTING_RECIPE = preload("res://inventory/crafting_recipe.tscn")
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not player:
		return

	
func load():
	_load()
func _load():
	inventory.inventory_data = player.inventory.inventory_data
	inventory.update_inventory_ui()
	for c in recipe_container.get_children():
		c.queue_free()
	for r in global.crafting_recipes:
		var new_recipe = CRAFTING_RECIPE.instantiate()
		new_recipe.RECIPE = r
		var can_buy = true
		for i in r.ingredients:
			can_buy = can_buy && player.inventory.inventory_data.find_custom(func(e): return e and e[0]  == i[0] and e[1] >= i[1]) >= 0
		new_recipe.CAN_BUY = can_buy
		new_recipe.buy.connect(func():
			for m in r.ingredients:
				var i = player.inventory.inventory_data.find_custom(func(e): return e and e[0]  == m[0] and e[1] >= m[1])
				player.inventory.inventory_data[i][1] -= m[1]
				
			if r.reward.type == "item":
				player.inventory.add_items(r.reward.key, 1)
			elif r.reward.type == "global_var":
				global[r.reward.key] += 1
			timer.start()
			timer.timeout.connect(func(): 
				_load()
			)
		)
		recipe_container.add_child(new_recipe)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
