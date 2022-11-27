# Script has to extend the node in which it is attached to
extends AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	# Programatically connect a signal
	connect("animation_finished", self, "_on_animation_finished")
	# Start on frame 0
	frame = 0
	play("Animate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	# For testing the animation
#	if Input.is_action_just_pressed("attack"):
#		animatedSprite.frame = 0
#		animatedSprite.play("Animate")


func _on_animation_finished():
	queue_free()
