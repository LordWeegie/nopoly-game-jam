extends CharacterBody2D

@export var speed = 400

func _ready() -> void:
	$Label2.text = "Active Recipe: " + Global.active_food
	$Label.add_theme_constant_override("shadow_outline_size", 20)
	$Label2.add_theme_constant_override("shadow_outline_size", 20)
	$Label3.add_theme_constant_override("shadow_outline_size", 20)
	if Global.active_food == "baguette":
		$Label3.text = Global.beaguette_recipe


func get_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity.length() > 0: $AnimatedSprite2D.flip_h = true if direction.x < 0.0 else false
	velocity = velocity.normalized() * speed
	# Flip player as they move
	if velocity.y > 0 or velocity.x > 0 or velocity.y < 0 or velocity.x < 0:
		$AnimatedSprite2D.rotation = atan2(velocity.x, velocity.y)

func _physics_process(delta):
	if velocity.x > 0:
		$RayCast2D.rotation_degrees = -90
	elif velocity.x < 0:
		$RayCast2D.rotation_degrees = 90
	if velocity.y > 0:
		$RayCast2D.rotation_degrees = 0
	elif velocity.y < 0:
		$RayCast2D.rotation_degrees = 180

	
	if Input.is_action_pressed("sprint"):
		$AnimatedSprite2D.speed_scale = 3.0
		speed = 600
	else:
		$AnimatedSprite2D.speed_scale = 1.0
		speed = 400
	# Animation logic
	if velocity.y != 0 or velocity.x != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.stop()
	get_input()
	move_and_slide()
