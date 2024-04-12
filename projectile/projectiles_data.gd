class_name ProjectilesData extends Resource

var projectiles_data: Dictionary

func _init():
	projectiles_data = {
		"TestProjectile" : {
			"speed" = 500,
			"damage" = 2
		},
		"BasicProjectile" : {
			"speed" = 500,
			"damage" = 1
		}
	}
