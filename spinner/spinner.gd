extends Node2D

@onready var cooldown = $Cooldown
@onready var progress_bar = $ProgressBar
@onready var animation_player = $AnimationPlayer
@onready var sfx_spin = $SfxSpin
@onready var sfx_jackpot = $SfxJackpot

var loot_table: Dictionary = {
	"large_gold" : {
		"weight" : 1,
		"amount" : 100
	},
	"medium_gold" : {
		"weight" : 3,
		"amount" : 30
	},
	"small_gold" : {
		"weight" : 6,
		"amount" : 10
	}
}

var can_spin: bool
var has_cooldown: bool
var loot_keys: Array
var cumulative_weight: float

func _ready():
	has_cooldown = true
	load_table()
	progress_bar.max_value = cooldown.wait_time
	cooldown.start()
	pass

func _process(delta):
	progress_bar.value = cooldown.wait_time - cooldown.time_left
	pass

func load_table():
	loot_keys = loot_table.keys()
	for i in range(loot_table.size()):
		cumulative_weight += loot_table[loot_keys[i]]["weight"]
	print("Cumulative Weight : ", cumulative_weight)

func roll():
	sfx_spin.play()
	animation_player.play("spinner_spinning")
	can_spin = false
	cooldown.start()
	var roll = randi_range(1, cumulative_weight)
	print("\nRoll : ", roll)
	for i in range(loot_table.size()):
		if (roll <= loot_table[loot_keys[i]]["weight"]):
			print(loot_keys[i], " ", loot_table[loot_keys[i]]["amount"])
			prize_audio(i)
			return
		else:
			roll -= loot_table[loot_keys[i]]["weight"]
	
func prize_audio(i: int):
	if (i == 0):
		sfx_jackpot.play()
	
func _on_area_2d_input_event(viewport, event, shape_idx):
	if (Input.is_action_pressed("LMB") and (can_spin or not has_cooldown)):
		roll()
		#print("Spin")
	pass # Replace with function body.

func _on_cooldown_timeout():
	cooldown.stop()
	can_spin = true;
	pass # Replace with function body.
