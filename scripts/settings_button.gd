extends Button

func _ready():
	pressed.connect(_go_to_settings)

func _go_to_settings():
	SwipeDetector.swipe_areas = []
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
