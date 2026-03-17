extends Node2D

var table_spots : Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("boom")
		get_tree().reload_current_scene()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print('flying')
		body.fly = true


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("WOW")
		get_tree().change_scene_to_file("res://scenes/main.tscn")
