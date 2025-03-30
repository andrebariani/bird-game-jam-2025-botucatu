extends State

@export var SPEED = 150.0
@export var ROTATION_SPEED = 0.15
@export var FRICTION = 50
@export var ACCEL = 200

@onready var tween: Tween

func begin():
	var e: PlayerBigua = entity
	
	e.consume_fishes()


func run(delta):
	var e: PlayerBigua = entity
	
	var charge_just_pressed = e.get_input(e.input_start, 'just_pressed')
	var charge_just_released = e.get_input(e.input_start, 'just_released')
	
	if e.inputs.dirv == Vector2.ZERO:
		e.velocity = e.velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if e.inputs.dirv:
		e.velocity = e.velocity.move_toward(Vector2(e.inputs.dirv.x * SPEED, 0), ACCEL * delta)
	
	if e.inputs.dirv.x == -1:
		e.sprite.flip_h = true
	elif e.inputs.dirv.x != 0:
		e.sprite.flip_h = false
		
	if charge_just_pressed:
		e.charge_power = e.CHARGE_MIN
	
		tween = get_tree().create_tween()
		tween.tween_property(e, 'charge_power', e.CHARGE_MAX, e.CHARGE_LOAD_SECONDS) \
			.set_ease(Tween.EASE_IN) \
			.set_trans(Tween.TRANS_LINEAR)
	if charge_just_released:
		tween.stop()
		end("Dive")
