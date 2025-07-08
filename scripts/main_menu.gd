extends Control


func _on_iniciar_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn")


func _on_config_button_button_up() -> void:
	#get_tree().change_scene_to_file("res://Scenes/config") 
	pass


func _on_sair_button_button_up() -> void:
	get_tree().quit()
