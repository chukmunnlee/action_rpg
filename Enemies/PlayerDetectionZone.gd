extends Area2D

var player = null

func can_see_player():
	return null != player

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	
func _on_PlayerDetectionZone_body_exited(body):
	player = null
