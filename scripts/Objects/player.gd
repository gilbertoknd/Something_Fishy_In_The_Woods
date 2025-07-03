extends CharacterBody2D

var SPEED := 100
var current_dir := "down"
var is_moving := false
var can_move :=true

@onready var sprite := $AnimatedSprite2D

func _physics_process(delta):
	var input_vec := Vector2.ZERO
	is_moving = false
	if(can_move ==true):
		if Input.is_action_pressed("Move_right"):
			current_dir = "right";  input_vec.x += 1
		if Input.is_action_pressed("Move_left"):
			current_dir = "left";   input_vec.x -= 1
		if Input.is_action_pressed("Move_down"):
			current_dir = "down";   input_vec.y += 1
		if Input.is_action_pressed("Move_up"):
			current_dir = "up";     input_vec.y -= 1
		if Input.is_action_pressed("Run"):
			SPEED = 170
		else:
			SPEED = 100

	if input_vec != Vector2.ZERO:
		is_moving = true
		input_vec = input_vec.normalized()
		velocity = input_vec * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	play_animation()

func play_animation():
	if (can_move!=true):
		sprite.flip_h = false
	if is_moving:
		if current_dir == "right":
			sprite.flip_h = false
			sprite.play("walk")
		elif current_dir == "left":
			sprite.flip_h = true
			sprite.play("walk")
		elif current_dir == "up":
			sprite.play("walk")
		elif current_dir == "down":
			sprite.play("walk")
	else:
			sprite.play("Idle_front")
