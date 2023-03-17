extends Resource
class_name PlayerResource

@export
var cell: Vector2i

func _init(p_cell: Vector2i = Vector2i.ZERO):
	cell = p_cell
