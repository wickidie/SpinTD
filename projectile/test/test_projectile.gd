class_name TestProjectile extends Projectile

func _init():
	var projectiles_data: ProjectilesData = ProjectilesData.new()
	projectile_name = "TestProjectile"
	speed = projectiles_data.projectiles_data[projectile_name]["speed"]
	damage = projectiles_data.projectiles_data[projectile_name]["damage"]
