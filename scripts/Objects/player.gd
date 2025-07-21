extends CharacterBody2D

var speed := 100
var current_dir := "down"
var current_action := "none"
var is_fishing := false
var can_move := true
var can_fish := Global.can_fish

@onready var fishOnHand := $FishOnHand
@onready var sprite := $AnimatedSprite2D
@onready var Arrows := $Arrows
@onready var water_checker := $CollisionChecker
@onready var codex_scene = preload("res://scenes/interface/codex.tscn")
@onready var codex_instance: Node = null
@onready var camera: Camera2D = $Camera2D

const ZOOM_MIN = 2.0
const ZOOM_MAX = 8.0
const ZOOM_STEP = 0.5

func _ready():
	Global.player = self
	Arrows.visible = false
	fishOnHand.visible = false

func _physics_process(delta):
	var input_vec := handle_input()
	velocity = input_vec.normalized() * speed if input_vec != Vector2.ZERO else Vector2.ZERO

	if input_vec == Vector2.ZERO and not current_action in ["posing", "fish_on_bait", "in_fish_minigame", "fishing", "sleeping"]:
		current_action = "none"

	move_and_slide()
	play_animation()
	fishOnHand.visible = current_action == "posing"

func handle_input() -> Vector2:
	var input_vec := Vector2.ZERO

	if not current_action in ["posing", "in_fish_minigame", "sleeping"]:
		can_move = true

	if can_move:
		if Input.is_action_pressed("Move_right"):
			current_dir = "right"
			input_vec.x += 1
		if Input.is_action_pressed("Move_left"):
			current_dir = "left"
			input_vec.x -= 1
		if Input.is_action_pressed("Move_down"):
			current_dir = "down"
			input_vec.y += 1
		if Input.is_action_pressed("Move_up"):
			current_dir = "up"
			input_vec.y -= 1

		current_action = "moving" if input_vec != Vector2.ZERO else current_action
		speed = 170 if Input.is_action_pressed("Run") else 100

	if can_fish:
		if Global.last_caught_fish != null:
			if Input.is_action_pressed("Pose") and not current_action in ["fish_on_bait", "in_fish_minigame"]:
				current_action = "posing"
		if Input.is_action_just_released("Pose") and not current_action in ["fish_on_bait", "in_fish_minigame", "fishing"]:
			current_action = "none"
		if Input.is_action_just_pressed("Clique_Esquerdo") and not current_action in ["fish_on_bait", "in_fish_minigame"] and is_over_water():
			is_fishing = true
			current_action = "fishing"
		if not current_action in ["fish_on_bait", "in_fish_minigame", "fishing"]:
			is_fishing = false
			
	if Input.is_action_just_pressed("Codex") and Global.table_fixed:
		if codex_instance == null:
			codex_instance = codex_scene.instantiate()
			$InterfaceLayer.add_child(codex_instance)
		else:
			if is_instance_valid(codex_instance):
				codex_instance.visible = not codex_instance.visible

	return input_vec

func play_animation():
	if not can_move:
		sprite.flip_h = false

	match current_action:
		"posing":
			can_move = false
			sprite.play("show_pose")
		"fishing":
			can_move = false
			sprite.play("Idle_fishing")
		"fish_on_bait":
			can_move = false
			sprite.play("alert_fishing")
		"in_fish_minigame":
			can_move = false
			sprite.play("pull_fishing")
		"moving":
			match current_dir:
				"right":
					sprite.flip_h = false
					sprite.play("walk" if can_fish else "walk_prerod")
				"left":
					sprite.flip_h = true
					sprite.play("walk" if can_fish else "walk_prerod")
				"up", "down":
					sprite.play("walk" if can_fish else "walk_prerod")
		"none":
			sprite.play("Idle_front" if can_fish else "idle_prerod")

func get_current_action() -> String:
	return current_action

func is_over_water() -> bool:
	for area in water_checker.get_overlapping_areas():
		if area.is_in_group("WaterBody"):
			return true
	print("tem nem água zé")
	return false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				zoom_camera(-ZOOM_STEP)
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom_camera(ZOOM_STEP)

func zoom_camera(delta_zoom: float):
	var new_zoom = camera.zoom + Vector2(delta_zoom, delta_zoom)
	new_zoom.x = clamp(new_zoom.x, ZOOM_MIN, ZOOM_MAX)
	new_zoom.y = clamp(new_zoom.y, ZOOM_MIN, ZOOM_MAX)
	camera.zoom = new_zoom
