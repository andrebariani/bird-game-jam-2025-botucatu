extends Node2D


@onready var timer = $SpawnTimer

@export var possible_fishes = [
	preload("res://src/entity/fish/small_fish.tscn"),
	preload("res://src/entity/fish/medium_fish.tscn"),
	preload("res://src/entity/fish/trash.tscn"),
]

@export var MAX_DISTANCE_LEFT = -100
@export var MAX_DISTANCE_RIGHT = 500
@export var SHALLOW_HEIGHT_RANGE = [100, 224] # [0, 100]
@export var DEEP_HEIGHT_RANGE = [100, 224]

@export var MAX_FISH_QUANTITY = 25

@export var SPAWN_SECONDS = 2

@export_group("Difficulty")
enum difficulty_enum {EASY, MEDIUM, HARD}
@export var difficulty = difficulty_enum.EASY
@export_subgroup("Probability")
@export var easy_weights = [2, 1, 0.5]
@export var medium_weights = [2, 0.5, 1]
@export var hard_weights = [0.5, 1, 2]

@onready var bigua = null

func init(_bigua: PlayerBigua):
	bigua = _bigua

func start():
	timer.start(randf_range(0.2, SPAWN_SECONDS))
	
func _physics_process(_delta):
	if bigua.stamina < 2500:
		difficulty = difficulty_enum.EASY
	elif bigua.stamina < 7500:
		difficulty = difficulty_enum.MEDIUM
	else:
		difficulty = difficulty_enum.HARD

func choose_fish():
	var rng = RandomNumberGenerator.new()
	var weight_array = []
	
	match difficulty:
		difficulty_enum.EASY:
			weight_array = easy_weights
		difficulty_enum.MEDIUM:
			weight_array = medium_weights
		difficulty_enum.HARD:
			weight_array = hard_weights

	var fish: BaseFish = possible_fishes[rng.rand_weighted(weight_array)].instantiate()
	spawn_fish(fish)

func spawn_fish(fish: BaseFish):
	timer.start(randf_range(0.2, SPAWN_SECONDS))
	
	if possible_fishes.size() >= MAX_FISH_QUANTITY:
		return
	
	var pos = Vector2.ZERO
	
	match fish.data.size_class:
		"Small":
			pos = Vector2(MAX_DISTANCE_LEFT, randi_range( \
				SHALLOW_HEIGHT_RANGE[0], SHALLOW_HEIGHT_RANGE[1]) \
			)
		"Medium":
			pos = Vector2(MAX_DISTANCE_LEFT, randi_range( \
				DEEP_HEIGHT_RANGE[0], DEEP_HEIGHT_RANGE[1]) \
			)
		"Trash":
			pos = Vector2(MAX_DISTANCE_LEFT, randi_range( \
				SHALLOW_HEIGHT_RANGE[0], DEEP_HEIGHT_RANGE[1]) \
			)
		
	var dir = 1
	
	if randi_range(0, 1):
		pos.x = MAX_DISTANCE_RIGHT
		dir = -1
	
	pos.y = randi_range(SHALLOW_HEIGHT_RANGE[0], SHALLOW_HEIGHT_RANGE[1])

	fish.init(dir)
	fish.global_position = pos
	
	add_child(fish)
	

func _on_spawn_timer_timeout():
	choose_fish()
