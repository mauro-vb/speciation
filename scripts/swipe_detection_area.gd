extends Area2D
class_name SwipeDetectionArea

@export var body_part: Global.BODYPART
@export var node_to_swipe: BodyPartSprite

func _ready():
	SwipeDetector.swipe_areas.append(self)
	var collision_shape: CollisionShape2D = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Global.REGIONS[body_part].size
	add_child(collision_shape)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	SwipeDetector.swipe_area = self
	
func _on_mouse_exited():
	SwipeDetector.start_pos = get_global_mouse_position()
	node_to_swipe.reposition()
