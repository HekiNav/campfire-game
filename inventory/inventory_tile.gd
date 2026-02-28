class_name InventoryTile

extends Control
@export var item: Variant
@onready var item_sprite: Sprite2D = $Control/ItemSprite
@onready var sprite_2d_2: Sprite2D = $Control/Sprite2D2
@onready var label: Label = $Control/Label
@onready var sprite_2d: Sprite2D = $Control/Sprite2D
@export var background = false


# Called when the node enters the scene tree for the first time.

func reload() -> void:
	sprite_2d.visible = background

	if item:
		item_sprite.texture = load(global.ITEMS[item[0]].sprite)
		label.text = str(item[1])
	else:
		item_sprite.texture = null
		label.text = ""


func set_hovered(value) -> void:
	sprite_2d_2.visible = value
