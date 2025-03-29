extends State


func begin():
	pass


func run(delta):
	var e: BaseFish = entity
	
	e.velocity = e.velocity.move_toward(Vector2(e.SPEED * e.dir_h, 0), e.FRICTION * delta)
