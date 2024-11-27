class_name ProjectilesData extends Resource

var projectiles_data: Dictionary

func _init():
	projectiles_data = {
		"ProjectileTest" : {
			"speed" = 100,
			"damage" = 2
		},
		"ProjectileBasic" : {
			"speed" = 100,
			"damage" = 1
		},
		"ProjectileExplosive" : {
			"speed" = 300,
			"damage" = 1
		}
	}
