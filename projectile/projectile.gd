class_name Projectile extends CharacterBody2D

signal enemy_killed

@onready var m_timer: Timer = $Timer
@onready var m_hitbox: Area2D = $Area2D

var m_projectile_name: String
var m_speed: float
var m_damage: float
var m_target: Vector2
var m_enemies: Array
var m_can_damage: bool = true
var m_projectile_owner: Player
var m_enemies_in_aoe: Array
var m_projectile_state: Callable

func _ready() -> void:
	enemy_killed.connect(receive_bounty)
	m_timer.wait_time = 2
	m_timer.start()

func _physics_process(_delta: float) -> void:
	m_projectile_state.call()

func load_projectile_stat(projectile_name):
	var projectiles_data: ProjectilesData = ProjectilesData.new()
	m_speed = projectiles_data.projectiles_data[projectile_name]["speed"]
	m_damage = projectiles_data.projectiles_data[projectile_name]["damage"]

func move_to_target():
	velocity = m_target.normalized() * m_speed
	move_and_slide()
	m_projectile_state = move_to_target

func stop_moving():
	velocity = Vector2.ZERO
	m_projectile_state = stop_moving

func receive_bounty():
	# m_projectile_owner.economy.money += m_enemies[0].get_parent().bounty
	pass

func apply_single_damage(enemy):
	enemy.get_parent().take_m_damage(m_damage)

func apply_area_damage():
	var aoe: Area2D = Area2D.new()
	var collision: CollisionShape2D = CollisionShape2D.new()
	var circle_shape: CircleShape2D = CircleShape2D.new()
	circle_shape.radius = 32
	collision.set_deferred("shape", circle_shape)
	aoe.monitorable = false
	aoe.add_child(collision)
	add_child(aoe)
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Enemy") and m_can_damage):
		m_can_damage = false
		#print("Reporter : ", m_hitbox)
		#print("Found : ", m_hitbox.get_overlapping_areas())
		for enemy in m_hitbox.get_overlapping_areas():
			if (enemy.is_in_group("Enemy")):
				m_enemies.append(enemy)
		#print("m_enemies : ", m_enemies)
		if (m_enemies[0].get_parent().take_damage(m_damage)):
			enemy_killed.emit()

func _on_area_2d_area_exited(area):
	if (area.is_in_group("Enemy")):
		for enemy in m_hitbox.get_overlapping_areas():
			if (enemy.is_in_group("Enemy")):
				m_enemies.erase(enemy)
				#print(enemy, " Exit")

func _on_timer_timeout() -> void:
	queue_free()

func call_child():
	print("im parent")
