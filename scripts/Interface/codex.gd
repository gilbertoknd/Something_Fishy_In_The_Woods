extends Control

@onready var Hbox = $Panel/ScrollContainer/HBoxContainer
var fish_button_scene = preload("res://scenes/interface/fish_button.tscn")

func _ready():
	for fish_id in FishDatabase.DATA.keys():
		var fish_data = FishDatabase.DATA[fish_id]
		var button = fish_button_scene.instantiate()
		button.setup(fish_id, fish_data["sprite"])
		
		Hbox.add_child(button)
