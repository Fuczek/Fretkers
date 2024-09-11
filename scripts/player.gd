extends RigidBody2D

@onready var bullet : PackedScene = preload("res://scenes/bullet.tscn")
@onready var hud : Node = get_tree().get_first_node_in_group("hud")
#signal update_power_bar
@export var player_id : int = 1
@onready var power_bar : Node = $power_bar
@onready var hp_bar : Node = $hp
@onready var sprite : Node = $Sprite2D
@onready var target_sprite : Node = $Target
@onready var damage_particle : Node = $damage_particle
@onready var damage_particle_label : Node = $damage_particle/viewport/damage
@export var player_color : Color
#@onready var animation = $AnimationPlayer

var hp : int = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	hp_bar.text = str(hp)
	#sprite.modulate = player_color
	#target_sprite.modulate = player_color

var hold_time : float = 1.0
var attack_prepared : bool = false
var target_vector
signal attack_preped

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hud.turn == hud.turns.FIGHT and !attack_prepared:
		target_sprite.visible = true
		var distance = clamp(position.distance_to(get_viewport().get_mouse_position()), 0, 150)
		target_sprite.position = position + (get_viewport().get_mouse_position() - position).normalized() * distance
		
		if Input.is_action_pressed("hold_mouse_2") and player_id == 1 or Input.is_action_pressed("hold_mouse") and player_id == 2:
			hold_time += 20
			hold_time = clamp(hold_time, 0, 1500)
			#emit_signal("update_power_bar", hold_time)
			update_power_bar(hold_time, true)
			if hold_time == 1500:
				target_vector = (get_viewport().get_mouse_position() - position).normalized()
				attack_prepared = true
				target_sprite.modulate = player_color
				emit_signal("attack_preped")
		elif !Input.is_action_pressed("hold_mouse_2") and hold_time > 1 and player_id == 1 or !Input.is_action_pressed("hold_mouse") and hold_time > 1 and player_id == 2 :
			target_vector = (get_viewport().get_mouse_position() - position).normalized()
			attack_prepared = true
			target_sprite.modulate = player_color
			emit_signal("attack_preped")

	if hud.turn == hud.turns.ACTION and attack_prepared:
		var new_bullet_instance = bullet.instantiate()
		new_bullet_instance.linear_velocity = target_vector * hold_time
		new_bullet_instance.position += Vector2(0, -10)
		add_child(new_bullet_instance)
		hold_time = 1
		#emit_signal("update_power_bar", hold_time)
		update_power_bar(hold_time, false)
		attack_prepared = false
		
	if hud.turn != hud.turns.FIGHT:
		target_sprite.visible = false
		target_sprite.modulate = Color.WHITE

func get_damaged(damage_to_deal):
	await get_tree().create_timer(1).timeout
	damage_particle_label.text = str(-damage_to_deal)
	damage_particle.get_node("particle").emitting = true
	damage_particle.get_node("particle").one_shot = false
	damage_particle.get_node("particle").one_shot = true
	hp -= damage_to_deal
	hp_bar.text = str(hp)
	print(damage_to_deal, ' ', self.name, 'HP dealt!')
	pass
	
func update_power_bar(hold_time, is_visible):
	power_bar.visible = is_visible
	power_bar.value = hold_time

func _physics_process(delta):
	var direction : Vector2
	var speed : int = 2
	
	if hud.turn == hud.turns.MOVE:
		if Input.is_action_pressed("ui_left") and player_id == 1 or Input.is_action_pressed("move_left") and player_id == 2:
			direction = Vector2(-80, 0)
			sprite.animation = "run"
			sprite.flip_h = false
		elif Input.is_action_pressed("ui_right") and player_id == 1 or Input.is_action_pressed("move_right") and player_id == 2:
			direction = Vector2(80, 0)
			sprite.animation = "run"
			sprite.flip_h = true
		else:
			sprite.animation = "stand"
	
	if hud.turn == hud.turns.MOVE:
		if Input.is_action_just_pressed("ui_up") and player_id == 1 or Input.is_action_just_pressed("jump") and player_id == 2:
			linear_velocity += Vector2(0, -500)
		
	move_and_collide(direction * speed * delta)
