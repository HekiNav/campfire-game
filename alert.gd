extends Label
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	global.alert.connect(func(t): 
		text = t
		timer.start()
	)
	timer.timeout.connect(func(): 
		text = ""
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
