class_name Enemy extends PathFollow2D

@export var speed: float = 200
@onready var hitbox: Area2D = $Hitbox
var bounty: float = 1
var life_damage: float = 10

func _ready():
	loop = false
	rotates = false
	rotation = 0

func _process(delta):
	move_unit(delta)

func move_unit(delta):
	progress += speed * delta
	if (progress_ratio == 1):
		#print(self, " Finish")
		queue_free()
		GameManager.life_setted.emit(GameManager.life - life_damage)
	pass

func destroy():
	#print(self, " + ", hitbox , " Dead")
	queue_free()
