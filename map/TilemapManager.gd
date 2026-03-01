extends Node2D

@onready var foreground = self.get_node("MapForeground")
@onready var background = self.get_node("MapBackground")
@onready var realground = self.get_node("VisibleMapForeground")

@onready var miningIndicator = self.get_node("MiningIndicator")
@onready var aSprite = miningIndicator.get_node("ASprite")
@export var player: Player
@onready var collapse_effects: Node2D = $collapseEffects
@onready var map_background: TileMapLayer = $MapBackground
const WEAK_SUPPORT_PARTICLES = preload("res://collapse/weak_support_particles.tscn")
const COLLAPSE = preload("res://collapse/collapse.tscn")

var supportLevels: Dictionary

var minedCell: Vector2i
var miningProgress: float


func _ready() -> void:
	supportLevels[Vector2i(5,1)] = 10
	pass

	
func _physics_process(delta: float) -> void:
	var exploded = []
	var index=0
	
	
	if not global.is_menu_open:
		var selectedCell = foreground.local_to_map(foreground.get_local_mouse_position())
		if Input.is_action_pressed("throw"):
			var item = ["dynamite",1]
			var has_item = player.inventory.inventory_data.find_custom(func(e): return e and e[0]  == item[0] and e[1] >= item[1]) >= 0
			if(has_item):
				# remove item from inv
				var i = player.inventory.inventory_data.find_custom(func(e): return e and e[0]  == item[0] and e[1] >= item[1])
				player.inventory.inventory_data[i][1] -= item[1]
				dynamite(selectedCell,3)
			else:
				global.alert.emit("No dynamite")
		var mx=round((self.get_local_mouse_position().x/16)-0.5)*16
		var my=round((self.get_local_mouse_position().y/16)-0.5)*16
		miningIndicator.position=Vector2i(mx,my)
		
		if(foreground.get_cell_tile_data(selectedCell)==null or !selectedCell.distance_to(foreground.local_to_map(player.position))<3):
			aSprite.get_node("Target").frame=0
		else:
			aSprite.get_node("Target").frame=1
		if Input.is_action_pressed("mine"):
			if (selectedCell.distance_to(foreground.local_to_map(player.position))>=3):
				global.alert.emit("Cannot reach")
			if(minedCell==selectedCell and selectedCell.distance_to(foreground.local_to_map(player.position))<3 ):
				if(foreground.get_cell_tile_data(minedCell)==null):
					aSprite.get_node("Target").frame=0
				else:
					aSprite.get_node("Target").frame=1
					if(foreground.get_cell_tile_data(selectedCell).get_custom_data("hardness")<=miningProgress):
						mine_cell()
						aSprite.frame=0
					else:
						aSprite.frame=(floor(miningProgress*5)-1)
						miningProgress=miningProgress+delta
						global.mining_direction = Vector2(foreground.get_local_mouse_position() - player.position).normalized()
			else:
				global.mining_direction = null
				miningProgress=0
				minedCell=selectedCell
		if Input.is_action_just_released("mine"):
			global.mining_direction = null
		if Input.is_action_pressed("place"):
			var bunker_one_check = (-2<=selectedCell.x and selectedCell.x<=5) and (0<=selectedCell.y and selectedCell.y<=1)
			var item = ["support",1]
			var has_item = player.inventory.inventory_data.find_custom(func(e): return e and e[0]  == item[0] and e[1] >= item[1]) >= 0
			if not has_item:
				global.alert.emit("No supports in inventory")
			if(foreground.get_cell_tile_data(selectedCell)==null and not bunker_one_check and has_item):
				# remove item from inv
				var i = player.inventory.inventory_data.find_custom(func(e): return e and e[0]  == item[0] and e[1] >= item[1])
				player.inventory.inventory_data[i][1] -= item[1]
				
				print(selectedCell)
				foreground.set_cell(selectedCell,0,Vector2i(2, 3), 0)
				supportLevels.set(selectedCell,5)
				cell_update(selectedCell)
		
				
