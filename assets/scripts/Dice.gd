extends Sprite2D

@export var frame_width: int = 35
@export var frame_height: int = 35
@export var total_faces: int = 6
@export var spin_duration: float = 1.0
@export var spin_speed: float = 0.1
@onready var audio_player = $Roll_Sound

signal spin_started
signal spin_finished

var spin_timer: Timer
var spin_time_elapsed: float = 0.0
var spinning: bool = false
var FinalDice: int = 0

func _ready():
	region_enabled = true
	spin_timer = Timer.new()
	spin_timer.wait_time = spin_speed
	spin_timer.one_shot = false
	spin_timer.autostart = false
	add_child(spin_timer)
	spin_timer.timeout.connect(_spin_step)
	_set_random_face()

func start_spin():
	spin_time_elapsed = 0.0
	spinning = true
	spin_timer.start()
	audio_player.play()
	emit_signal("spin_started")

func _spin_step():
	if spin_time_elapsed < spin_duration:
		_set_random_face()
		spin_time_elapsed += spin_speed
	else:
		spin_timer.stop()
		spinning = false
		var final_face = randi() % total_faces
		FinalDice = final_face + 1
		region_rect = Rect2(final_face * frame_width, 0, frame_width, frame_height)
		emit_signal("spin_finished")

func _set_random_face():
	var face = randi() % total_faces
	region_rect = Rect2(face * frame_width, 0, frame_width, frame_height)

func set_paused(is_paused: bool):
	spin_timer.paused = is_paused
