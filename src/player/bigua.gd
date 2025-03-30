extends CharacterBody2D
class_name PlayerBigua


@onready var sm = $States
@onready var sprite = $sprite_water
@onready var breath_timer = $BreathTimer

# DEBUG
@export var DEBUG := true
@onready var posLabel = $Debug/pos

# Inputs
@export var input_accept := 'Z'
@export var input_cancel := 'X'
@export var input_start := 'start'

# Movement
@export var SPEED = 150.0
@export var ROTATION_SPEED = 0.15
@export var FRICTION = 25
@export var ACCEL = 200
@export var BREATH_DRAIN_RATE = 10


var input_map = {
	Z = false,
	X = false,
	start = false
}

var inputs = {
	dirv = Vector2.ZERO,
	pressed = input_map.duplicate(),
	just_pressed = input_map.duplicate(),
	just_released = input_map.duplicate()
}

const CHARGE_MAX = 100
const CHARGE_MIN = 10
const CHARGE_LOAD_SECONDS = 1
var charge_power = 0.0

var water_top_pos_y = 0.0

var combo_fish_caught = []

@export var MAX_STAMINA = 10000
@export var stamina = 2500

var is_underwater = false

func _ready():
	sm.init(self)
	$Debug.visible = DEBUG
	
	water_top_pos_y = self.global_position.y


var run = true
func _physics_process(delta):
	if run:
		update_inputs()
		sm.run(delta)
		_drain_stamina(delta)
		move_and_slide()
		
		if stamina <= 0:
			die()
	if DEBUG:
		$Debug/pos.set_text(str(self.get_real_velocity()))
		$Debug/state.set_text(self.sm.state_curr)
		$Debug/charge.set_text(str(self.charge_power))

func die():
	sm.end_current_state("Lose")
	run = false
	get_tree().reload_current_scene()

func _drain_stamina(delta):
	if is_underwater:
		if breath_timer.is_stopped():
			stamina = (stamina - (BREATH_DRAIN_RATE * 10) * delta)
		else:
			stamina = (stamina - BREATH_DRAIN_RATE * delta)
	stamina = (stamina - 1 * delta)
	

func consume_fishes():
	$sfx/catch.pitch_scale = 1.0
	var total_stamina = 0
	for fish in combo_fish_caught:
		print_debug('caught fish! ', fish.name)
		total_stamina += fish.stamina
	stamina += total_stamina + (total_stamina * (combo_fish_caught.size() - 1)) / 4
	combo_fish_caught = []


var run_input = true
func update_inputs():
	if run_input:
		inputs.dirv = Input.get_vector("left", "right", "up", "down")
		
		for i_p in inputs.pressed:
			inputs.pressed[i_p] = Input.is_action_pressed(i_p)
			
		for i_jp in inputs.just_pressed:
			inputs.just_pressed[i_jp] = Input.is_action_just_pressed(i_jp)
			
		for i_jr in inputs.just_released:
			inputs.just_released[i_jr] = Input.is_action_just_released(i_jr)


func get_input(input_name: String, state_name: String = 'just_pressed'):
	if input_name == 'dirv':
		return inputs[input_name]
	return inputs[state_name][input_name]


func _on_bico_body_entered(body):
	if body is BaseFish:
		if body.data.size_class == "Trash":
			sm.end_current_state("Stun")
			stamina += body.data.stamina
			combo_fish_caught.clear()
		else:
			combo_fish_caught.append(body.data)
			$sfx/catch.pitch_scale = lerpf( \
				$sfx/catch.pitch_scale, 1.5, 0.1 \
			)
			play_sfx("catch")
		body.call_deferred("despawn")


func play_sfx(_sfx_name: String):
	var sfx = get_node_or_null("sfx/" + _sfx_name)
	sfx.play(0.0)
