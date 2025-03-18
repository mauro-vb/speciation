extends CanvasGroup
class_name MyCanvasGroup

func _ready():
	change_colors()
	
func change_colors():
	material.set_shader_parameter("color", Global.color) 
	material.set_shader_parameter("background_color", Global.background_color) 
