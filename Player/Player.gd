# extend from the node the script is attached to
extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

var velocity = Vector2.ZERO
var animationPlayer = null 
var animationName = "IdleRight"
# alternative to _ready() function
# onready var animationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	print("player is ready")
	# $ to get a node in the same scene
	# only accessible when the game starts
	# or use the onready var
	animationPlayer = $AnimationPlayer 

# called every tick 1/60 sec
func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	# normalized the vector the unit lenght, reduced the diagonal speed of the sprite
	input_vector = input_vector.normalized()
	
	if input_vector.x > 0:
		animationName = "RunRight"
	elif input_vector.x < 0:
		animationName = "RunLeft"
	else:
		if animationName == "RunRight":
			animationName = "IdleRight"
		elif animationName == "RunLeft":
			animationName = "IdleLeft"
			
	animationPlayer.play(animationName)
	
	if input_vector == Vector2.ZERO:
		# friction, if not pressing any keys, reduce the velocity slowly
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	else:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		# capped the speed
		#velocity += input_vector * ACCELERATION * delta		

	#move_and_collide(velocity * delta)
	# move_and_slide() will handle the delta inside the function
	# returned the velocity after the collision
	velocity = move_and_slide(velocity)
