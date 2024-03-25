extends PathFollow2D

@export var speed: float = 1

func _ready():
	loop = false
	rotates = false
	pass # Replace with function body.


func _process(delta):
	move_unit()
	pass

func move_unit():
	progress += speed
	if (progress_ratio == 1):
		print(self, " -- ASD")
		queue_free()
		return
	pass
