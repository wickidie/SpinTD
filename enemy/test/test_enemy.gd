class_name TestEnemy extends Enemy

func _init():
	enemy_name = "TestEnemy"
	load_enemy_stat(enemy_name)
	
func take_damage(damage):
	animation_player.play("hit_flash")
