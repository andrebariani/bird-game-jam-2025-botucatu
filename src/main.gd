extends Node2D

@onready var bigua = get_node_or_null("bigua")
@onready var spawner = get_node_or_null("FishSpawner")
@onready var ui = get_node_or_null("MainUI")

func _ready():
	if bigua:
		bigua.run = false
		bigua.visible = false
		spawner.init(bigua)
		ui.init(bigua)
		SignalBus.game_start.connect(_on_game_start)
		SignalBus.game_over.connect(_on_game_start)
		SignalBus.game_win.connect(_on_game_win)

func _on_game_over():
	bigua.run = false
	bigua.visible = false
	
	
	ui.lose.visible = true
	
func _on_game_win():
	bigua.run = false
	bigua.visible = false
	
	ui.win.visible = true
		
func _on_game_start():
	bigua.run = true
	bigua.visible = true
	$Scenario/big_bigua_rock.visible = false
	spawner.start()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		AudioGlobal.reset()
		get_tree().reload_current_scene()
