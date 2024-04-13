class_name Projectile extends CharacterBody2D

signal enemy_killed

@onready var timer: Timer = $Timer
@onready var hitbox: Area2D = $Area2D

var projectile_name: String
var speed: float
var damage: float
var target: Vector2
var enemies: Array
var can_damage: bool = true
var projectile_owner: Player

func _ready() -> void:
	enemy_killed.connect(receive_bounty)
	timer.wait_time = 2
	timer.start()

func _physics_process(_delta: float) -> void:
	move_to_target()

func load_projectile_stat(projectile_name):
	var projectiles_data: ProjectilesData = ProjectilesData.new()
	speed = projectiles_data.projectiles_data[projectile_name]["speed"]
	damage = projectiles_data.projectiles_data[projectile_name]["damage"]

func move_to_target():
	velocity = target.normalized() * speed
	move_and_slide()

func receive_bounty():
	projectile_owner.economy.money += enemies[0].get_parent().bounty

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Enemy") and can_damage):
		can_damage = false
		queue_free()
		#print("Reporter : ", hitbox)
		#print("Found : ", hitbox.get_overlapping_areas())
		for enemy in hitbox.get_overlapping_areas():
			if (enemy.is_in_group("Enemy")):
				enemies.append(enemy)
		#print("Enemies : ", enemies)
		if (enemies[0].get_parent().take_damage(damage)):
			enemy_killed.emit()

func _on_area_2d_area_exited(area):
	if (area.is_in_group("Enemy")):
		for enemy in hitbox.get_overlapping_areas():
			if (enemy.is_in_group("Enemy")):
				enemies.erase(enemy)
				#print(enemy, " Exit")

func _on_timer_timeout() -> void:
	queue_free()
