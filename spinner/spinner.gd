class_name Spinner extends Node2D

@onready var cooldown: Timer = $Cooldown
@onready var progress_bar: ProgressBar = $Info/ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spinner: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_spin: AudioStreamPlayer2D = $SfxSpin
@onready var sfx_jackpot: AudioStreamPlayer2D = $SfxJackpot
@onready var gpu_particles_2d = $GPUParticles2D
var particle_list: Array = [
	"res://spinner/normal_spinner_particle.tres",
	"res://spinner/jackpot_spinner_particle.tres"
]

var loot_table: Dictionary = {
	"large_gold" : {
		"weight" : 1,
		"amount" : 100
	},
	"medium_gold" : {
		"weight" : 3,
		"amount" : 40
	},
	"small_gold" : {
		"weight" : 6,
		"amount" : 10
	}
}

var can_spin: bool
var has_cooldown: bool
var loot_keys: Array
var spin_cost: float = 20
var cumulative_weight: float
var player: Player

func _ready():
	player = get_parent().level_manager.player
	gpu_particles_2d.process_material = ResourceLoader.load(particle_list[0])
	gpu_particles_2d.emitting = false
	gpu_particles_2d.one_shot = true
	has_cooldown = true
	load_table()
	progress_bar.max_value = cooldown.wait_time
	cooldown.start()

func _process(_delta):
	progress_bar.value = cooldown.wait_time - cooldown.time_left

func load_table():
	loot_keys = loot_table.keys()
	for i in range(loot_table.size()):
		cumulative_weight += loot_table[loot_keys[i]]["weight"]
	print("Cumulative Weight : ", cumulative_weight)

func roll():
	sfx_spin.play()
	#animation_player.play("spinner_spinning")
	spinner.play()
	can_spin = false
	cooldown.start()
	var roll_value = randi_range(1, cumulative_weight)
	player.money -= spin_cost
	print("\nRoll : ", roll_value)
	for i in range(loot_table.size()):
		if (roll_value <= loot_table[loot_keys[i]]["weight"]):
			print(loot_keys[i], " ", loot_table[loot_keys[i]]["amount"])
			prize_audio(i)
			player.money += loot_table[loot_keys[i]]["amount"]
			return
		else:
			roll_value -= loot_table[loot_keys[i]]["weight"]

func prize_audio(i: int):
	if (i == 0):
		gpu_particles_2d.process_material = ResourceLoader.load(particle_list[1])
		gpu_particles_2d.restart()
		sfx_jackpot.play()
	else:
		gpu_particles_2d.process_material = ResourceLoader.load(particle_list[0])
		gpu_particles_2d.restart()

func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if (Input.is_action_pressed("LMB") and (can_spin or not has_cooldown)
	and player.money >= spin_cost):
		roll()


func _on_cooldown_timeout():
	spinner.stop()
	cooldown.stop()
	can_spin = true;
