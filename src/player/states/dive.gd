extends State

@export var MAX_SPEED = 250.0
@export var STEER_SPEED = 25.0
@export var ROTATION_SPEED = 0.05
@export var FRICTION = 150

@export var STAMINA_COST = 1000

func begin():
	var e: PlayerBigua = entity
	
	e.is_underwater = true
	e.breath_timer.start()
	e.stamina -= STAMINA_COST * (e.charge_power / 100.0)
	
	var dive_power = (e.charge_power / 100.0) * MAX_SPEED
	e.velocity = Vector2(0, dive_power)
	e.sprite.rotation = deg_to_rad(90)
	
	if e.charge_power >= 40:
		e.play_sfx("dive")
	else:
		e.play_sfx("dive_short")


func run(delta):
	var e: PlayerBigua = entity
	
	e.velocity = e.velocity.move_toward(Vector2(e.inputs.dirv.x * STEER_SPEED, 0), FRICTION * delta)
	
	if e.velocity.y <= MAX_SPEED * 0.8:
		var velocity_angle = e.velocity.normalized().angle()
		e.sprite.rotation = lerp_angle(e.sprite.rotation, velocity_angle, ROTATION_SPEED)
	
	if e.velocity.y <= MAX_SPEED * 0.2:
		end("Swim")
