extends Node3D

@export var spawns : Array[Node3D]
@export var enemy_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(5.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Timer.time_left < 0.1:
		print("test")
		var enemy = enemy_scene.instantiate()
		$Enemys.add_child(enemy)
		enemy.global_position = spawns.pick_random().global_position
		$Timer.start(5.0)
		print(enemy)



func _on_coffee_touched_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()


func _on_coffee_touched_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().queue_free()
