extends Area2D

#export(bool) var show_hit = true

signal invincibility_started 
signal invincibility_ended

const HitEffect = preload("res://Effects/HitEffect.tscn")

export(bool) var invincible = false setget set_invincible

onready var timer = $Timer

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func create_hit_effect():
	#if show_hit:
	var effect = HitEffect.instance()
	# TODO: What is the difference between position and global_position ??
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	# need self.invincible because then it will activate the setter
	# if it is just invincible, then we are accessing the varible directly
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	# cannot call monitorable = <value> directly because
	# if this is called inside the _process_physics(), it update to monitorable will be blocked
	# use set_deferred() instead
	# monitorable = false
	set_deferred("monitorable", false)

func _on_Hurtbox_invincibility_ended():
	# retrigger the area_entered signal by disable and reenabling monitorable property
	# do not need to use set_deferred() here because this is called in the timeout()
	monitorable = true
	# set_deferred("monitorable", true)
