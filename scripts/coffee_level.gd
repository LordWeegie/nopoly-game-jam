extends Node3D

@export var spawns : Array[Node3D]
@export var enemy_scene : PackedScene
var last_spawn : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start(5.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Timer.time_left < 0.1:
		var random_spawn = spawns.pick_random()
		if last_spawn:
			while random_spawn == last_spawn:
				random_spawn = spawns.pick_random()
		print("test")
		var enemy = enemy_scene.instantiate()
		$Enemys.add_child(enemy)
		enemy.global_position = random_spawn.global_position
		$Timer.start(5.0)
		print(enemy)
		last_spawn = random_spawn



func _on_coffee_touched_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.health -= 20
		body.global_position = $player_spawn.global_position


func _on_coffee_touched_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().queue_free()
