# FishInstance.gd
class_name FishInstance
extends Resource
const FishDatabase = preload("res://scripts/Globals/FishDatabase.gd")

var fish_id: String
var weight: float
@export_range(1, 6) var quality: int = 1
var price: float

#construtor
func _init(_fish_id: String = "", peso: float = 0.0, qualidade: int = 0):
	if _fish_id == "":
		# construtor padrão aleatório
		fish_id = get_random_fish_id()  # peixe aleatório do banco
		weight = randf_range(0.5, 3.0)         # peso aleatório, ajuste os valores conforme desejar
		quality = randi() % 6 + 1              # qualidade aleatória entre 1 e 6
	else:
		fish_id = _fish_id
		weight = peso
		quality = qualidade
		
	price = calculate_price(peso, qualidade)



# Gets and sets
func get_fish_name():
	return FishDatabase.DATA[fish_id]["name"]

func get_fish_sprite():
	return FishDatabase.DATA[fish_id]["sprite"]

func get_fish_description():
	return FishDatabase.DATA[fish_id]["description"]
	
func get_fish_weight():
	return self.weight

func set_fish_weight(peso: float) -> void:
	self.weight = peso
	
func set_fish_quality(qualidade: int)->void:
	if qualidade>6:qualidade=6
	if qualidade<1:qualidade=1
	self.quality=qualidade

#calcular preço
func calculate_price(peso: float, qualidade: int) -> float:
	var base_value = FishDatabase.DATA[fish_id].get("base_price", 2.5)
	var rarity_multiplier = get_rarity_multiplier(fish_id)
	var valor = peso * qualidade * rarity_multiplier * base_value
	var arredondado = round(valor * 100) / 100.0
	return arredondado

	
static func get_random_fish_id() -> String:
	var total_weight = 0
	for fish in FishDatabase.DATA.values():
		total_weight += fish["spawn_weight"]

	var rand = randi() % int(total_weight)
	var cumulative = 0

	for key in FishDatabase.DATA.keys():
		cumulative += FishDatabase.DATA[key]["spawn_weight"]
		if rand < cumulative:
			return key
	
	return FishDatabase.DATA.keys()[0] # fallback


static func get_rarity_multiplier(fish_id: String) -> float:
	var raridade = FishDatabase.DATA[fish_id]["raridade"]

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
