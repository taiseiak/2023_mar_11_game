extends Node

@export
var tilemap: TileMap

signal cell_clicked(cell: Vector2i)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		tilemap.clear_layer(1)
		var cell_at_mouse_motion = tilemap.local_to_map(tilemap.get_local_mouse_position())
		var cell_data = tilemap.get_cell_tile_data(0, cell_at_mouse_motion)
		if cell_data:
			if cell_data.get_custom_data("Moveable") == true:
				tilemap.set_cell(1, cell_at_mouse_motion, 2, Vector2i(1, 0))
	
	if event.is_action_pressed("select"):
		tilemap.clear_layer(1)
		var cell_at_mouse_motion = tilemap.local_to_map(tilemap.get_local_mouse_position())
		var cell_data = tilemap.get_cell_tile_data(0, cell_at_mouse_motion)
		if cell_data:
			if cell_data.get_custom_data("Moveable") == true:
				tilemap.set_cell(1, cell_at_mouse_motion, 2, Vector2i(1, 0))
				cell_clicked.emit(cell_at_mouse_motion)
