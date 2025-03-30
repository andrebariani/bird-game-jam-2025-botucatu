extends CharacterBody2D
class_name BaseFish

@onready var sprite = $sprite
@onready var sm = $States

@export var data: FishData

@export_subgroup("Movement")
@export var SPEED = 100
@export var ESCAPE_SPEED = 100
@export var FRICTION = 75

@export var MAX_DISTANCE_LEFT = -100
@export var MAX_DISTANCE_RIGHT = 1124


var just_spawned = true
var dir_h = 1
var detected = false

func init(dir):
	dir_h = dir
	$VisionBox.scale.x = dir

func _ready():
	sm.init(self)

func _physics_process(delta):
	sm.run(delta)
	move_and_slide()
	
	# flip whole scene for scalling
	if sign(self.velocity.x) == 1:
		$VisionBox.scale.x = 1
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		$VisionBox.scale.x = -1
	$Label.set_text(str(self.velocity.x))
	
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

func _on_vision_box_body_entered(body):
	if body is PlayerBigua:
		detected = true
		sm.end_current_state("Escape")
		flip()
