extends TextureRect

var time := 0.0

# Ajustes
var amplitude := 5.0       # Movimento em pixels
var rotation_max := 6.0    # Em graus
var speed := 1.0           # Velocidade da oscilação

func _process(delta):
	time += delta * speed

	# Movimento suave com seno e cosseno
	var offset_x = sin(time) * amplitude
	var offset_y = cos(time * 0.5) * amplitude * 0.5

	# Aplica o movimento
	position = Vector2(534.0, 111.0) + Vector2(offset_x, offset_y)

	# Aplica a rotação
	rotation = deg_to_rad(sin(time) * rotation_max)

	# Aplica a escala (pulsação)
	var scale_factor = 1.0 + sin(time * 1.5) * 0.1  # 10% de variação
	scale = Vector2(scale_factor, scale_factor)
