extends CharacterBody3D

@onready var player : CharacterBody3D = $"../../player"
var player_found = false

@export var speed = 2
@export var gravity : float = 9.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	look_at(player.global_position)
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player_found:
		var direction = (player.global_position - global_position).normalized()
		
		# Move towards player
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	move_and_slide()
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.health -= 30
		await get_tree().create_timer(2).timeout


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_found = true
