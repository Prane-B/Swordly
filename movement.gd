extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -350.0

@onready var animatedsprite = $AnimatedSprite2D

var is_attacking = false

func _physics_process(delta: float) -> void:
	if is_attacking:
		return
	# Handle gravty if in the air
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		animatedsprite.play("jump")
		velocity.y = JUMP_VELOCITY

	# Handle attacking (only if not already attacking)
	elif Input.is_action_just_pressed("attack") and animatedsprite.animation != "attack":
		is_attacking = true
		animatedsprite.play("attack")

	# Handle movement and animation states (if not attacking)
	elif not is_on_floor():
		if animatedsprite.animation != "jump":
			animatedsprite.play("jump")
	else:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction > 0:
			animatedsprite.flip_h = false
		elif direction < 0:
			animatedsprite.flip_h = true

		if direction:
			if animatedsprite.animation != "run":
				animatedsprite.play("run")
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if animatedsprite.animation != "default":  
				animatedsprite.play("default")


	# Apply the movement
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animatedsprite.animation == "attack":
		is_attacking = false
