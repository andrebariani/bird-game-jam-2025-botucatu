extends State

@onready var timer := $Timer

func begin():
	var e: BaseFish = entity
	if e.just_spawned:
		end("Roam")
		return
	
	if timer.is_stopped():
		timer.start(randf_range(0.1, 5))


func run(delta):
	var e: BaseFish = entity
	
	e.velocity = e.velocity.move_toward(Vector2.ZERO, e.FRICTION * delta)
	
	if timer.is_stopped():
		if randi_range(0, 1):
			end("Roam")
		else:
			end("Leave")


func before_end(_next):
	var e: BaseFish = entity
	
	if not e.just_spawned:
		e.choose_flip()
	if not e.detected:
		e.choose_flip()
