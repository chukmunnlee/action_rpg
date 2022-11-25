extends Node

signal no_health

# Exposes the max_health variable to the Inspector
# Optionally specify the type in the ()
# See https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
export(int) var max_health = 1

# Getter and setter functions
onready var health = max_health setget set_health

func set_health(value):
	health = value
	if health <= 0:
		# call down, signal up
		emit_signal("no_health")
