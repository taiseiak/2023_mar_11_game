extends CharacterBody2D

@export_category("AStarGraphMaker2D exports")
## The tilemap to generate the graph from.
@export var tilemap: TileMap
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

func _ready():
	$AStarGraphMaker2D.tilemap = tilemap
	$AStarGraphMaker2D.allowed_tiles = allowed_tiles
	$AStarGraphMaker2D.cell_neighbors_to_check = cell_neighbors_to_check
