# extend from the node the script is attached to
extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

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
	# start the animation tree when the game starts
	animationTree.active = true
	# Disable the collisionshape when the player is instantiated
	$HitboxPiviot/SwordHitbox/CollisionShape2D.disabled = true

# called every tick 1/60 sec
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ATTACK:
			attack_state()
			
		ROLL:
			pass
	
func move_state(delta):
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
		animationTree.set("parameters/Attack/blend_position", input_vector)
		# Run is the node name in the AnimationTree
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
		# capped the speed
		#velocity += input_vector * ACCELERATION * delta		

	#move_and_collide(velocity * delta)
	# move_and_slide() will handle the delta inside the function
	# returned the velocity after the collision
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state():
	# stand still when attacking
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	# don't forget to disable looping in the animation
	state = MOVE
