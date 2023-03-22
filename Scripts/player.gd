@tool
extends CharacterBody2D


signal turn_ended(character: Node)
signal attacked_enemy(cell_position: Vector2i)


@export var tilemap: HighlightTileMap
@export var player_resource: PlayerResource
## The maximum number of actions the character has.
##
## Moving 1 cell = 1 action
## Attacking once = 1 action
@export var max_actions: int = 5


var _tween: Tween
var _is_my_turn: bool = false
var _actions: int = 0
var _path_taking: Array


func _ready():
	_connect_highlight_signals()
	var cell_on_map = tilemap.local_to_map(position)
	player_resource.cell = cell_on_map


func _set_my_turn():
	_is_my_turn = true
	_actions = max_actions
	_connect_highlight_signals()


func _handle_cell_selection(cell: Vector2i):
	_disconnect_highlight_signals()
	_move_to_cell(cell)


func _move_to_cell(cell: Vector2i):
	_disconnect_highlight_signals()

	if not _is_my_turn:
		return

	if _actions <= 0:
		return

	_highlight_path_to_cell(cell)
	var node_path = $AStarGraphMaker.create_graph(player_resource.cell, cell, 
				Constants.MOVEABLE_LAYER)

	var enemies = get_tree().get_nodes_in_group("Enemies")

	if node_path.size() <= 0:
		return

	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(
			Tween.TRANS_LINEAR)

	for cell_position in node_path:
		if _tween:
			_tween.kill()
		_tween = create_tween()

		var target_position = tilemap.map_to_local(cell_position)

		_tween.tween_callback(func():
				if target_position.x < position.x:
					scale.x = -1
				elif target_position.x > position.x:
					scale.x = 1
				)

		if enemies.any(
				func(node):
					var node_cell = tilemap.local_to_map(node.position)
					return node_cell == cell_position):
			$AsepriteAnimationPlayer.play("Attack")
			await $AsepriteAnimationPlayer.animation_finished
			attacked_enemy.emit(target_position)
			break
			
		_tween.tween_property(self, "position", target_position, 0.2)

		player_resource.cell = cell_position

		$AsepriteAnimationPlayer.play("Walk")
		await _tween.finished

		_actions -= 1
		if _actions <= 0:
			turn_ended.emit(self)
			tilemap.clear_highlight_cells()
			break

	$AsepriteAnimationPlayer.play("Idle")

	if _actions > 0:
		_connect_highlight_signals()


func _highlight_path_to_cell(cell: Vector2i):
	var layer = tilemap.PATH_HIGHLIGHT_LAYER
	if _actions <= 0:
		return
	var cell_data = tilemap.get_cell_tile_data(tilemap.DATA_LAYER, cell)
	if (cell_data
		and cell_data.get_custom_data(
				tilemap.ALLOWED_CUSTOM_DATA_LAYER) == true):
		var node_path = $AStarGraphMaker.create_graph(player_resource.cell, cell, 
				Constants.MOVEABLE_LAYER)
		var max_path_index = mini(_actions, node_path.size())
		_path_taking = node_path.slice(0, max_path_index)
		tilemap.highlight_cells([player_resource.cell] + node_path.slice(0,
				max_path_index), layer)


func _on_hud_turn_animation_finished(turn_group):
	if turn_group == "Players":
		_set_my_turn()


func _on_turn_handler_game_ended(winner_group):
	if winner_group == "Enemies":
		queue_free()
	else:
		_disconnect_highlight_signals()


func _connect_highlight_signals():
	Events.cell_hovered.connect(_highlight_path_to_cell)
	Events.cell_selected.connect(_move_to_cell)


func _disconnect_highlight_signals():
	if Events.cell_hovered.is_connected(_highlight_path_to_cell):
		Events.cell_hovered.disconnect(_highlight_path_to_cell)
	if Events.cell_selected.is_connected(_move_to_cell):
		Events.cell_selected.disconnect(_move_to_cell)
