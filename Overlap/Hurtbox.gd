extends Area2D

export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = HitEffect.instance()
		# TODO: What is the difference between position and global_position ??
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
