extends Node2D
class_name Swipe

var swipe_area: SwipeDetectionArea
var swipe_areas: Array[SwipeDetectionArea]

var start_pos: Vector2
var original_node_pos: Vector2
var swiping: bool = false
var current_pos: Vector2

@onready var swipe_timer: Timer = $SwipeTimer
var length: float = 100
var threshold: float = 50

@onready var double_tap_timer: Timer = $DoubleTapTimer
var taps: int = 0

func _ready():
	double_tap_timer.timeout.connect(_reset_taps)

func _input(event: InputEvent) -> void:
	if !Global.swipe_enabled:
		return
	if event.is_action_pressed("press"):
		swipe_timer.start()
		double_tap_timer.start()
		start_pos = get_global_mouse_position()
		if swipe_area != null:
			original_node_pos = swipe_area.node_to_swipe.global_position
		swiping = true
	
	elif event.is_action_released("press"):
		if double_tap_timer.time_left > 0:
			taps+=1
			double_tap_timer.stop()
			double_tap_timer.start()
			
		current_pos = get_global_mouse_position()
		
		if start_pos.distance_to(current_pos) >= length:
			if abs(start_pos.x - current_pos.x) >= threshold and swipe_timer.time_left > 0:
				swipe_area.node_to_swipe.change_texture(sign(current_pos.x - start_pos.x))
			else:
				swipe_area.node_to_swipe.reposition()
		swiping = false

func _process(_delta: float) -> void:
	if swiping:
		current_pos = get_global_mouse_position()
		var offset = current_pos - start_pos
		swipe_area.node_to_swipe.global_position.x = original_node_pos.x + (offset.x / 3)
		
func _reset_taps():
	if taps == 2:
		swipe_area.node_to_swipe.randomize_texture()
	elif taps == 3:
		for area in swipe_areas:
			area.node_to_swipe.randomize_texture()
	taps = 0 
