extends Node

## Creates a graph for the A* path finding algorithm based on a tilemap.
##
## With inputs to tiles that should be used to create a graph, creates a graph
## that can be used to implement a custom version of the A* path finding
## algorithm.

## The tilemap to generate the graph from.
@export
var tilemap: TileMap

# A list of custom data label names that can be used to create the graph. If
# empty, then all tiles will be used to create the graph.
@export
var allowed_tiles: Array[String]

# The resource to store the graph information.
@export
var a_star_graph_resource: AStarGraph

# The value of one G cell away from a cell.
@export
var neighbor_g_cell_value: int = 10

# The G value of one diagonal cell away from a cell.
# Approximated with pythagoras value.
@export
var diagonal_g_cell_balue: int = 14

#var CELL_NEIGHBORS_TO_CHECK = [
#	TileMap.CELL_NEIGHBOR_RIGHT_SIDE,
#	TileMap.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
#	TileMap.CELL_NEIGHBOR_BOTTOM_SIDE,54
#	TileMap.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE
#]

# Creates a graph.
# Based on A* Pathfinding (E01: algorithm explanation) by Sebastian Lague.
# https://www.youtube.com/watch?v=-L-WgKMFuhE
func _create_graph(
	start_cell: Vector2i,
	end_cell: Vector2i,
	layer: int,
	allowed_tiles: Array[String]):
	# See documentation at https://docs.godotengine.org/en/stable/classes/class_tilemap.html
	var cells_in_layer = tilemap.get_used_cells(layer)
	# Set of nodes to be evaluated
	var nodes_to_be_evaluated = minheap.new()
	nodes_to_be_evaluated.insert({"cell": start_cell, "f_cost": 0})
	# Set of nodes already evaluated
	var nodes_already_evaluated = []
	
	var current_cell = Vector2i(0, 0)
	
	# End the loop when we find the target cell or evaluate all cells in 
	while current_cell == end_cell:
		var current_node = nodes_already_evaluated.remove()
		for i in range(0, 15, 1):
			print(tilemap.get_neighbor_cell(current_node["cell"], i))

