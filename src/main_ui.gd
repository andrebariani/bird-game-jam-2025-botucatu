extends Control


@onready var bigua: PlayerBigua

func init(_bigua: PlayerBigua):
	bigua = _bigua

func _ready() -> void:
	$Button.grab_focus()

func _process(_delta):
	$energy.set_text(str(bigua.stamina))

var pressed = false
func _on_button_pressed() -> void:
	if not pressed:
		pressed = true
		SignalBus.game_start.emit()
		$Button.visible = false
