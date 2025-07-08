# FishInstance.gd
class_name FishInstance
extends Resource

var fish_id: String
var weight: float
@export_range(1, 6) var quality: int = 1
var price: float

#construtor
func _init(_fish_id: String = "", peso: float = 0.0, qualidade: int = 0):
	if _fish_id == "":
		# construtor padrão aleatório
		var keys = FishDatabase.DATA.keys()
		fish_id = keys[randi() % keys.size()]  # peixe aleatório do banco
		weight = randf_range(0.5, 3.0)         # peso aleatório, ajuste os valores conforme desejar
		quality = randi() % 6 + 1              # qualidade aleatória entre 1 e 6
	else:
		fish_id = _fish_id
		weight = peso
		quality = qualidade
		
	price = calculate_price(peso,qualidade)


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
func calculate_price(weight: float, quality: int) -> float:
	var valor= weight * quality + weight / randf_range(2.0, 5.0)
	var arredondado = round(valor * 100) / 100.0 #pra ficar só com duas casas decimais
	return arredondado
