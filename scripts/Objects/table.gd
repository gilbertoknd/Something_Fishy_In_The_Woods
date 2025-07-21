extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

func _ready():
	if Global.table_fixed:
		sprite.play("normal")
		label.visible = false
	else:
		sprite.play("broken")
		label.visible = true
		label.text = "Consertar (1000 pontos)"

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Clique_Esquerdo"):
		if Global.table_fixed:
			return

		if Global.player_points >= 1000:
			Global.player_points -= 1000
			Global.table_fixed = true
			sprite.play("normal")
			label.visible = false
		else:
			await show_insufficient_points()

func show_insufficient_points():
	var original_text = label.text
	label.text = "Pontos insuficientes"
	label.visible = true
	await get_tree().create_timer(1.0).timeout
	label.text = original_text
