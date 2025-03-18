extends Node

enum BODYPART {HEAD, TORSO, LEGS}

const TEXTURES: Dictionary = {
	BODYPART.HEAD: [
		preload("res://assets/heads/Head1.png"),
		preload("res://assets/heads/Head2.png"),
		preload("res://assets/heads/Head3.png"),
		preload("res://assets/heads/Head4.png"),
		preload("res://assets/heads/Head5.png")
	],
	BODYPART.TORSO: [
		preload("res://assets/torsos/Torso1.png"),
		preload("res://assets/torsos/Torso2.png"),
		preload("res://assets/torsos/Torso3.png"),
		preload("res://assets/torsos/Torso4.png"),
		preload("res://assets/torsos/Torso5.png")
	],
	BODYPART.LEGS: [
		preload("res://assets/legs/Legs1.png"),
		preload("res://assets/legs/Legs2.png"),
		preload("res://assets/legs/Legs3.png"),
		preload("res://assets/legs/Legs4.png"),
		preload("res://assets/legs/Legs5.png")
	]
}

const REGIONS: Dictionary = {
	BODYPART.HEAD: Rect2(0, 98, 720, 312),
	BODYPART.TORSO: Rect2(0, 80, 720, 350),
	BODYPART.LEGS: Rect2(0, 82, 720, 345)
	}

var indexes: Dictionary = {
	BODYPART.HEAD: randi_range(0,4),
	BODYPART.TORSO: randi_range(0,4),
	BODYPART.LEGS: randi_range(0,4),
	}

var swipe_enabled = true

var sfx: SFX
var sound_enabled: bool = true

var background_color: Color = Color.WHITE
var color: Color = Color.BLACK
