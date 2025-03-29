extends Resource
class_name FishData

@export_group("Base")
@export var id: StringName
@export var name: String
# @export var icon: CompressedTexture2D = preload("res://assets/fish_icon.png")
@export var sprite: CompressedTexture2D
@export_multiline var description: String
# @export var bait: BaitData = preload("res://scenes/items/maggot.tres")
@export var stamina: float = 0
@export_enum("Small", "Medium", "Big", "Trash") var size_class: String = "Small"
@export_range(0.1, 20, 0.1) var size_centimeters: float
