extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -150.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0 and velocity.y == 0 or velocity.x < 0 and velocity.y == 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("jump")
		
	if velocity.x > 0:
		if $RayCastContainer != null:
			$RayCastContainer.scale.x = 1
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		if $RayCastContainer != null:
			$RayCastContainer.scale.x = -1
		$AnimatedSprite2D.flip_h = true

	move_and_slide()
