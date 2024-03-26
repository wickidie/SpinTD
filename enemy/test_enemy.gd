extends PathFollow2D

@export var speed: float = 3

func _ready():
	loop = false
	rotates = false
	rotation = 0
	pass # Replace with function body.

func _process(delta):
	move_unit()
	pass

func move_unit():
	progress += speed
	#static_body_2d.position = global_position
	if (progress_ratio == 1):
		print(self, " Finish")
		queue_free()
		return
	pass

func _on_hitbox_area_entered(area: Area2D) -> void:
	if (area.is_in_group("TowerProjectile")):
		print(self, " Dead")
		queue_free()
	pass # Replace with function body.
