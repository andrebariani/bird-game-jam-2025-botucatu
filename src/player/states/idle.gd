extends State

func run(_delta):
	var e: PlayerBigua = entity
	
	if e.inputs.dirv:
		end("Move")
