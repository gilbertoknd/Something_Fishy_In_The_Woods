extends Area2D

func _ready():
	# Se o jogador já tem a habilidade de pescar, remove a vara da cena
	if Global.player and Global.player.can_fish:
		queue_free()
	else:
		connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body == Global.player:
		Global.can_fish = true
		queue_free()
