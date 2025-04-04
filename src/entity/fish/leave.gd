extends State


@export var MAX_SPEED = 250.0
@export var FRICTION = 150
		

func run(delta):
	var e: BaseFish = entity
	
	e.velocity = e.velocity.move_toward(Vector2((MAX_SPEED) * e.dir_h, 0), FRICTION * delta)
