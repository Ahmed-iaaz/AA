extends CharacterBody2D

var fast_fall_enabled = false
@export var speed = 400
@export var jump_speed = -800
@export var gravity = 1800
@export var fast_fall_speed = 50000
@export var scale_speed = 20
@export_range(0.0, 1.0) var friction = 10
@export_range(0.0, 1.0) var acceleration = 10
@onready var particles = $Particles
@onready var camera = $Camera2D
var max_jumps = 2  # Number of jumps allowed
var jump_scale = false

func _physics_process(delta):
	velocity.y += gravity * delta
	var dir = Input.get_axis("move_left", "move_right")
	
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration * delta)
		scale = lerp(scale, Vector2(0.9, 0.7), scale_speed * delta)
		if dir > 0:
			camera.offset.x = lerp(camera.offset.x, 125.0, 2.5 * delta)
		elif dir < 0:
			camera.offset.x = lerp(camera.offset.x, -125.0, 2.5 * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		scale = lerp(scale, Vector2(0.8, 0.8), scale_speed * delta)
		camera.offset.x = lerp(camera.offset.x, 0.0, 3 * delta)
	
	if is_on_floor():
		max_jumps = 2  # Reset jumps when touching the ground
		jump_scale = false

	if Input.is_action_just_pressed("jump") and max_jumps > 0:
		velocity.y = jump_speed
		jump_scale = true
		max_jumps -= 1
		
	if jump_scale:
		scale = lerp(scale, Vector2(0.6, 1.0), scale_speed * delta)
		
	#	# Check for fast fall button input
	if Input.is_action_just_pressed("fast_fall") and not is_on_floor():
		fast_fall_enabled = true
	else:
		fast_fall_enabled = false

	if fast_fall_enabled:
		# Apply faster fall speed if the fast fall button is pressed
		velocity.y += fast_fall_speed * delta
		scale = lerp(scale, Vector2(0.5, 1.2), 50 * delta)
		
	if velocity.x or velocity.y != 0:
		particles.emitting = true
	else:
		particles.emitting = false
	
#	print(camera.offset.x)
	
	move_and_slide()


