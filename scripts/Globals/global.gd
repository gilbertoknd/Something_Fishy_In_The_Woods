extends Node

var player: CharacterBody2D = null
var player_points: int = 0
var current_fish_on_bait: FishInstance
var last_caught_fish := FishInstance.new()
var caught_fish: Array = []

# Estados e timers
var fishing_timer := 0.0
var fishing_time_limit := 0.0
var waiting_fish_alert := false
var minigame_active := false
var reaction_timer := 0.0
var reaction_timeout := 4.0
var current_clicks := 0
var required_clicks := 0
var expected_arrow := ""
var arrow_sprites := ["up", "down", "left", "right"]

func _process(delta):
	if player == null:
		return

	match player.get_current_action():
		"fishing":
			if not waiting_fish_alert:
				fishing_time_limit = randf_range(1, 4)
				fishing_timer = 0.0
				waiting_fish_alert = true
				print("Pescando... peixe pode morder em %.2f segundos" % fishing_time_limit)
			else:
				fishing_timer += delta
				if fishing_timer >= fishing_time_limit:
					trigger_fish_on_bait()

		"fish_on_bait":
			if Input.is_action_pressed("Clique_Esquerdo"):
				start_minigame()


		"in_fish_minigame":
			handle_minigame(delta)
			
func trigger_fish_on_bait():
	waiting_fish_alert = false
	player.current_action = "fish_on_bait"
	var quality = randi_range(1, 6)
	var weight = randf_range(0.5, 6.5)
	var keys = FishDatabase.DATA.keys()
	var fish_id = keys[randi() % keys.size()] 
	current_fish_on_bait = FishInstance.new(fish_id, weight, quality)
	required_clicks = quality * 2
	print("Peixe mordendo! Qualidade: %d | Clique para iniciar minigame" % quality)

func start_minigame():
	print("minigame começou") # DEBUG
	player.current_action = "in_fish_minigame"
	minigame_active = true
	current_clicks = 0
	reaction_timer = 0.0
	next_arrow()

func next_arrow():
	reaction_timer = 0.0
	expected_arrow = arrow_sprites[randi() % arrow_sprites.size()]
	print("Seta sorteada: ", expected_arrow)

	# Atualiza o sprite do jogador
	var arrow_sprite = player.get_node("Arrows") as AnimatedSprite2D
	arrow_sprite.visible = true
	arrow_sprite.scale = Vector2(1, 1)  # Reset escala inicial

	match expected_arrow:
		"up":
			arrow_sprite.frame = 0
		"down":
			arrow_sprite.frame = 1
		"left":
			arrow_sprite.frame = 2
		"right":
			arrow_sprite.frame = 3


func handle_minigame(delta):
	if not minigame_active:
		return

	reaction_timer += delta

	# Reduz escala ao longo do tempo
	var arrow_sprite = player.get_node("Arrows") as AnimatedSprite2D
	var t = reaction_timer / reaction_timeout
	arrow_sprite.scale = Vector2(1 - 0.7 * t, 1 - 0.7 * t)

	if reaction_timer > reaction_timeout:
		print("Tempo esgotado! Perdeu o peixe.")
		end_minigame(false)
		return

	if Input.is_action_just_pressed(expected_arrow):
		current_clicks += 1
		print("Acertou ", expected_arrow, "! [%d / %d]" % [current_clicks, required_clicks])
		if current_clicks >= required_clicks:
			end_minigame(true)
		else:
			next_arrow()

func end_minigame(success: bool):
	minigame_active = false
	player.current_action = "none"

	var arrow_sprite = player.get_node("Arrows") as AnimatedSprite2D
	arrow_sprite.visible = false

	if success:
		last_caught_fish = current_fish_on_bait
		caught_fish.append(last_caught_fish)
		player_points += last_caught_fish.price
		print("Pescou um peixe de R$ %.2f! Total de pontos: %d" % [last_caught_fish.price, player_points])
	else:
		print("O peixe escapou!")
