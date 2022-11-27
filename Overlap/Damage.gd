extends Node2D

onready var sprite = $Sprite

export(int) var damage = 0 setget set_damage

# export(Vector2) var offset = Vector2.ZERO setget set_offset
	
func _ready():
	pass # Replace with function body.
	
func set_damage(value):
	sprite.frame = value
