extends Control

@onready var label_day = $VBoxContainer/CenterContainerDay/DayLabel
@onready var label_time = $VBoxContainer/CenterContainerTime/TimeLabel
@onready var wheel = $CycleWheel  # Atualize com o caminho correto
@onready var label_points = $IdeaPoints

func _process(delta: float) -> void:
	label_points.text = "Pontos: %d" % Global.player_points
	
func _on_day_night_cycle_time_tick(day: int, hour: int, minute: int) -> void:
	label_day.text = "Dia %d" % day

	var is_pm := hour >= 12
	var display_hour := hour % 12
	if display_hour == 0: display_hour = 12
	label_time.text = " %02d:%02d %s" % [display_hour, minute, "pm" if is_pm else "am"]


	# Roda o "relógio" gráfico
	var total_minutes = (hour % 24) * 60 + minute
	var angle = (total_minutes / 1440.0) * TAU  # 1440 minutos em um dia
	wheel.rotation = angle
