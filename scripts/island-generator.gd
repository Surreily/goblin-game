class_name IslandController
extends Node2D

@export var fill_texture: Texture2D
@export var edge_texture: Texture2D
@export var is_water: bool

func _ready() -> void:
	for child in get_children():
		if child is Polygon2D:
			generate_island(child)

func generate_island(polygon_node: Polygon2D) -> void:
	# Update polygon.
	polygon_node.texture = fill_texture
	polygon_node.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

	# Create StaticBody2D node.
	var static_body_node = StaticBody2D.new()
	polygon_node.add_child(static_body_node)
	
	if is_water:
		static_body_node.set_collision_layer_value(2, false)

	# Create CollisionPolygon2D node.
	var collision_polygon_node = CollisionPolygon2D.new()
	collision_polygon_node.polygon = polygon_node.polygon
	static_body_node.add_child(collision_polygon_node)

	# If this is a counterclockwise polygon, reverse its points.
	if Geometry2D.is_polygon_clockwise(polygon_node.polygon):
		var new_polygon: PackedVector2Array = polygon_node.polygon
		new_polygon.reverse()
		polygon_node.polygon = new_polygon

	# Create Line2D node.
	var line_node = Line2D.new()
	line_node.texture = edge_texture
	line_node.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	line_node.texture_mode = Line2D.LINE_TEXTURE_TILE
	line_node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	line_node.width = 16
	line_node.joint_mode = Line2D.LINE_JOINT_SHARP
	line_node.points = PackedVector2Array(polygon_node.polygon)
	line_node.closed = true
	line_node.z_index = 1
	static_body_node.add_child(line_node)
