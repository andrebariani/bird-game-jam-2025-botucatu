extends State

func begin():
	var e: PlayerBigua = entity
	e.velocity = Vector2.ZERO
	$Timer.start()


func run(_delta):
	if $Timer.is_stopped():
		end("Swim")
