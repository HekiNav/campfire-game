extends Control

var level = 100
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
var warning_time=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update() -> void:
	texture_progress_bar.value = level
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	level = min(max(level - delta * global.ogygen_depletion_speed,0),100)
	update()
	
	if (level<30):
		warning_time=warning_time+delta
		if(0.5<warning_time):
			warning_time=0
			self.get_node("Warning").visible=!self.get_node("Warning").visible
	else:
		self.get_node("Warning").visible=false
		
		
