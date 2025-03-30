extends State

func run(_delta):
	var e: PlayerBigua = entity
	
	if e.run and $StartTimer.is_stopped():
		$StartTimer.start()

func _on_start_timer_timeout():
	print_debug('help')
	end("Move")
