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
const CHARGE_LOAD_SECONDS = 2
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
	if DEBUG:
		$Debug/pos.set_text(str(self.get_real_velocity()))
		$Debug/state.set_text(self.sm.state_curr)
		$Debug/charge.set_text(str(self.charge_power))


func _drain_stamina(delta):
	if is_underwater:
		if breath_timer.is_stopped():
			stamina = (stamina - (BREATH_DRAIN_RATE * 10) * delta)
		else:
			stamina = (stamina - BREATH_DRAIN_RATE * delta)
	stamina = (stamina - 1 * delta)


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
			combo_fish_caught.clear()
		else:
			combo_fish_caught.append(body.data)
		body.call_deferred("despawn")
