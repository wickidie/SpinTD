class_name TowersData extends Resource

var towers_data: Dictionary = {
	"Test" : {
		"build_cost" : 1,
		"attack_speed" : 1,
		"projectile" : "res://projectile/explosive/projectile_explosive.tscn",
		"base" : "res://tower/test/test_tower_base.png",
		"nozzle" : "res://tower/test/test_tower_nozzle.png"
	},
	"Basic" : {
		"build_cost" : 10,
		"attack_speed" : 1,
		"projectile" : "res://projectile/basic/projectile_basic.tscn",
		"base" : "res://tower/basic/tower_basic_base.png",
		"nozzle" : "res://tower/test/test_tower_nozzle.png"
	},
	"Gatling" : {
		"build_cost" : 30,
		"attack_speed" : 2,
		"projectile" : "res://projectile/explosive/projectile_explosive.tscn",
		"base" : "res://tower/gatling/tower_base_gatling.png",
		"nozzle" : "res://tower/test/test_tower_nozzle.png"
	}
}
