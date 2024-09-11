extends StaticBody2D

@onready var area : Node = $Area2D2
@onready var empty_polygon = preload("res://scenes/area.tscn")
@onready var polygon_texture = $Polygon2D
@onready var background_polygon_texture = $Polygon2D
@onready var polygon_start = $CollisionPolygonStatic.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	print(polygon_start)
	polygon_texture.call_deferred("set_polygon", polygon_start)
	if background_polygon_texture:
		background_polygon_texture.call_deferred("set_polygon", polygon_start)
	#if polygon_start.size() > 0:
	#	polygon_texture.call_deferred("set_polygon", polygon_start[1])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("bullet"):
		body.explode_on_hit()
		make_hole(body.global_position)
		
func generate_circle_polygon(radius: float, num_sides: int, position: Vector2) -> PackedVector2Array:
	var angle_delta: float = (PI * 2) / num_sides
	var vector: Vector2 = Vector2(radius, 0)
	var polygon : PackedVector2Array

	for _i in num_sides:
		polygon.append(vector + position)
		vector = vector.rotated(angle_delta)

	return polygon

func make_hole(hole_pos):
	#print(hole_pos)
	var hole = generate_circle_polygon(75, 25, hole_pos)
	
	var polygon_a = $Area2D2/CollisionPolygonArea
	var polygon_static = $CollisionPolygonStatic
	var polygon_b = hole
	
	var poly_a = polygon_a.polygon
	var new_polygon = Geometry2D.clip_polygons(poly_a, polygon_b)
	
	#print(new_polygon[0])
	#print(new_polygon)
	if new_polygon.size() > 0:
		polygon_a.call_deferred("set_polygon", new_polygon[0])
		polygon_static.call_deferred("set_polygon", new_polygon[0])
		polygon_texture.call_deferred("set_polygon", new_polygon[0])
		
	else:
		polygon_a.set_polygon([])
		polygon_static.set_polygon([])
		polygon_texture.set_polygon([])
	
	if new_polygon.size() > 1:
		var instance = empty_polygon.instantiate()
		instance.get_node("CollisionPolygonStatic").call_deferred("set_polygon", new_polygon[1])
		instance.get_node("Area2D2/CollisionPolygonArea").call_deferred("set_polygon", new_polygon[1])
		instance.get_node("Polygon2D").call_deferred("set_polygon", new_polygon[1])
		#polygon_texture.call_deferred("set_polygon", new_polygon[1])
		
		get_parent().add_child(instance)
	
	
	
	#poly_a = generate_circle_polygon(50, 20, Vector2(0,0))
	#var poly_b = polygon_b.polygon
	#var chuj = Geometry2D.clip_polygons(poly_b, poly_a)
	
	#var instance = empty_polygon.instantiate()
	#instance.get_node("CollisionPolygonStatic").polygon = new_polygon[0]
	#get_parent().add_child(instance)
	
	#polygon_a.queue_free()
	#polygon_b.queue_free()
	#instance.get_node("CollisionPolygon2D").polygon = chuj[0]
	#instance.get_node("CollisionPolygon2D2").polygon = chuj[0]
	#print(instance.get_node("CollisionPolygon2D").polygon)

