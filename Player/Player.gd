# extend from the node the script is attached to
extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("player is ready")

# called every tick
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
	move_and_collide(input_vector)
