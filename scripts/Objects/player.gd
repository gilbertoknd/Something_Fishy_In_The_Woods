extends CharacterBody2D

var SPEED := 100
var current_dir := "down"
var current_action := "none"
var is_fishing := false
var can_move := true

@onready var fishOnHand := $FishOnHand
@onready var sprite := $AnimatedSprite2D

func _ready():
	fishOnHand.visible = false  # Esconde o peixe ao iniciar

func _physics_process(delta):
	var input_vec := Vector2.ZERO
	if not current_action in ["posing", "fishing", "sleeping"]:
		can_move=true
	if can_move:
		if Input.is_action_pressed("Move_right"):
			current_dir = "right"
			current_action ="moving"
			input_vec.x += 1
		if Input.is_action_pressed("Move_left"):
			current_dir = "left"
			current_action ="moving"
			input_vec.x -= 1
		if Input.is_action_pressed("Move_down"):
			current_dir = "down"
			current_action ="moving"
			input_vec.y += 1
		if Input.is_action_pressed("Move_up"):
			current_dir = "up"
			current_action ="moving"
			input_vec.y -= 1
		if Input.is_action_pressed("Run"):
			SPEED = 170
		else:
			SPEED = 100
		
	if Global.last_caught_fish !=null:
		if Input.is_action_pressed("Pose"):
			current_action="posing"

	if Input.is_action_just_released("Pose"):
		current_action="none"

	if input_vec != Vector2.ZERO:
		current_action = "moving"
		input_vec = input_vec.normalized()
		velocity = input_vec * SPEED
	else:
		velocity = Vector2.ZERO
		if not current_action in ["posing", "fishing", "sleeping"]:
			current_action = "none"

	move_and_slide()
	play_animation()

	# mostra o peixe só quando estiver posando
	fishOnHand.visible = current_action == "posing"

func play_animation():
	if not can_move:
		sprite.flip_h = false
		
	if current_action =="posing":
		can_move=false
		sprite.play("show_pose")
		
	if current_action =="moving":
		match current_dir:
			"right":
				sprite.flip_h = false
				sprite.play("walk")
			"left":
				sprite.flip_h = true
				sprite.play("walk")
			"up", "down":
				sprite.play("walk")
	if current_action=="none":
		sprite.play("Idle_front")
