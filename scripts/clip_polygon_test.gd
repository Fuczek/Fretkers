extends Node2D

@onready var empty_polygon = preload("res://area.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var poly_a = polygon_a.polygon
	#poly_a = generate_circle_polygon(50, 20, Vector2(0,0))
	#var poly_b = polygon_b.polygon
	#var chuj = Geometry2D.clip_polygons(poly_b, poly_a)
	
	#var instance = empty_polygon.instantiate()
	#add_child(instance)
	#polygon_a.queue_free()
	#polygon_b.queue_free()
	#instance.get_node("CollisionPolygon2D").polygon = chuj[0]
	#instance.get_node("CollisionPolygon2D2").polygon = chuj[0]
	#print(instance.get_node("CollisionPolygon2D").polygon)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