func mine_cell():
	var cell = foreground.local_to_map(foreground.get_local_mouse_position())
	var name = get_clicked_tile_power()
	if(	player.inventory.add_items(name,1)):
		foreground.set_cell(cell,-1,Vector2i(0, 0), 0)
		realground.set_cell(cell,-1,Vector2i(0, 0), 0)
		background.set_cell(cell,0,Vector2i(0, 1), 0)
		
		realground.set_cell(Vector2i(cell.x+1,cell.y),-1,Vector2i(0, 0), 0)
		realground.set_cell(Vector2i(cell.x-1,cell.y),-1,Vector2i(0, 0), 0)
		realground.set_cell(Vector2i(cell.x,cell.y+1),-1,Vector2i(0, 0), 0)
		realground.set_cell(Vector2i(cell.x,cell.y-1),-1,Vector2i(0, 0), 0)

		realground.set_cell(Vector2i(cell.x+1,cell.y+1),-1,Vector2i(0, 0), 0)
		realground.set_cell(Vector2i(cell.x+1,cell.y-1),-1,Vector2i(0, 0), 0)
		realground.set_cell(Vector2i(cell.x-1,cell.y+1),-1,Vector2i(0, 0), 0)
		realground.set_cell(Vector2i(cell.x-1,cell.y-1),-1,Vector2i(0, 0), 0)

		miningProgress=0
		supportLevels.set(cell,0)
		cell_update(cell)
		global.mining_direction = null
		


func get_clicked_tile_power():
	var clicked_cell = foreground.local_to_map(foreground.get_local_mouse_position())
	var data = foreground.get_cell_tile_data(clicked_cell)
	if data:
		return data.get_custom_data("name")
	else:
		return ""
		
func cell_update(cell: Vector2i, collapse = true):
	for c in collapse_effects.get_children():
		c.queue_free()
	var name = get_clicked_tile_power()
	if name == "support":
		supportLevels[cell] = 10
	var supports = []
	for k in supportLevels.keys():
		if supportLevels[k] != 10:
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
		if supportLevels[k] == 0:
			notSupported.push_back(k)
		elif supportLevels[k] < 5:
			weaklySupported.push_back(k)
	if not collapse:
		return
	for k in weaklySupported:
		var newParticles: GPUParticles2D = WEAK_SUPPORT_PARTICLES.instantiate()
		newParticles.position = k * 16
		collapse_effects.add_child(newParticles)
	for k in notSupported:
		if weaklySupported.has(k+Vector2i.UP) && not notSupported.has(k+Vector2i.UP) && supportLevels[k+Vector2i.UP] < 5: notSupported.push_back(k+Vector2i.UP)
		if weaklySupported.has(k+Vector2i.DOWN) && not notSupported.has(k+Vector2i.DOWN) && supportLevels[k+Vector2i.DOWN] < 5: notSupported.push_back(k+Vector2i.DOWN)
		if weaklySupported.has(k+Vector2i.LEFT) && not notSupported.has(k+Vector2i.LEFT) && supportLevels[k+Vector2i.LEFT] < 5: notSupported.push_back(k+Vector2i.LEFT)
		if weaklySupported.has(k+Vector2i.RIGHT) && not notSupported.has(k+Vector2i.RIGHT) && supportLevels[k+Vector2i.RIGHT] < 5: notSupported.push_back(k+Vector2i.RIGHT)
		var newEffect: Node2D = COLLAPSE.instantiate()
		global.camera_shaking=true
		newEffect.position = (Vector2(k) + Vector2(0.5, -0.5)) * 16
		var i = 0
		newEffect.done.connect(func():
			global.camera_shaking=false
			foreground.set_cell(k,0,Vector2i(0, 0), 0)
			supportLevels.erase(k)
			newEffect.queue_free()
			await get_tree().process_frame
			i += 1
			if (i >= notSupported.size()): cell_update(k, false)
		)
		collapse_effects.add_child(newEffect)
		
func dynamite(location: Vector2i,power: int):
	realground.set_cell(location,-1,Vector2i(1, 1), -1)
	print("isitnull", foreground.get_cell_tile_data(location)==null)
	if(power!=0):
		foreground.set_cell(location,-1,Vector2i(1, 1), -1)
		background.set_cell(location,0,Vector2i(0, 1), 0)
		if(Vector2i(location.x+1, location.y)!=null):
			dynamite(Vector2i(location.x+1, location.y),power-1)
		if(Vector2i(location.x-1, location.y)!=null):
			dynamite(Vector2i(location.x-1, location.y),power-1)
		if(Vector2i(location.x, location.y+1)!=null):
			dynamite(Vector2i(location.x, location.y+1),power-1)
		if(Vector2i(location.x, location.y-1)!=null):
			dynamite(Vector2i(location.x, location.y-1),power-1)
