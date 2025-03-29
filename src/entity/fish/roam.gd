extends State

@onready var timer := $Timer

func begin():
	var e: BaseFish = entity
	
	if e.just_spawned:
		timer.start(randf_range(2, 4))
	else:
		timer.start(randf_range(0.2, 3))


func run(delta):
	var e: BaseFish = entity
	
	e.velocity = e.velocity.move_toward(Vector2(e.SPEED * e.dir_h, 0), e.FRICTION * delta)
	
	if timer.is_stopped() and not e.data.size_class == "Trash":
		end("Idle")


func before_end(_next):
	var e: BaseFish = entity
	
	if not e.detected:
		timer.stop()
		e.choose_flip()
