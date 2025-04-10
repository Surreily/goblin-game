class_name WaterBuilder
extends Node2D

@export var fill_texture: Texture2D
@export var edge_texture: Texture2D
@export var player: PlayerController

var player_collision: CollisionShape2D

func _ready() -> void:
	player_collision = player.find_child("Collision Shape")
	
	for child in get_children():
		if child is Polygon2D:
			_build_water(child)

func _build_water(old_polygon_node: Polygon2D) -> void:
	# Get and prepare points from the current polygon node.
	var points: PackedVector2Array = _prepare_polygon_points(old_polygon_node)
	
	# Delete the current polygon node.
	old_polygon_node.queue_free()
	
	# Create new nodes.
	var area_node: Area2D = _create_area_node()
	# var static_body_node: StaticBody2D = _create_static_body_node()
	var collision_polygon_node: CollisionPolygon2D = _create_collision_polygon_node(points)
	var polygon_node: Polygon2D = _create_polygon_node(points)
	var path_node: Line2D = _create_line_node(points)
	
	# Add them to the object tree.
	add_child(area_node)
	# add_child(static_body_node)
	area_node.add_child(collision_polygon_node)
	area_node.add_child(polygon_node)
	area_node.add_child(path_node)

func _prepare_polygon_points(polygon_node: Polygon2D) -> PackedVector2Array:
	var points: PackedVector2Array = []
	
	# Get the global position of each polygon point.
	for polygon_node_point in polygon_node.polygon:
		points.append(polygon_node.to_global(polygon_node_point))

	# If the polygon is counterclockwise, reverse it.
	if Geometry2D.is_polygon_clockwise(points):
		points.reverse()

	return points

func _create_area_node():
	var node = Area2D.new()
	
	node.body_entered.connect(_on_area_node_body_entered)
	node.body_exited.connect(_on_area_node_body_exited)

	return node
	
func _on_area_node_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		body.is_in_water = true

func _on_area_node_body_exited(body: Node2D) -> void:
	if body is PlayerController:
		body.is_in_water = false

func _create_static_body_node():
	var node = StaticBody2D.new()

	return node

func _create_polygon_node(points: PackedVector2Array) -> Polygon2D:
	var node = Polygon2D.new()

	node.polygon = points
	node.texture = fill_texture

	return node

func _create_collision_polygon_node(points: PackedVector2Array) -> CollisionPolygon2D:
	var node = CollisionPolygon2D.new()

	node.polygon = points

	return node

func _create_line_node(points: PackedVector2Array) -> Line2D:
	var node = Line2D.new()

	node.texture = edge_texture
	node.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	node.texture_mode = Line2D.LINE_TEXTURE_TILE
	node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	node.width = 16
	node.joint_mode = Line2D.LINE_JOINT_SHARP
	node.points = points
	node.closed = true
	node.z_index = 1

	return node
