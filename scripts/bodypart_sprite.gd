extends Sprite2D
class_name BodyPartSprite

@export 
var body_part: Global.BODYPART
var starting_pos: Vector2
var left_origin_pos: Vector2
var right_origin_pos: Vector2

var textures: Array 

func _ready():
	material = ShaderMaterial.new()
	material.shader = load("res://grid_ripple.gdshader")
	textures = Global.TEXTURES[body_part]
	starting_pos = global_position
	left_origin_pos = starting_pos + Vector2(-720,0)
	right_origin_pos = starting_pos + Vector2(720,0)
	region_enabled = true
	texture = textures[Global.indexes[body_part]]
	region_rect = Global.REGIONS[body_part]
	
	
func reposition():
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", starting_pos, .15).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)

func change_texture(swipe_dir: int):
	Global.indexes[body_part] = (Global.indexes[body_part] + 1) % textures.size() if swipe_dir == 1 else (Global.indexes[body_part] - 1 + textures.size()) % textures.size()
	texture = textures[Global.indexes[body_part]]
	global_position = left_origin_pos if swipe_dir == 1 else right_origin_pos

	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", starting_pos, 0.15).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(play_swipe_sound)
	
func randomize_texture():
	var tween: Tween = create_tween()
	material.set_shader_parameter("angle", randf_range(-180,180))
	tween.tween_method(change_ripple_value, 0.0, 0.5, .5).set_ease(Tween.EASE_OUT)
	tween.tween_callback(change_random_texture)
	tween.tween_callback(play_random_sound)
	tween.tween_method(change_ripple_value, .5, 1.0, .5).set_ease(Tween.EASE_OUT)

func change_random_texture():
	var possible_textures: Array = textures.duplicate()
	possible_textures.remove_at(Global.indexes[body_part])
	texture = possible_textures[randi_range(0,3)]
	Global.indexes[body_part] = textures.find(texture)

func change_ripple_value(value:float):
	material.set_shader_parameter("progress", value)
	
func play_swipe_sound():
	if Global.sound_enabled:
		Global.sfx.swipe_sound.play()

func play_random_sound():
	if !Global.sfx.randomize_sound.playing and Global.sound_enabled:
		Global.sfx.randomize_sound.play()
