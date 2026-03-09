extends Node

var active_food : String = "Nothing"

var bowl_items : Array = []
var coffee_machine_items : Array = []

var foods : Array[String] = ["baguette", "coffee", "croissant"]

var random_food : int = randi_range(0, 2)

var baguette_recipe : String = "Recipe: \n1: Mix Wheat, Water, Salt, and Yeast in a bowl \n2: Bake in oven \n3: Take to delivery point"
var coffee_recipe : String = "Recipe: \n1: Put Coffee Packet and Water in Coffee Machine \n2: Turn on Coffee Machine \n3: Take Coffee to delivery point"

func _ready() -> void:
	print(random_food)
	active_food = foods[random_food]
	print(active_food)
