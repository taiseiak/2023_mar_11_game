extends Node


@export var tilemap: TileMap


func _ready():
	assert(tilemap.has_method("highlight_cells"),
			"tilemap must have `highlight_cells` method.")


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var cell_at_mouse_motion = tilemap.local_to_map(
				tilemap.get_local_mouse_position())
		var temp = [cell_at_mouse_motion]
		tilemap.highlight_cells([cell_at_mouse_motion])

	if event.is_action_pressed("select"):
		var cell_at_mouse_motion = tilemap.local_to_map(
				tilemap.get_local_mouse_position())
		Events.cell_selected.emit(cell_at_mouse_motion)
