class_name Enemy
extends CharacterBody2D


signal turn_ended(node: Node2D)
signal attacked_player


@export var character_resource: CharacterResource
@export var turn_handler: TurnHandler

@export_category("AStarGraphMaker2D exports")
## The tilemap to generate the graph from.
@export var tilemap: HighlightTileMap
## Name of the custom data label that determines if a cell can be included in
## the graph. Must be a `bool` type custom label.
@export var allowed_tiles: String
## Neighbors are sorted by clockwise order from the right.
@export var cell_neighbors_to_check: Array[TileSet.CellNeighbor] = [
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
#	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER, 
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
#	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,
#	TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_TOP_SIDE,
#	TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER
]


@onready var _player_resource: PlayerResource = Constants.PLAYER_RESOURCE
@onready var _a_star_graph_maker: AStarGraphMaker2D = $AStarGraphMaker2D


func _ready():
	_a_star_graph_maker.tilemap = tilemap
	_a_star_graph_maker.allowed_tiles = allowed_tiles
	_a_star_graph_maker.cell_neighbors_to_check = cell_neighbors_to_check
	turn_handler.register_character(self, character_resource.turn_group)


func _handle_turn(turn_group: StringName):
	if turn_group == character_resource.turn_group:
		var cell_to_move_to = _player_resource.cell
		var current_cell = tilemap.local_to_map(position)
		var node_graph = _a_star_graph_maker.create_graph(current_cell,
				_player_resource.cell, tilemap.DATA_LAYER)
		
		var tween
		
		for i in range(character_resource.max_actions):
			var cell_position = node_graph[i]
			
			if cell_position == _player_resource.cell:
				$AnimationPlayer.play("Attack")
				await $AnimationPlayer.animation_finished
				attacked_player.emit()
				$AnimationPlayer.play("Idle")
				return

			if tween:
				tween.kill()
			tween = create_tween()

			var target_position = tilemap.map_to_local(cell_position)
			tween.tween_callback(
					func():
						if target_position.x < position.x:
							scale.x = -1
						elif target_position.x > position.x:
							scale.x = 1)
							
			tween.tween_property(self, "position", target_position, 0.2)

			$AnimationPlayer.play("Walk")
			await tween.finished

		$AnimationPlayer.play("Idle")
		turn_ended.emit(self)


func _on_hud_turn_animation_finished(turn_group):
	_handle_turn(turn_group)


func _on_player_attacked_enemy(cell_position):
	queue_free()
