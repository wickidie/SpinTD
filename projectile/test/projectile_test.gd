class_name TestProjectile extends Projectile

func _init() -> void:
	self.m_projectile_name = "ProjectileTest"
	load_projectile_stat(self.m_projectile_name)

func start(target: Vector2) -> void:
	self.m_target = target
	look_at(self.m_target)
	move_to_target()
