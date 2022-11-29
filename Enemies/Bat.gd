extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export(int) var ACCELERATION = 300
export(int) var MAX_SPEED = 50
export(int) var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var damage = null

var state = CHASE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite

func _ready():
	damage = $Damage
	damage.damage = stats.health

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if null != player:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
				
			sprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity)
			
func seek_player():
	state = CHASE if playerDetectionZone.can_see_player() else IDLE

func _on_Hurtbox_area_entered(area):
	# call down, signal up
	# area is the Hitbox, damage is from the base class
	# knockback_vector is from SwordHitbox which extends Hitbox
	stats.health -= area.damage 
	damage.damage = stats.health
	
	knockback = area.knockback_vector * 120
	# knockback = Vector2.RIGHT * 120
	#queue_free()


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.position = self.position
	enemyDeathEffect.set_transform(get_transform())
	get_parent().add_child(enemyDeathEffect)

