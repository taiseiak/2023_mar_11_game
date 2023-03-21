extends Node


@export var tilemap: TileMap


var player_turn := false


func _ready():
	assert(tilemap.has_method("highlight_cells"),
			"tilemap must have `highlight_cells` method.")


func _unhandled_input(event):
	if not player_turn:
		return

	if event is InputEventMouseMotion:
		var cell_at_mouse_motion = tilemap.local_to_map(
				tilemap.get_local_mouse_position())
		Events.cell_hovered.emit(cell_at_mouse_motion)
		tilemap.highlight_cells([cell_at_mouse_motion],
				tilemap.SELECTION_LAYER)

	if event.is_action_pressed("select"):
		var cell_at_mouse_motion = tilemap.local_to_map(
				tilemap.get_local_mouse_position())
		Events.cell_selected.emit(cell_at_mouse_motion)


func _on_turn_handler_turn_changed(turn_group):
	player_turn = turn_group == Constants.PLAYER_TURN_GROUP
