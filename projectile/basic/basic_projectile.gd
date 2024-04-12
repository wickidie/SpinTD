class_name BasicProjectile extends Projectile

func _init():
	var projectiles_data: ProjectilesData = ProjectilesData.new()
	projectile_name = "BasicProjectile"
	speed = projectiles_data.projectiles_data[projectile_name]["speed"]
	damage = projectiles_data.projectiles_data[projectile_name]["damage"]
