extends Button

var hover_scale := Vector2(1.1, 1.1)  # 10% maior
var normal_scale := Vector2(1.0, 1.0)
var scaling_speed := 8.0  # Quão rápido ele escala

var target_scale := Vector2(1.0, 1.0)

func _ready():
	scale = normal_scale
	target_scale = normal_scale
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	target_scale = hover_scale

func _on_mouse_exited():
	target_scale = normal_scale

func _process(delta):
	# Faz a transição suave para a escala desejada
	scale = scale.lerp(target_scale, delta * scaling_speed)
