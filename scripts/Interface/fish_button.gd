extends TextureButton

var fish_id: String = ""
var fish_panel: Node = null


func setup(id: String, icon: Texture, panel_ref: Node):
	fish_id = id
	self.texture_normal = icon
	set_custom_minimum_size(Vector2(78, 30))
	fish_panel = panel_ref
	
func _on_pressed() -> void:
	Global.selected_fish = fish_id
	fish_panel.update_content()
	#fish_panel.visible = true
		
	if fish_panel:
		fish_panel.update_content()
	else:
		print("FishPanel não encontrado!")
	
