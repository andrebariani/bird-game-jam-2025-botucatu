extends Control


@onready var bigua: PlayerBigua

func init(_bigua: PlayerBigua):
	bigua = _bigua
	
func _process(_delta):
	$energy.set_text(str(bigua.stamina))
