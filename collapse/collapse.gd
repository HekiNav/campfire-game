extends Node2D

@onready var collapse: AnimationPlayer = $collapse

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collapse.play("block_fall")
	

signal done

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	done.emit()
