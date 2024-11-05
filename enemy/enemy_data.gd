class_name EnemiesData extends Resource

var enemies_data: Dictionary

func _init():
	enemies_data = {
		"TestEnemy" : {
			"health" : 3,
			"speed" : 80,
			"bounty" : 1,
			"damage_to_lives" : 1,
		},
		"BasicEnemy" : {
			"health" : 3,
			"speed" : 80,
			"bounty" : 1,
			"damage_to_lives" : 1,
		},
		"FastEnemy" : {
			"health" : 2,
			"speed" : 100,
			"bounty" : 2,
			"damage_to_lives" : 2,
		},
		"TankEnemy" : {
			"health" : 10,
			"speed" : 50,
			"bounty" : 5,
			"damage_to_lives" : 5,
		},
		"BonusEnemy" : {
			"health" : 1,
			"speed" : 120,
			"bounty" : 2,
			"damage_to_lives" : 1,
		}
	}
