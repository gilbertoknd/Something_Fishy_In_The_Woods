extends CanvasModulate
	
const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day:int, hour:int, minute:int)

@export var gradient:GradientTexture1D
@export var day_speed = 1
@export var inital_hour = 6

var time:float = 0.0

func _ready() -> void:
	set_process(true)
	time = INGAME_TO_REAL_MINUTE_DURATION * inital_hour * MINUTES_PER_HOUR
	
func _process(delta: float) -> void:
	time += (delta * day_speed *INGAME_TO_REAL_MINUTE_DURATION)
	var value = (sin(time - PI / 2) + 1.0) / 2.0 #Funcao para o loop do dia e noite
	self.color = gradient.gradient.sample(value)
	
	_recalculate_time()
	
func _recalculate_time() -> void:
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	
	var day = int(total_minutes / MINUTES_PER_DAY)
	
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	time_tick.emit(day, hour, minute) #Emite sinal de mudança do tempo, para o UI
	
