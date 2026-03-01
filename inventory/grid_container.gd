extends GridContainer

signal input
# Called when the node enters the scene tree for the first time.
func _input(ev: InputEvent):
	if (ev is InputEventMouse): ev.position -= (get_viewport_rect().size * 0.5 + position)
	
	input.emit(ev)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
