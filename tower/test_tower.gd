extends Node2D

signal enemy_spotted(enemy)

@onready var TEST_PROJECTILE = preload("res://tower/test_projectile.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var timer: Timer = $Timer

var attack_speed: float = 1
var can_shoot: bool = false
var target_list: Array
var target_list_progress: Array
var target: Node2D
var target_index: Node2D
var target_first: Node2D
var target_index_progress: float
var target_first_progress: float

func _ready():
	target = self
	timer.wait_time = attack_speed
	timer.start()

func _physics_process(delta: float) -> void:
	set_target()

func set_target():
	if (target_list.size() != 0):
		#target_list_progress = []
		#for enemy in target_list:
			#target_list_progress.append(enemy.progress)
		#target_first_progress = target_list_progress.max()
		#target_first = target_list[target_list.find(target_first_progress)]
		#target = target_first
		target = target_list[target_list.size() - 1]
		turn()
		if (can_shoot):
			print(target_first_progress)
			print(target_list.find(target_first_progress))
			shoot()
	elif (target == null):
		target = self

func turn():
	look_at(target.global_position)
	#look_at(get_global_mouse_position())

func shoot():
	var bullet = TEST_PROJECTILE.instantiate()
	get_parent().add_child(bullet)
	bullet.position = marker_2d.global_position
	bullet.look_at(target.global_position)
	bullet.target = target.global_position - global_position
	can_shoot = false

func _on_timer_timeout() -> void:
	can_shoot = true
	pass # Replace with function body.

func _on_range_area_entered(area: Area2D) -> void:
	target_list.append(area.get_parent())

	pass # Replace with function body.


func _on_range_area_exited(area: Area2D) -> void:
	target_list.erase(area.get_parent())
	pass # Replace with function body.
