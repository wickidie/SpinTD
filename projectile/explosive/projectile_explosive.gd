class_name ProjectileExplosive extends Projectile

var aoe: Area2D = Area2D.new()
var collision: CollisionShape2D = CollisionShape2D.new()
var circle_shape: CircleShape2D = CircleShape2D.new()

func _init():
	m_projectile_name = "ProjectileExplosive"
	load_projectile_stat(m_projectile_name)

func start(target: Vector2):
	circle_shape.set_deferred("radius", 32)
	collision.set_deferred("shape", circle_shape)
	collision.set_deferred("disable", true)
	aoe.add_child(collision)
	add_child(aoe)
	m_target = target
	look_at(m_target)
	move_to_target()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Enemy") and m_can_damage):
		m_can_damage = false
		stop_moving()
		get_enemies_in_aoe()

func get_enemies_in_aoe():
	collision.set_deferred("disable", false)
	for area in aoe.get_overlapping_areas():
		if (area.is_in_group("Enemy")):
			m_enemies_in_aoe.append(area)

	for enemy in m_enemies_in_aoe:
		if (enemy.get_parent().take_damage(m_damage)):
			enemy_killed.emit()
	collision.set_deferred("disable", true)
