extends State


func begin():
	var _e: PlayerBigua = entity


func run(delta):
	var e: PlayerBigua = entity
	
	e.velocity = e.velocity.move_toward(e.inputs.dirv * e.SPEED, e.ACCEL * delta)
	
	if e.inputs.dirv != Vector2.ZERO:
		var input_angle = e.inputs.dirv.normalized().angle()
		e.sprite.rotation = lerp_angle(e.sprite.rotation, input_angle, e.ROTATION_SPEED)
	
	if e.global_position.y < e.water_top_pos_y:
		e.velocity.y = 0.0
		end("Move")

func before_end(_next):
	var e: PlayerBigua = entity
	if _next == "Move":
		var timer: Timer = e.breath_timer
		e.is_underwater = false
		timer.stop()
		e.sprite.rotation = 0.0
