extends Node2D
class_name SFX

@onready
var swipe_sound:= $SwipeSound
@onready
var randomize_sound:= $RandomizeSound

func _ready():
	Global.sfx = self
