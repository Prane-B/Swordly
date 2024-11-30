extends CharacterBody2D

const SPEED = 60

var direction = 1
@onready var dry = $AnimationPlayer
@onready var playerd = $AnimatedSprite2D
@onready var ray_cast_right = $RayCast2D2
@onready var ray_cast_left = $RayCast2D
@onready var animated_sprite = $AnimatedSprite2D

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	
	position.x += direction * SPEED * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.is_attacking:
			dry.play("death")
			queue_free()
		else:
			get_tree().call_deferred("reload_current_scene") 
