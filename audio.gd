extends Node

var above_water = true
func switch_ambience():
	above_water = !above_water
	
	if above_water:
		$ambience.volume_db = 0
		$ambience_underwater.volume_db = -80
		$bgm.volume_db = 0
		$bgm_underwater.volume_db = -80
	else:
		$ambience.volume_db = -80
		$ambience_underwater.volume_db = 0
		$bgm.volume_db = -80
		$bgm_underwater.volume_db = 0
