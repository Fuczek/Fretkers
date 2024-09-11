extends Control

@onready var players = get_tree().get_nodes_in_group("player")
@onready var timer = $Timer
@onready var time = $time
@onready var info = $info

@export_range(5, 20) var turn_time : int = 5

enum turns {MOVE, FIGHT, ACTION}
var turn = turns.MOVE

# Called when the node enters the scene tree for the first time.
func _ready():
	for each in players:
		each.attack_preped.connect(_on_attack_preped)
	#player.update_power_bar.connect(_on_power_bar_update)
	time.text = str(turn_time)

var attacks_preped : int = 0
func _on_attack_preped():
	attacks_preped += 1
	if attacks_preped == players.size():
		timer.stop()
		timer_to_tick_down = -1
		_on_timer_timeout()
		attacks_preped = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
var timer_to_tick_down = turn_time
func _process(delta):
	if turn == turns.MOVE and timer_to_tick_down == turn_time:
		attacks_preped = 0
		time.text = str(timer_to_tick_down)
		info.text = str('MOVE TURN!')
		timer_to_tick_down -= 1
		timer.start()
	
	if turn == turns.FIGHT and timer_to_tick_down == turn_time:
		time.text = str(timer_to_tick_down)
		info.text = str('FIGHT TURN!')
		timer_to_tick_down -= 1
		timer.start()
		
	if turn == turns.ACTION and timer_to_tick_down == turn_time:
		info.text = str('ACTION!')
		timer_to_tick_down -= 4
		time.text = str(timer_to_tick_down)
		timer.start()

func _on_timer_timeout():
	if timer_to_tick_down >= 0:
		time.text = str(timer_to_tick_down)
		timer.start()
	else:
		time.text = str(timer_to_tick_down)
		if turn == turns.MOVE:
			turn = turns.FIGHT
		elif turn == turns.FIGHT:
			if attacks_preped > 0:
				turn = turns.ACTION
			else:
				turn = turns.MOVE
		else:
			turn = turns.MOVE
		timer_to_tick_down = turn_time
		return
	
	timer_to_tick_down -= 1
	

#func _on_power_bar_update(hold_time):
	#power_bar.value = hold_time
