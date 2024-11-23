extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@onready var animatedsprite = $AnimatedSprite2D
@onready var animater = $CollisionShape2D/AnimationPlayer

var is_attacking = false

func _physics_process(delta: float) -> void:
	if is_attacking:
		return

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
	elif Input.is_action_just_pressed("attack") and animatedsprite.animation != "attack":
		animater.play("battack")
		is_attacking = true
		animatedsprite.play("attack")
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
		is_attacking = false
		animater.play("RESET")
