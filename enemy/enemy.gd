class_name Enemy extends PathFollow2D

var EnemiesData: Resource = preload("res://enemy/enemy_data.gd")

@onready var hitbox: Area2D = $Hitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hp_bar: TextureProgressBar = $HPBar

var enemy_name: String
var health: float
var speed: float
var bounty: float
var life_damage: float

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
