extends StaticBody2D

@export var oven_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if oven_open:
		$AnimatedSprite2D.frame = 1
		
	else: $AnimatedSprite2D.frame = 0


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		oven_open = true


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		oven_open = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
