extends Node2D
class_name FishOnHand

@onready var sprite = $Sprite2D
var fish_instance: FishInstance

func _ready() -> void:
	# Pegar o último peixe do Global
	if Global.last_caught_fish != null:
		sprite.visible = true
		set_fish(Global.last_caught_fish)
	else:
		# Deixa o sprite invisível se não tiver peixe
		sprite.visible = false

func set_fish(fish: FishInstance) -> void:
	fish_instance = fish
	sprite.texture = fish.get_fish_sprite()
	
	var scale_factor = max(0.5, round(fish.get_fish_weight() / 2))
	sprite.scale = Vector2.ONE * scale_factor
	sprite.visible = true  # Garante que fique visível se for usado depois
