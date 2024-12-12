extends EnemyWaves

# 2D array concept [enemy_type, mob_set, mob_interval, set_interval]
func _init() -> void:
	load_enemy_scene()
	wave_list = {
		"1" : {
			"enemy_set" : [
				[TEST_ENEMY, 5, 0.3, 3],
				[BASIC_ENEMY, 10, 0.2, 3],
			],
		},
		"2" : {
			"enemy_set" : [
				[TEST_ENEMY, 10, 0.1, 3],
				[FAST_ENEMY, 5, 0.3, 3],
				[FAST_ENEMY, 10, 0.2, 3],
			],
		},
		"3" : {
			"enemy_set" : [
				[TEST_ENEMY, 5, 0.3, 3],
				[BASIC_ENEMY, 15, 0.3, 3],
				[FAST_ENEMY, 10, 0.1, 3],
			],
		},
		"4" : {
			"enemy_set" : [
				[TEST_ENEMY, 5, 0.3, 3],
				[TANK_ENEMY, 5, 0.3, 3],
			],
		},
		"5" : {
			"enemy_set" : [
				[TEST_ENEMY, 5, 0.3, 3],
				[TANK_ENEMY, 5, 0.5, 3],
				[FAST_ENEMY, 10, 0.2, 3],
			],
		},
	}
