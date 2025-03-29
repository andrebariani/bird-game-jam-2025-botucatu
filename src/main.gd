extends Node2D

@onready var bigua = get_node_or_null("bigua")

func _ready():
	if bigua:
		$FishSpawner.init(bigua)
		$MainUI.init(bigua)
