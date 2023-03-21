class_name Enemy
extends CharacterBody2D


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
	print(character_resource.turn_group)
	turn_handler.register_character(self, character_resource.turn_group)
	turn_handler.turn_changed.connect(_handle_turn)


func _handle_turn():
	var cell_to_move_to = _player_resource.cell
	var current_cell = tilemap.local_to_map(position)
