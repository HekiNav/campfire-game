class_name Player
extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -150.0
@export var inventory: Inventory
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
var rng = RandomNumberGenerator.new()
var shake =1;

func colliding():
	return area_2d.get_overlapping_bodies()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if global.mining_direction && global.mining_direction.y < -0.5:
		animated_sprite_2d.play("mine_v")
	elif global.mining_direction && global.mining_direction.x < -0.5:
		animated_sprite_2d.play("mine_h")
		animated_sprite_2d.flip_h = true
	elif global.mining_direction && global.mining_direction.x > -0.5:
		animated_sprite_2d.play("mine_h")
		animated_sprite_2d.flip_h = false
	elif Input.is_action_just_pressed("jump") and is_on_floor() and not global.is_menu_open:
		velocity.y = JUMP_VELOCITY
	elif (velocity.x<0):
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("walk")
	elif  (velocity.x>0):
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction and not global.is_menu_open:
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = 0
	else:
		velocity.x = velocity.x * 0.99
	move_and_slide()

	if(global.camera_shaking):
		$Camera2D.position.x=round(rng.randf_range(-shake, shake))
		$Camera2D.position.y=round(rng.randf_range(-shake, shake))
