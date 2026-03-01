extends Control

@export var RECIPE: Variant
@export var CAN_BUY: Variant
@onready var label: RichTextLabel = $RichTextLabel
@onready var button: Button = $Button

signal buy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text += RECIPE.name
	label.text += "\n cost:"
	for i in RECIPE.ingredients:
		label.text += " " + str(i[1])+ " [img width=20px]"+ global.ITEMS[i[0]].sprite+"[/img]"
	button.disabled = !CAN_BUY
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	buy.emit()
