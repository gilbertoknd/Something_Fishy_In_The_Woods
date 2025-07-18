const DATA = {
	"BAGRE": {
		"name": "Bagre",
		"raridade": "Normal ★", 
		"spawn_weight": 60,
		"base_price": 8,
		"sprite": preload("res://assets/Sprites/fishs/BAGRE.png"),
		"description": "Peixe de fundo com bigodes distintos."
	},
	"SALMAO": {
		"name": "Salmão",
		"raridade": "Normal ★", 
		"base_price": 10,
		"spawn_weight": 60,
		"sprite": preload("res://assets/Sprites/fishs/SALMON.png"),
		"description": "Peixe migratório encontrado em águas frias."
	},
	"TRUTA": {
		"name": "Truta",
		"raridade": "Normal ★", 
		"base_price": 20,
		"spawn_weight": 60,
		"sprite": preload("res://assets/Sprites/fishs/TRUTA.png"),
		"description": "Peixe colorido comum em agua doce."
	},
	"ATHANASIOS": {
		"name": "Athanasios",
		"raridade": "Histórico ★★★★★★", 
		"base_price": 999,
		"spawn_weight": 10,
		"sprite": preload("res://assets/Sprites/fishs/thanos.png"),
		"description": "Esse peixe dá aula de fundamentos de matemática para a computação e ainda joga basquete."
	}
}


static func get_rarity_multiplier(fish_id: String) -> float:
	var raridade = DATA[fish_id]["raridade"]

	match raridade:
		"Normal ★":
			return 1.0
		"Incomum ★★":
			return 2.0
		"Raro ★★★":
			return 3.0
		"Épico ★★★★":
			return 4.0
		"Lendário ★★★★":
			return 4.0
		"Histórico ★★★★★★":
			return 6.0
		_:
			return 1.0
