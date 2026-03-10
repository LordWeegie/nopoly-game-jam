extends Node2D


@export var is_visible = false
@export var animation_playing : bool = false
@export var animation_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = is_visible
	if animation_playing:
		is_visible = true
		$AnimatedSprite2D.play("loading")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.stop()
		animation_playing = false
		animation_finished = true
		is_visible = false
