extends Control
@export var player: Player
@onready var player_inv: Inventory = $player_inv
@onready var locker: LinkedInventories = $locker
@onready var crafting_ui: CraftingUI = $crafting_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if global.is_menu_open:
			player_inv.visible = false
			locker.visible = false
			crafting_ui.visible = false
			global.is_menu_open = false
			global.keybinds_visible = ["basic"]
			return
			
		var  inv_to_open = player_inv
		var colliding_bodies = player.colliding()
		global.keybinds_visible = ["menu"]

		if colliding_bodies.size() > 0 and colliding_bodies[0].name == "locker":
			global.keybinds_visible = ["menu", "locker"]
			
			inv_to_open = locker
			locker.load()
		elif colliding_bodies.size() > 0 and colliding_bodies[0].name == "crafting_bench":
			global.keybinds_visible = ["menu"]
			
			inv_to_open = crafting_ui
			crafting_ui.load()
		inv_to_open.visible = !inv_to_open.visible
		
		global.is_menu_open = inv_to_open.visible
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
