extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var hitbox: Area2D = $Area2D

var speed: float = 100
var target: Vector2
var enemies: Array

func _ready() -> void:
	timer.wait_time = 2
	timer.start()

func _physics_process(delta: float) -> void:
	move_to_target()

func move_to_target():
	velocity = target.normalized() * speed
	move_and_slide()
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Enemy")):
		queue_free()
		print("Reporter : ", hitbox)
		print("Found : ", hitbox.get_overlapping_areas())
		for enemy in hitbox.get_overlapping_areas():
			if (enemy.is_in_group("Enemy")):
				enemies.append(enemy)
		enemies[0].get_parent().destroy()
	pass # Replace with function body.

func _on_area_2d_area_exited(area):
	if (area.is_in_group("Enemy")):
		#print("ASDAA")
		for enemy in area.get_overlapping_areas():
			if (enemy.is_in_group("Enemy")):
				enemies.erase(enemy)
				#print(enemy, " Exit")
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	#print("\n")
	queue_free()
	pass # Replace with function body.



