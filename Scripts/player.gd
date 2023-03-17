extends CharacterBody2D

@export
var tilemap: TileMap

func _on_mouse_hover_node_cell_clicked(cell: Vector2i):
	var local_position = tilemap.map_to_local(cell)
	print(local_position)
	self.position = local_position - Vector2(8, 8)
