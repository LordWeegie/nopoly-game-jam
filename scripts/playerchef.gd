extends CharacterBody2D

@export var speed = 400

var carrying_wheat = false
var carrying_water = false
var carrying_salt = false
var carrying_yeast = false
var carrying_food = false
var carrying_baguette_mix = false
var looking_at_food = false
var carrying_slop = false
var carrying_baguette = false
var looking_at_cfm = false
var carrying_coffee = false
var carrying_coffee_bean = false
@export var oven_open = false
@export var near_bowl = false

var item_carried

func _ready() -> void:
	$Label.text = "Carrying: Nothing"
	$Label2.text = "Active Recipe: " + Global.active_food.capitalize()
	$Label.add_theme_constant_override("shadow_outline_size", 20)
	$Label2.add_theme_constant_override("shadow_outline_size", 20)
	$Label3.add_theme_constant_override("shadow_outline_size", 20)
	$Label4.add_theme_constant_override("shadow_outline_size", 20)

	if Global.active_food == "baguette":
		$Label3.text = Global.baguette_recipe
	if Global.active_food == "coffee":
		$Label3.text = Global.coffee_recipe

func get_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity.length() > 0: $AnimatedSprite2D.flip_h = true if direction.x < 0.0 else false
	velocity = velocity.normalized() * speed
	# Flip player as they move

func _physics_process(delta):
	if len(Global.coffee_machine_items) >= 2:
		if Global.coffee_machine_items.has("water") and Global.coffee_machine_items.has("coffee"):
			carrying_coffee = true
			carrying_food = true
		else:
			carrying_slop = true
			carrying_food = true
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().is_in_group("coffee_machine"):
			looking_at_cfm = true
		else:
			looking_at_cfm = false
	else:
		looking_at_cfm = false
	if carrying_baguette and carrying_food:
		$Label.text = "Carrying: Baguette"
	if carrying_slop and carrying_food:
		$Label.text = "Carrying: Slop"
	if carrying_baguette_mix and oven_open:
		$Label4.text = "Press E to bake Baguette Mix"
		if Input.is_action_just_pressed("pickup"):
			print("Baking...") 
			drop_items()
			carrying_baguette = true
			carrying_food = true
	if carrying_baguette_mix:
		Global.bowl_items = []
		$Label.text = "Carrying: Baguette Mix"
	if near_bowl and Input.is_action_just_pressed("empty_bowl"):
		Global.bowl_items = []
	if near_bowl and !carrying_food:
		if len(Global.bowl_items) > 0:
			var new_bowl_items : String
			new_bowl_items = ", ".join(Global.bowl_items)
			$Label4.text = "Items in bowl: " + new_bowl_items.capitalize() + ", press R to empty bowl"
		else:
			$Label4.text = "Press R to empty bowl"
	if near_bowl:
		if carrying_salt or carrying_water or carrying_wheat or carrying_yeast:
			if len(Global.bowl_items) > 0:
				var new_bowl_items : String
				new_bowl_items = ", ".join(Global.bowl_items)
				$Label4.text = "Press E to add ingredient, Items in bowl: " + new_bowl_items.capitalize() + ", press R to empty bowl"
			else:
				$Label4.text = "Press E to add ingredient or R to empty bowl"
		if Input.is_action_just_pressed("pickup"):
			if carrying_salt or carrying_water or carrying_wheat or carrying_yeast:
				Global.bowl_items.append(item_carried)
				print(Global.bowl_items)
				drop_items()
	if Global.bowl_items.has("wheat") and Global.bowl_items.has("yeast") and Global.bowl_items.has("water") and Global.bowl_items.has("salt") and len(Global.bowl_items) <= 4 and Global.active_food == "baguette":
		carrying_baguette_mix = true
		carrying_food = true
		Global.bowl_items = []
	elif Global.active_food == "baguette" and len(Global.bowl_items) > 4:
		carrying_food = true
		carrying_slop = true
		Global.bowl_items = []
	elif Global.active_food == "baguette" and len(Global.bowl_items) == 4 and carrying_baguette_mix == false:
		print("the slop")
		carrying_slop = true
		carrying_food = true
		Global.bowl_items = []


	if not $RayCast2D.is_colliding():
		looking_at_food = false
	
	
	if looking_at_cfm and Global.active_food == "coffee":
		$Label4.text = "Looking at Coffee Machine"
	if looking_at_cfm and carrying_water and Global.active_food == "coffee":
		if Input.is_action_just_pressed("pickup"):
			Global.coffee_machine_items.append("water")
			print(Global.coffee_machine_items)
			print("Ingredient in coffee machine")
			drop_items()
		$Label4.text = "Put ingredient in Coffee Machine?"
	if looking_at_food and !looking_at_cfm:
		$Label4.text = "Press E to pick up"
	if !looking_at_food and !near_bowl and !oven_open and !looking_at_cfm:
		$Label4.text = ""
	if !carrying_food:
		$Label.text = "Carrying: Nothing"
	if Input.is_action_just_pressed("drop"):
		drop_items()
		
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().is_in_group("wheat") and carrying_food == false:
			looking_at_food = true
			if Input.is_action_just_pressed("pickup"):
				print("Picking up object")
				$Label.text = "Carrying: Wheat"
				looking_at_food = false
				item_carried = "wheat"
				carrying_food = true
				carrying_wheat = true
		elif $RayCast2D.get_collider().is_in_group("salt") and carrying_food == false:
			looking_at_food = true
			if Input.is_action_just_pressed("pickup"):
				looking_at_food = false
				print("Picking up object")
				$Label.text = "Carrying: Salt"
				item_carried = "salt"
				carrying_food = true
				carrying_salt = true
		elif $RayCast2D.get_collider().is_in_group("water") and carrying_food == false:
			looking_at_food = true
			if Input.is_action_just_pressed("pickup"):
				item_carried = "water"
				looking_at_food = false
				print("Picking up object")
				$Label.text = "Carrying: Water"
				carrying_food = true
				carrying_water = true
		elif $RayCast2D.get_collider().is_in_group("yeast") and carrying_food == false:
			looking_at_food = true
			if Input.is_action_just_pressed("pickup"):
				item_carried = "yeast"
				looking_at_food = false
				print("Picking up object")
				$Label.text = "Carrying: Yeast"
				carrying_food = true
				carrying_yeast = true
	else:
		looking_at_food = false



	if velocity.x > 0 or Input.is_action_pressed("right"):
		$RayCast2D.rotation_degrees = -90
		$AnimatedSprite2D.rotation_degrees = -90
	elif velocity.x < 0 or Input.is_action_pressed("left"):
		$RayCast2D.rotation_degrees = 90
		$AnimatedSprite2D.rotation_degrees = 90
	elif velocity.y > 0 or Input.is_action_pressed("down"):
		$RayCast2D.rotation_degrees = 0
		$AnimatedSprite2D.rotation_degrees = 0
	elif velocity.y < 0 or Input.is_action_pressed("up"):
		$RayCast2D.rotation_degrees = 180
		$AnimatedSprite2D.rotation_degrees = 180

	
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
	if !carrying_food:
		$Label.text = "Carrying: Nothing"
	get_input()
	move_and_slide()

func drop_items():
		carrying_food = false
		carrying_salt = false
		carrying_wheat = false
		carrying_water = false
		carrying_yeast = false
		carrying_slop = false
		carrying_baguette_mix = false
		carrying_baguette = false
		item_carried = ""
