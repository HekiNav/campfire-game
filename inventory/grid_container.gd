extends GridContainer

signal input
# Called when the node enters the scene tree for the first time.
func _input(ev: InputEvent):
	#if (ev is InputEventMouse): ev.position -= (get_viewport_rect().size * 0.5 + position)
	pass
	
func _gui_input(event: InputEvent) -> void:
	input.emit(event)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_exited() -> void:
	var ev = InputEventMouseMotion.new()
	ev.position = Vector2i(-1,-1)
	input.emit(ev)
