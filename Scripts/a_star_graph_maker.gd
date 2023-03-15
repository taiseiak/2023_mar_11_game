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

func _create_graph():
	pass
