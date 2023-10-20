extends CharacterBody2D

func _physics_process(delta):
	move_and_slide()
	
	if velocity == Vector2.ZERO:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "player":
		get_tree().quit()

