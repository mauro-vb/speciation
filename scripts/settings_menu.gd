extends Node2D

@onready var sound_button: Button = $CanvasGroup/VBoxContainer/HBoxContainer2/SoundButton
@onready var back_button: Button = $CanvasGroup/VBoxContainer/HBoxContainer2/BackButton

@onready var background_color_button: Button = $CanvasGroup/VBoxContainer/HBoxContainer/BackgroundColor
@onready var color_button: Button = $CanvasGroup/VBoxContainer/HBoxContainer/Color
@onready var canvas_group: MyCanvasGroup = $CanvasGroup
@onready var sound_player: AudioStreamPlayer2D = $SelectSound

var on_texture: Texture = preload("res://assets/ui/sound_button.png")
var off_texture: Texture = preload("res://assets/ui/sound_button_off.png")

func _ready():
	Global.swipe_enabled = false
	sound_button.pressed.connect(_toggle_sound)
	sound_button.icon = on_texture if Global.sound_enabled else off_texture
	
	back_button.pressed.connect(change_to_main)
	
	color_button.pressed.connect(change_color)
	background_color_button.pressed.connect(change_background_color)

func _toggle_sound():
	Global.sound_enabled = !Global.sound_enabled
	sound_button.icon = on_texture if Global.sound_enabled else off_texture
	play_sound()
	
func change_to_main():
	Global.swipe_enabled = true
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func change_color():
	play_sound()
	Global.color = get_random_color(false)
	canvas_group.change_colors()

func change_background_color():
	play_sound()
	Global.background_color = get_random_color(true)
	canvas_group.change_colors()

func play_sound():
	if Global.sound_enabled:
		sound_player.play()
		
func get_random_color(is_light: bool):
	var h = randf()                           # Random hue from 0 to 1
	var s = randf_range(0.0, 0.7)               # Low saturation for near-neutral colors
	var l = randf_range(0.9, 1.0)  if is_light else randf_range(0.0, 0.3)     # Dark colors: lightness near black
	return Color.from_ok_hsl(h, s, l, 1)
