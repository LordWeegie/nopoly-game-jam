extends StaticBody2D

@export var near_player = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.near_cutting_board = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.near_cutting_board = false
