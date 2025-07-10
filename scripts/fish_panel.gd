extends Panel

@onready var fish_logo = $FishLogo
@onready var fish_infos = $FishInfos

func _ready():
	var fish_id = Global.selected_fish
	if fish_id == "":
		return

	var fish = FishDatabase.DATA[fish_id]

	fish_logo.texture = fish["sprite"]

	fish_infos.bbcode_enabled = true
	fish_infos.text = "[center]Nome: %s,\nRaridade: %s,\nDescrição: %s[/center]" % [fish["name"], fish["raridade"], fish["description"]]
	
