class_name ProjectilesData extends Resource

var projectiles_data: Dictionary

func _init() -> void:
	projectiles_data = {
		"ProjectileTest" : {
			"speed" = 300,
			"damage" = 2
		},
		"ProjectileBasic" : {
			"speed" = 300,
			"damage" = 1
		},
		"ProjectileExplosive" : {
			"speed" = 300,
			"damage" = 1
		}
	}
