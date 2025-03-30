extends Control


@onready var bigua: PlayerBigua

@onready var win = $wiiiin
@onready var win_btn = $wiiiin/win_button
@onready var lose = $lose
@onready var lose_btn = $lose/lose_button

func init(_bigua: PlayerBigua):
	bigua = _bigua

func _ready() -> void:
	$Button.grab_focus()

func _process(_delta):
	$energy_bar.value = bigua.stamina

var pressed = false
func _on_button_pressed() -> void:
	if not pressed:
		pressed = true
		SignalBus.game_start.emit()
		$energy_bar.visible = true
		$Button.visible = false


func _on_win_button_pressed():
	get_tree().reload_current_scene()


func _on_lose_button_pressed():
	get_tree().reload_current_scene()
