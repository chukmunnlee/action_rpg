# extend from the node the script is attached to
extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

var velocity = Vector2.ZERO
var animationPlayer = null 
var animationTree = null
var animationState = null
# alternative to _ready() function
# onready var animationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	print("player is ready")
	# $ to get a node in the same scene
	# only accessible when the game starts
	# or use the onready var
	animationPlayer = $AnimationPlayer 
	animationTree = $AnimationTree
	# get the AnimationPlayer from the AnimationTree, this is the FSM
	animationState = animationTree.get("parameters/playback")

# called every tick 1/60 sec
func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	# normalized the vector the unit lenght, reduced the diagonal speed of the sprite
	input_vector = input_vector.normalized()
	
	if input_vector == Vector2.ZERO:
		# friction, if not pressing any keys, reduce the velocity slowly
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	else:
		# setting the blend position
		# the value is from the Idle blend position in the inspector window of AnimationTree
		# add .1 to the Y axis in the animation tree (Idle/Run) to get it to prioritize left/right over up/down
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		# Run is the node name in the AnimationTree
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
		# capped the speed
		#velocity += input_vector * ACCELERATION * delta		

	#move_and_collide(velocity * delta)
	# move_and_slide() will handle the delta inside the function
	# returned the velocity after the collision
	velocity = move_and_slide(velocity)
