extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO
var damage = null

onready var stats = $Stats

func _ready():
	damage = $Damage
	damage.damage = stats.health

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

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

