class_name BasicTower extends Tower

func _init():
	var towers_data: TowersData = TowersData.new()
	tower_name = "TestTower1"
	build_cost = towers_data.towers_data[tower_name]["build_cost"]
	attack_speed = towers_data.towers_data[tower_name]["attack_speed"]

