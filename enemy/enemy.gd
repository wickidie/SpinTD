class_name Enemy extends PathFollow2D

var EnemiesData: Resource = preload("res://enemy/enemy_data.gd")
var HitFlash: PackedScene = preload("res://enemy/hit_flash.tscn")
var HIT_SHADER: Shader = preload("res://enemy/hit_shader.tres")

@onready var hitbox: Area2D = $Hitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hp_bar: TextureProgressBar = $HPBar

var enemy_name: String
var health: float
var speed: float
var bounty: float
var damage_to_lives: float
var animation_player: AnimationPlayer
var player_projectile: Player
var level_manager: LevelManager

func _ready() -> void:
	level_manager = get_parent().get_parent().level_manager
	hp_bar.max_value = health
	hp_bar.value = health
	loop = false
	rotation = 0
	setup_hit_shader()

func _process(delta: float) -> void:
	hp_bar.rotation = -rotation
	if (rotation_degrees == 180):
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false
	move_unit(delta)

func load_enemy_stat(enemy_name: String) -> void:
	var enemies_data: EnemiesData = EnemiesData.new()
	health = enemies_data.enemies_data[enemy_name]["health"]
	speed = enemies_data.enemies_data[enemy_name]["speed"]
	bounty = enemies_data.enemies_data[enemy_name]["bounty"]
	damage_to_lives = enemies_data.enemies_data[enemy_name]["damage_to_lives"]

func move_unit(delta: float) -> void:
	progress += speed * delta
	if (progress_ratio == 1):
		level_manager.lives -= damage_to_lives
		level_manager.lives_damaged.emit()
		queue_free()

func take_damage(damage: int, projectile: Player) -> bool:
	player_projectile = projectile
	health -= damage
	hp_bar.value = health
	animation_player.play("hit_flash")
	if (health <= 0):
		player_projectile.money += bounty
		queue_free()
		return true
	else:
		return false

func setup_hit_shader() -> void:
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = HIT_SHADER
	sprite_2d.material = shader_material
	animation_player = HitFlash.instantiate()
	add_child(animation_player)
