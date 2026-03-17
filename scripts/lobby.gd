extends Node2D

var table_spots : Array
var area_count : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	table_spots = get_tree().get_nodes_in_group("table_area")
	print(len(table_spots))
	area_count = randi_range(0, len(table_spots))
	print(area_count)
	for i in range(len(table_spots)):
		if i != area_count:
			table_spots[i].monitoring = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(len(table_spots)):
		if i != area_count:
			pass
		else:
			var overlapping_bodies = table_spots[i].get_overlapping_bodies()
			if len(overlapping_bodies) == 0:
				$CharacterBody2D.show_text = false
			
			for body in overlapping_bodies:
				if body.is_in_group("player"):
					body.show_text = true
					if Input.is_action_just_pressed("pickup"):
						print("off with thou")
						if Global.active_food == "coffee":
							get_tree().change_scene_to_file("res://scenes/coffee_level.tscn")
						elif Global.active_food == "baguette":
							get_tree().change_scene_to_file("res://scenes/baguette_eating.tscn")
						elif Global.active_food == "croissant":
							get_tree().change_scene_to_file("res://scenes/crossiant_eating.tscn")
