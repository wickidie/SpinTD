class_name ProjectileBasic extends Projectile

func _init() -> void:
	self.m_projectile_name = "ProjectileBasic"
	load_projectile_stat(self.m_projectile_name)

func start(target: Vector2) -> void:
	self.m_target = target
	look_at(self.m_target)
	move_to_target()
	#
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if (area.is_in_group("Enemy") and m_can_damage):
		#m_can_damage = false
		#stop_moving()
		#get_enemies_in_aoe()
		#sprite_2d.queue_free()
		#explosive_particle.restart()
		#await explosive_particle.finished
		#queue_free()
