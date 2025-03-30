extends State

func begin():
	var e: PlayerBigua = entity
	e.velocity = Vector2.ZERO
	$Timer.start()
	e.play_sfx("stun")


func run(_delta):
	if $Timer.is_stopped():
		end("Swim")
