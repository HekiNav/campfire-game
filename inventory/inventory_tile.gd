class_name InventoryTile

extends Control
@export var item: Variant
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.


func reload() -> void:
	print(item)
	if item:
		item_sprite.texture = load(global.ITEMS[item[0]].sprite)
		label.text = str(item[1])
	else:
		label.text = ""


func _on_mouse_entered() -> void:
	sprite_2d_2.visible = true

func _on_mouse_exited() -> void:
	sprite_2d_2.visible = false
