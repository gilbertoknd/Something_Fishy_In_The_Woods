extends CharacterBody2D

var SPEED := 100
var current_dir := "down"
var current_action := "none"
var is_fishing := false
var can_move := true


@onready var fishOnHand := $FishOnHand
@onready var sprite := $AnimatedSprite2D
@onready var Arrows := $Arrows
@onready var water_checker := $CollisionChecker
@onready var codex_scene = preload("res://scenes/interface/codex.tscn")
@onready var codex_instance: Node = null 

func _ready():
	Global.player=self
	Arrows.visible= false
	fishOnHand.visible = false  # Esconde o peixe ao iniciar
	
func _physics_process(delta):
	var input_vec := Vector2.ZERO
	if not current_action in ["posing","in_fish_minigame", "sleeping"]:
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
	
	if Input.is_action_just_pressed("Clique_Esquerdo") and not current_action in ["fish_on_bait","in_fish_minigame"]and is_over_water():
		is_fishing=true
		current_action="fishing"
		
	if Input.is_action_just_pressed("Codex"):
		if codex_instance == null:
			codex_instance = codex_scene.instantiate()
			$InterfaceLayer.add_child(codex_instance)
		else:
			codex_instance.visible = not codex_instance.visible
		
	if not current_action in ["fish_on_bait","in_fish_minigame", "fishing"]:
		is_fishing = false
		
	if input_vec != Vector2.ZERO:
		current_action = "moving"
		input_vec = input_vec.normalized()
		velocity = input_vec * SPEED
	else:
		velocity = Vector2.ZERO
		if not current_action in ["posing","fish_on_bait","in_fish_minigame", "fishing", "sleeping"]:
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
		
	if current_action =="fishing":
		can_move=false
		sprite.play("Idle_fishing")
	
	if current_action =="fish_on_bait":
		can_move=false
		sprite.play("alert_fishing")
		
	if current_action =="in_fish_minigame":
		can_move=false
		sprite.play("pull_fishing")
	
	
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
		
func get_current_action()->String:
	return current_action

func is_over_water() -> bool:
	var areas = water_checker.get_overlapping_areas()
	if areas!=null:
		for area in areas:
			if area.is_in_group("WaterBody"):
				return true
	print("tem nem água zé")
	return false
