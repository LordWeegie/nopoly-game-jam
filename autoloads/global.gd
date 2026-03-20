extends Node

var active_food : String = "Nothing"

var bowl_items : Array = []
var coffee_machine_items : Array = []
var needed_coffee_machine_items : Array = []
var last_food = "Nothing"
var food_once = false

var foods : Array[String] = ["baguette", "coffee", "croissant"]

var random_food : int = randi_range(0, 2)

var baguette_recipe : String = "Recipe: \n1: Mix Wheat, Water, Salt, and Yeast in a bowl \n2: Bake in oven \n3: Take to delivery point"
var coffee_recipe : String = "Recipe: \n1: Put Coffee Packet and Water in Coffee Machine \n2: Wait for Coffee Machine to finish \n3: Take Coffee to delivery point"
var croissant_recipe : String = "Recipe: \n1: Mix Milk, Butter, Yeast, Salt, and Wheat in bowl \n2:Cut on chopping board \n3: Bake in oven \n4: Take to delivery point" 

func _ready() -> void:
	_reset_food()
	print(random_food)
	print(active_food)

func _reset_food():
	last_food = active_food
	while active_food == last_food:
		random_food = randi_range(0, 2)
		active_food = foods[random_food]
	print(random_food)
	print(active_food)
