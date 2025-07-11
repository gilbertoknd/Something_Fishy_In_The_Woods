extends TextureButton

var fish_id: String = ""

func setup(id: String, icon: Texture):
	fish_id = id
	self.texture_normal = icon
	set_custom_minimum_size(Vector2(78, 30))
	
func _on_pressed() -> void:
	Global.selected_fish = fish_id
	var fish_panel = get_tree().current_scene.get_node("Panel/FishPanel")
	fish_panel.update_content()
	fish_panel.visible = true
	
