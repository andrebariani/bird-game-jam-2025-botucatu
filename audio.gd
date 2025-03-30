extends Node

var ambience_sfxs = []

@onready var underwater_effect: AudioEffectLowPassFilter = AudioServer.get_bus_effect(1, 0)

@export var min_cuttout_freq = 8000

func _ready():
	var sfxs = $sfxs.get_children()
	
	for sfx in sfxs:
		ambience_sfxs.append(sfx)
		
	$Timer.start(randi_range(5, 20))


func reset():
	$bgm.play(0.0)
	$bgm_underwater.play(0.0)
	$ambience_underwater.volume_db = -80
	underwater_effect.cutoff_hz = 20500
	

var above_water = true
func switch_ambience():
	above_water = !above_water
	
	if above_water:
		$ambience.volume_db = 0
		$ambience_underwater.volume_db = -80
		$bgm_underwater.volume_db = -80
		underwater_effect.cutoff_hz = 20500
	else:
		$ambience.volume_db = -80
		$ambience_underwater.volume_db = 0
		$bgm_underwater.volume_db = 0
		underwater_effect.cutoff_hz = min_cuttout_freq


func _on_timer_timeout():
	var sfx = ambience_sfxs.pick_random()
	sfx.play(0.0)
	$Timer.start(randi_range(5, 20))
