extends Sprite2D

var damage : int = 50
var damage_distance_max = 235

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func disappear():
	get_parent().disappear()
	
func _on_area_2d_body_entered(body):
	body.linear_velocity = Vector2(0, -500)
	var explosion_distance = damage_distance_max - body.global_position.distance_to(self.global_position)
	var damage_percentage = (explosion_distance / damage_distance_max)
	var damage_to_deal = snapped(damage * damage_percentage, 1)
	body.get_damaged(damage_to_deal)
	pass
