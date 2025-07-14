extends Area2D

@export_enum("house_interior", "house_exterior") var location_door: String

var player_inside := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_inside = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_inside = false

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("Clique_Esquerdo"):
		match location_door:
			"house_interior":
				get_tree().change_scene_to_file("res://scenes/objects/house_interior.tscn")
				print ("troquei")
			"house_exterior":
				print ("troquei")
				get_tree().change_scene_to_file("res://scenes/forest.tscn")
