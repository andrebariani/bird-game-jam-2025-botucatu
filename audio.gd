extends Node

var ambience_sfxs = []

@onready var underwater_effect: AudioEffectLowPassFilter = AudioServer.get_bus_effect(1, 0)

@export var min_cuttout_freq = 8000

var bgm_original_volume = 0.0
var bgm_underwater_original_volume = 0.0
var ambience_original_volume = 0.0
var ambience_underwater_original_volume = 0.0

func _ready():
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.game_win.connect(_on_game_win)
	
	var sfxs = $sfxs.get_children()
	
	for sfx in sfxs:
		ambience_sfxs.append(sfx)
	
	bgm_original_volume = $bgm.volume_db
	bgm_underwater_original_volume = $bgm_underwater.volume_db
	ambience_original_volume = $ambience.volume_db
	ambience_underwater_original_volume = $ambience_underwater.volume_db
	$Timer.start(randi_range(5, 15))

func _on_game_over():
	$bgm.stop()
	$bgm_underwater.stop()
	$lose.play(0.0)
	
func _on_game_win():
	$bgm.stop()
	$bgm_underwater.stop()


func reset():
	$bgm.play(0.0)
	$bgm_underwater.play(0.0)
	$bgm_underwater.volume_db = -80
	$ambience_underwater.volume_db = -80
	underwater_effect.cutoff_hz = 20500
	

var above_water = true
func switch_ambience():
	above_water = !above_water
	
	if above_water:
		$ambience.volume_db = ambience_original_volume
		$ambience_underwater.volume_db = -80
		$bgm_underwater.volume_db = -80
		underwater_effect.cutoff_hz = 20500
	else:
		$ambience.volume_db = -80
		$ambience_underwater.volume_db = ambience_underwater_original_volume
		$bgm_underwater.volume_db = bgm_underwater_original_volume
		underwater_effect.cutoff_hz = min_cuttout_freq


func _on_timer_timeout():
	print_debug('playing sfx')
	var sfx = ambience_sfxs.pick_random()
	sfx.play(0.0)
	$NextSfxTimer.start(sfx.stream.get_length())


func _on_next_sfx_timer_timeout():
	print_debug('now prepare to play new sfx')
	$Timer.start(randi_range(5, 15))
