@tool
class_name IslandController
extends Node

func _ready() -> void:
	if not Engine.is_editor_hint():
		var collision = CollisionPolygon2D.new()
		collision.polygon = $Polygon.polygon
		add_child(collision)
		
		var points = PackedVector2Array($Polygon.polygon)
		points.append($Polygon.polygon[0])
		$Line.points = points
