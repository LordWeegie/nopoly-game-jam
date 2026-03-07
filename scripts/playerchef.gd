extends CharacterBody2D

@export var speed = 400

func _ready() -> void:
	$Label.add_theme_constant_override("shadow_outline_size", 20)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	velocity = velocity.normalized() * speed
	# Flip player as they move
	if velocity.y > 0 or velocity.x > 0 or velocity.y < 0 or velocity.x < 0:
		$AnimatedSprite2D.rotation = atan2(velocity.x, velocity.y)
func _physics_process(delta):
	# Animation logic
	if velocity.y != 0 or velocity.x != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.stop()
	get_input()
	move_and_slide()
