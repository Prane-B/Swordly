extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -325.0

@onready var animatedsprite = $AnimatedSprite2D
@onready var animater = $CollisionShape2D/AnimationPlayer
@onready var sound = $AudioStreamPlayer2D

var is_attacking = false
var level  = 1
var lives = randi_range(3,7)
var dead = 1

func _physics_process(delta: float) -> void:
	if lives == 0:
		get_tree().call_deferred("reload_current_scene") 
	if Input.is_action_just_pressed("attack") and animatedsprite.animation != "attack":
		sound.play()
		lives -= 1
		animater.play("battack")
		is_attacking = true
		animatedsprite.play("attack")	
		
	if is_attacking:
		if not is_on_floor():
			velocity += get_gravity() * delta
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return
	print(animatedsprite.animation)
	# Handle gravity if in the air
	if not is_on_floor():
		velocity += get_gravity() * delta
		# Play jump animation if not already jumping
		if animatedsprite.animation != "jump":
			animatedsprite.play("jump")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		animatedsprite.play("jump")
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		animatedsprite.flip_h = false
	elif direction < 0:
		animatedsprite.flip_h = true

	if direction:
		# Play run animation only if on the floor and moving horizontally
		if is_on_floor() and animatedsprite.animation != "run":
			animatedsprite.play("run")
		velocity.x = direction * SPEED
	elif not is_on_floor():
		# Keep the jump animation if in the air
		if animatedsprite.animation != "jump":
			animatedsprite.play("jump")
	else:
		# Decelerate to a stop
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if animatedsprite.animation != "default":
			animatedsprite.play("default")
	
	# Apply the movement
	move_and_slide()
		



func _on_animated_sprite_2d_animation_finished() -> void:
	if animatedsprite.animation == "attack":
		animater.play("RESET")
		is_attacking = false
