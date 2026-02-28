extends Node2D

@onready var foreground = self.get_node("MapForeground")
@onready var background = self.get_node("MapBackground")
@onready var miningIndicator = self.get_node("MiningIndicator")
@onready var aSprite = miningIndicator.get_node("ASprite")
@export var player: Player
@onready var collapse_effects: Node2D = $collapseEffects
@onready var map_background: TileMapLayer = $MapBackground
const WEAK_SUPPORT_PARTICLES = preload("res://collapse/weak_support_particles.tscn")

var supportLevels: Dictionary

var minedCell: Vector2i
var miningProgress: float


func _ready() -> void:
	pass

	
func _physics_process(delta: float) -> void:
	if not global.is_menu_open:
		var mx=round((self.get_local_mouse_position().x/16)-0.5)*16
		var my=round((self.get_local_mouse_position().y/16)-0.5)*16
		miningIndicator.position=Vector2i(mx,my)
		if Input.is_action_pressed("mine"):
			var selectedCell = foreground.local_to_map(foreground.get_local_mouse_position())
			if(minedCell==selectedCell):
				if(foreground.get_cell_tile_data(minedCell)==null):
					aSprite.get_node("Target").frame=0
				else:
					aSprite.get_node("Target").frame=1
					if(1<=miningProgress):
						print(get_clicked_tile_power())
						mine_cell()
						aSprite.frame=0
					else:
						aSprite.frame=(floor(miningProgress*5)-1)
						miningProgress=miningProgress+delta
						
			else:
				miningProgress=0
				minedCell=selectedCell

		if Input.is_action_pressed("place"):
			var selectedCell = foreground.local_to_map(foreground.get_local_mouse_position())
			if(foreground.get_cell_tile_data(selectedCell)==null):
				foreground.set_cell(selectedCell,0,Vector2i(1, 1), 0)
				supportLevels.set(selectedCell,5)
				cell_update(selectedCell)

func mine_cell():
	var cell = foreground.local_to_map(foreground.get_local_mouse_position())
	var name = get_clicked_tile_power()
	foreground.set_cell(cell,-1,Vector2i(0, 0), 0)
	background.set_cell(cell,0,Vector2i(0, 1), 0)
	miningProgress=0
	player.inventory.add_items(name,1)
	supportLevels.set(cell,0)
	cell_update(cell)


func get_clicked_tile_power():
	var clicked_cell = foreground.local_to_map(foreground.get_local_mouse_position())
	var data = foreground.get_cell_tile_data(clicked_cell)
	if data:
		return data.get_custom_data("name")
	else:
		return ""
		
func cell_update(cell: Vector2i):
	for c in collapse_effects.get_children():
		c.free()
	var name = get_clicked_tile_power()
	if name == "support":
		supportLevels[cell] = 10
	var supports = []
	for k in supportLevels.keys():
		print(supportLevels[k])
		if supportLevels[k] != 10:
			print(k)
			supportLevels[k] = 0
		else:
			supports.push_back(k)
	
	for s in supports:
		const costX = 1
		const costY = 5
		for d in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP]:
			var cost = costX if d.y ==  0 else costY
			var support = 10 - cost
			var i = 1
			while support > 0:
				var tile = d*i+s
				if supportLevels.has(tile): 
					if supportLevels[tile] < support: supportLevels.set(tile, support)
				i += 1
				support -= cost
	var weaklySupported = []
	var notSupported = []
	for k in supportLevels.keys():
		print("erfi9oerfi ",supportLevels[k])
		if supportLevels[k] == 0:
			notSupported.push_back(k)
		elif supportLevels[k] < 5:
			weaklySupported.push_back(k)
	print(weaklySupported, notSupported, supportLevels)
	for k in weaklySupported:
		var newParticles: GPUParticles2D = WEAK_SUPPORT_PARTICLES.instantiate()
		
		newParticles.position = k * 16
		collapse_effects.add_child(newParticles)
