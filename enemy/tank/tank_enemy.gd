class_name TankEnemy extends Enemy

func _init():
	var enemies_data: EnemiesData = EnemiesData.new()
	enemy_name = "TankEnemy"
	health = enemies_data.enemies_data[enemy_name]["health"]
	speed = enemies_data.enemies_data[enemy_name]["speed"]
	bounty = enemies_data.enemies_data[enemy_name]["bounty"]
	life_damage = enemies_data.enemies_data[enemy_name]["life_damage"]
