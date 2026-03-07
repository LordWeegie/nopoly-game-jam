extends CharacterBody2D

@export var speed = 400

var carrying_wheat = false
var carrying_water = false
var carrying_salt = false
var carrying_yeast = false
var carrying_food = false

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
	if !carrying_food:
		$Label.text = "Carrying: Nothing"
	if Input.is_action_just_pressed("drop"):
		carrying_food = false
		carrying_salt = false
		carrying_wheat = false
		carrying_water = false
		carrying_yeast = false
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().is_in_group("wheat") and carrying_food == false:
			if Input.is_action_just_pressed("pickup"):
				print("Picking up object")
				$Label.text = "Carrying: Wheat"
				carrying_food = true
				carrying_wheat = true
		elif $RayCast2D.get_collider().is_in_group("salt") and carrying_food == false:
			if Input.is_action_just_pressed("pickup"):
				print("Picking up object")
				$Label.text = "Carrying: Salt"
				carrying_food = true
				carrying_salt = true
		elif $RayCast2D.get_collider().is_in_group("water") and carrying_food == false:
			if Input.is_action_just_pressed("pickup"):
				print("Picking up object")
				$Label.text = "Carrying: Water"
				carrying_food = true
				carrying_water = true
		elif $RayCast2D.get_collider().is_in_group("yeast") and carrying_food == false:
			if Input.is_action_just_pressed("pickup"):
				print("Picking up object")
				$Label.text = "Carrying: Yeast"
				carrying_food = true
				carrying_yeast = true
	if velocity.x > 0 or Input.is_action_pressed("right"):
		$RayCast2D.rotation_degrees = -90
	if velocity.x < 0 or Input.is_action_pressed("left"):
		$RayCast2D.rotation_degrees = 90
	if velocity.y > 0 or Input.is_action_pressed("down"):
		$RayCast2D.rotation_degrees = 0
	if velocity.y < 0 or Input.is_action_pressed("up"):
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
