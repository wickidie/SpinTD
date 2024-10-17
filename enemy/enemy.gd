class_name Enemy extends PathFollow2D

var EnemiesData: Resource = preload("res://enemy/enemy_data.gd")

@onready var hitbox: Area2D = $Hitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hp_bar: TextureProgressBar = $HPBar
@onready var animation_player = $AnimationPlayer

var enemy_name: String
var health: float
var speed: float
var bounty: float
var life_damage: float

# TODO : Need to refactor Enemy code

func _ready():
	hp_bar.max_value = health
	hp_bar.value = health
	loop = false
	#rotates = false
	rotation = 0

func _process(delta):
	hp_bar.rotation = -rotation
	if (rotation_degrees == 180):
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false
	move_unit(delta)

func load_enemy_stat(enemy_name: String):
	var enemies_data: EnemiesData = EnemiesData.new()
	health = enemies_data.enemies_data[enemy_name]["health"]
	speed = enemies_data.enemies_data[enemy_name]["speed"]
	bounty = enemies_data.enemies_data[enemy_name]["bounty"]
	life_damage = enemies_data.enemies_data[enemy_name]["life_damage"]

func move_unit(delta):
	progress += speed * delta
	if (progress_ratio == 1):
		#print(self, " Finish")
		queue_free()
		GameManager.life_setted.emit(GameManager.life - life_damage)
	pass

func take_damage(damage):
	health -= damage
	hp_bar.value = health
	if (health <= 0):
		queue_free()
		return true
