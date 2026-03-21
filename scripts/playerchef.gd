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
var carrying_milk = false
var carrying_butter = false
var carrying_croissant_dough = false
var carrying_cut_croissant_dough = false
var carrying_croissant = false
var near_delivery_point1 = false
var looking_at_delivery_point1 = false
@onready var timer : Timer = $Timer
@export var loading_bar1 : Node2D
@export var loading_bar2 : Node2D
@export var loading_bar3 : Node2D
@export var oven_open = false
@export var near_bowl = false
@export var near_cutting_board = false
var can_move = true

var item_carried

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Label.text = "Carrying: Nothing"
	$Label2.text = "Active Recipe: " + Global.active_food.capitalize()
	$Label5.add_theme_constant_override("shadow_outline_size", 20)
	$Label.add_theme_constant_override("shadow_outline_size", 20)
	$Label2.add_theme_constant_override("shadow_outline_size", 20)
	$Label3.add_theme_constant_override("shadow_outline_size", 20)
	$Label4.add_theme_constant_override("shadow_outline_size", 20)

	if Global.active_food == "baguette":
		$Label3.text = Global.baguette_recipe
	if Global.active_food == "coffee":
		$Label3.text = Global.coffee_recipe
	if Global.active_food == "croissant":
		$Label3.text = Global.croissant_recipe
