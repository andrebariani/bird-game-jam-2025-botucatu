extends CharacterBody2D
class_name BaseFish

@onready var sm = $States

@export var data: FishData

@export_subgroup("Movement")
@export var SPEED = 100
@export var ESCAPE_SPEED = 100
@export var FRICTION = 75

@export var MAX_DISTANCE_LEFT = -100
@export var MAX_DISTANCE_RIGHT = 500


var just_spawned = true
var dir_h = 1

func init(dir):
	dir_h = dir

func _ready():
	sm.init(self)

func _physics_process(delta):
	sm.run(delta)
	move_and_slide()
	
	if self.global_position.x < MAX_DISTANCE_LEFT or \
		self.global_position.x > MAX_DISTANCE_RIGHT:
		despawn()

func choose_flip():
	if randi_range(0, 1):
		flip()

func flip():
	dir_h *= -1

func despawn():
	call_deferred("queue_free")
