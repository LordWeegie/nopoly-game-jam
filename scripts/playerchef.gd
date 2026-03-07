extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	velocity = velocity.normalized() * speed
	if velocity.y > 0 or velocity.x > 0 or velocity.y < 0 or velocity.x < 0:
		rotation = atan2(velocity.x, velocity.y)
func _physics_process(delta):
	if velocity.y != 0 or velocity.x != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.stop()
#	if velocity.x > 0:
#		global_rotation = 90
#	if velocity.x < 0:
#		global_rotation = -90
#	if velocity.y > 0:
#		global_rotation = 180
#	if velocity.y < 0:
#		global_rotation = -180
	get_input()
	move_and_slide()
