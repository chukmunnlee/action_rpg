extends Node2D

# Preload the GrassEffect scene instead of loading when there is 
# a collision with the Hurtbox
const GrassEffect = preload("res://Effects/GrassEffect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("attack"):
#		# Load the GrassEffect scene
#		var GrassEffect = load("res://Effects/GrassEffect.tscn")
#		# Create an instance of GrassEffect, grassEffect is a node
#		var grassEffect = GrassEffect.instance()
#		# Set the grassEffect position. RHS global_position is the position of the Grass scene
#		# that is this current instance of Grass
#		grassEffect.global_position = global_position
#		# Get the top level node (root node) of this scene tree
#		var world = get_tree().current_scene
#		# Add grassEffect instance to the world
#		world.add_child(grassEffect)
#		queue_free()

func create_grass_effect():
	# Alternative way of performing effect as show in the video
	# Load the GrassEffect scene
	# var GrassEffect = load("res://Effects/GrassEffect.tscn")
	# Instantiate the scene
	var grassEffect = GrassEffect.instance()
	# Sets the position of the effect
	grassEffect.position = self.position
	# And copy the transform and apply to grassEffect as well
	# Transform also has position
	grassEffect.set_transform(get_transform())
	# Add the grassEffect to the parent of Grass
	get_parent().add_child(grassEffect)

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
