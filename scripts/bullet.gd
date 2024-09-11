extends RigidBody2D

@onready var explosion : PackedScene = preload("res://scenes/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func explode_on_hit():
	var explosion_instance = explosion.instantiate()
	$CollisionShape2D.set_deferred("disabled", true)
	set_gravity_scale(0)
	call_deferred("add_child", explosion_instance)

func disappear():
	queue_free()