func get_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity.length() > 0: $AnimatedSprite2D.flip_h = true if direction.x < 0.0 else false
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	$Label5.text = "Time till restart: " + str(int(timer.time_left))
	if timer.is_stopped():
		print("Starting timer")
		timer.start(45)
	if timer.time_left < 0.1:
		print("!!!")
		get_tree().reload_current_scene()
	if $RayCast2D.is_colliding():
		if near_delivery_point1 and carrying_baguette or near_delivery_point1 and carrying_coffee or near_delivery_point1 and carrying_croissant:
			print("hello dude")
			$Label4.text = "Press E to deliver food"
			if Input.is_action_just_pressed("pickup"):
				get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	if !near_delivery_point1:
		$Label4.text = ""
	if oven_open and carrying_cut_croissant_dough:
		$Label4.text = "Press E to bake Croissant Dough"
		if Input.is_action_just_pressed("pickup"):
			loading_bar1.animation_playing = true
			print("Baking...") 
			drop_items()
			can_move = false
			await $"../Loadingbar/AnimatedSprite2D".animation_finished
			carrying_croissant = true
			carrying_food = true
			can_move = true
	if carrying_coffee_bean:
		$Label.text = "Carrying: Coffee Packet"
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().is_in_group("coffee_bean") and !carrying_food:
			looking_at_food = true
			if Input.is_action_just_pressed("pickup"):
				print("burger")
				carrying_coffee_bean = true
				carrying_food = true
	if len(Global.coffee_machine_items) >= 2:
		if Global.coffee_machine_items.has("water") and Global.coffee_machine_items.has("coffee"):
			if !carrying_coffee:
				loading_bar2.animation_playing = true
			drop_items()
			await $"../Loadingbar2/AnimatedSprite2D".animation_finished
			carrying_coffee = true
			carrying_food = true
			Global.coffee_machine_items = []
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
			loading_bar1.animation_playing = true
			print("Baking...") 
			drop_items()
			can_move = false
			await $"../Loadingbar/AnimatedSprite2D".animation_finished
			carrying_baguette = true
			carrying_food = true
			can_move = true
	if carrying_baguette_mix:
		Global.bowl_items = []
		$Label.text = "Carrying: Baguette Mix"
	if carrying_croissant:
		$Label.text = "Carrying: Croissant"
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
		if carrying_salt or carrying_water or carrying_wheat or carrying_yeast or carrying_milk or carrying_butter:
			if len(Global.bowl_items) > 0:
				var new_bowl_items : String
				new_bowl_items = ", ".join(Global.bowl_items)
				$Label4.text = "Press E to add ingredient, Items in bowl: " + new_bowl_items.capitalize() + ", press R to empty bowl"
			else:
				$Label4.text = "Press E to add ingredient or R to empty bowl"
		if Input.is_action_just_pressed("pickup"):
			if carrying_salt or carrying_water or carrying_wheat or carrying_yeast or carrying_milk or carrying_butter:
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

	if Global.bowl_items.has("wheat") and Global.bowl_items.has("yeast") and Global.bowl_items.has("milk") and Global.bowl_items.has("butter") and Global.bowl_items.has("salt") and len(Global.bowl_items) <= 5 and Global.active_food == "croissant":
		carrying_food = true
		carrying_croissant_dough = true
		Global.bowl_items = []
	elif len(Global.bowl_items) >= 5 and Global.active_food == "croissant":
		carrying_slop = true
		carrying_food = true
		Global.bowl_items = []


	if not $RayCast2D.is_colliding():
		looking_at_food = false
		looking_at_delivery_point1 = false
	
	if near_cutting_board and carrying_croissant_dough:
		$Label4.text = "Press E to cut Croissant Dough"
		if Input.is_action_just_pressed("pickup"):
			loading_bar3.animation_playing = true
			print("Cutting") 
			drop_items()
			can_move = false
			await $"../Loadingbar3/AnimatedSprite2D".animation_finished
			carrying_cut_croissant_dough = true
			carrying_food = true
			can_move = true
	
	if looking_at_cfm and carrying_water and Global.active_food == "coffee":
		$Label4.text = "Put ingredient in Coffee Machine"
		if Input.is_action_just_pressed("pickup"):
			Global.coffee_machine_items.append("water")
			Global.needed_coffee_machine_items.append("water")
			print(Global.coffee_machine_items)
			print("Ingredient in coffee machine")
			drop_items()
	if looking_at_cfm and carrying_coffee_bean and Global.active_food == "coffee":
		$Label4.text = "Put ingredient in Coffee Machine?"
		if Input.is_action_just_pressed("pickup"):
			Global.coffee_machine_items.append("coffee")
			print(Global.coffee_machine_items)
			print("Ingredient in coffee machine")
			drop_items()
	if looking_at_food and !looking_at_cfm:
		$Label4.text = "Press E to pick up"
	if !looking_at_food and !near_bowl and !oven_open and !looking_at_cfm and !near_cutting_board and !looking_at_delivery_point1 and !near_delivery_point1:
		$Label4.text = ""
	if !carrying_food:
		$Label.text = "Carrying: Nothing"
	if carrying_coffee and carrying_food:
		$Label.text = "Carrying: Coffee"
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
		elif $RayCast2D.get_collider().is_in_group("milk") and carrying_food == false:
			looking_at_food = true
			if Input.is_action_just_pressed("pickup"):
				item_carried = "milk"
				looking_at_food = false
				print("Picking up object")
				$Label.text = "Carrying: Milk"
				carrying_food = true
				carrying_milk = true
		elif $RayCast2D.get_collider().is_in_group("butter") and carrying_food == false:
			looking_at_food = true
			if Input.is_action_just_pressed("pickup"):
				item_carried = "butter"
				looking_at_food = false
				print("Picking up object")
				$Label.text = "Carrying: Butter"
				carrying_food = true
				carrying_butter = true
	else:
		looking_at_food = false

	if looking_at_delivery_point1 and $RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("delivery_point1"):
		$Label4.text = "Press E to deliver food"
		if Input.is_action_just_pressed("pickup"):
			get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	if carrying_food and carrying_croissant_dough:
		$Label.text = "Carrying: Uncut Croissant Dough"
	elif carrying_food and carrying_cut_croissant_dough:
		$Label.text = "Carrying: Cut Croissant Dough"

	if can_move:
		if velocity.x > 0 or Input.is_action_pressed("right"):
			$RayCast2D.rotation_degrees = -90
			$AnimatedSprite2D.rotation_degrees = -90
			$CollisionShape2D.rotation_degrees = -90
		if velocity.x < 0 or Input.is_action_pressed("left"):
			$RayCast2D.rotation_degrees = 90
			$AnimatedSprite2D.rotation_degrees = 90
			$CollisionShape2D.rotation_degrees = 90
		if velocity.y > 0 or Input.is_action_pressed("down"):
			$RayCast2D.rotation_degrees = 0
			$AnimatedSprite2D.rotation_degrees = 0
			$CollisionShape2D.rotation_degrees = 0
		if velocity.y < 0 or Input.is_action_pressed("up"):
			$RayCast2D.rotation_degrees = 180
			$AnimatedSprite2D.rotation_degrees = 180
			$CollisionShape2D.rotation_degrees = 180

	
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
	
	if can_move:
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
		carrying_coffee = false
		carrying_coffee_bean = false
		carrying_milk = false
		carrying_butter = false
		carrying_croissant_dough = false
		carrying_cut_croissant_dough = false
		carrying_croissant = false
		item_carried = ""


func _on_button_2_pressed() -> void:
	$Sprite2D.visible = true


func _on_button_pressed() -> void:
	$Sprite2D.visible = false
