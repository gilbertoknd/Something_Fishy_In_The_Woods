extends Control

@onready var label_day = $VBoxContainer/CenterContainerDay/DayLabel
@onready var label_time = $VBoxContainer/CenterContainerTime/TimeLabel

func _on_day_night_cycle_time_tick(day: int, hour: int, minute: int) -> void:
	label_day.text = "Dia %d" % day
	if hour > 12:
		label_time.text = " %02d:%02d pm" % [hour, minute]
	else:
		label_time.text = " %02d:%02d am" % [hour, minute]
