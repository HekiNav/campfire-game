extends Control

var level = 100
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update() -> void:
	texture_progress_bar.value = level
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	level -= max(delta * global.ogygen_depletion_speed,0)
	update()
