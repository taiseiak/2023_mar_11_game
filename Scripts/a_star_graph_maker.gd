extends Node

## Creates a graph for the A* path finding algorithm based on a tilemap.
##
## With inputs to tiles that should be used to create a graph, creates a graph
## that can be used to implement a custom version of the A* path finding
## algorithm.


signal node_path_created(node_path: Array[Vector2i])


# Neighbors are sorted by clockwise order from the right.
const CELL_NEIGHBORS_TO_CHECK = [
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
#	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER, 
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
#	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,
#	TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_TOP_SIDE,
#	TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER
]


## The tilemap to generate the graph from.
@export var tilemap: TileMap
# Name of the custom data label that determines if a cell can be included in
# the graph. Must be a `bool` type custom label.
@export var allowed_tiles: String
# The resource to store the graph information.
@export var a_star_graph_resource: AStarGraph
# The value of one G cell away from a cell.
@export var neighbor_g_cell_value: int = 10
# The G value of one diagonal cell away from a cell.
# Approximated with pythagoras value.
@export var diagonal_g_cell_value: int = 14
@export var player_resource: PlayerResource


# Creates a graph.
# Based on A* Pathfinding (E01: algorithm explanation) by Sebastian Lague.
# https://www.youtube.com/watch?v=-L-WgKMFuhE
func _create_graph(
	start_cell: Vector2i,
	end_cell: Vector2i,
	layer: int):
	# Set of nodes to be evaluated
	var nodes_to_be_evaluated_heap = minheap.new()
	nodes_to_be_evaluated_heap.insert(
		{"cell": start_cell,
		"f_cost": 0,
		"parent": null,
		"evaluated": false})
		
	var node_evaluation_dict = {}
	
	# We set the current node to the start just for the first iteration
	var current_node = {
		"cell": start_cell,
		"f_cost": 0,
		"parent": null,
		"evaluated": false}

	# End the loop when we find the target cell or evaluate all cells in 
	while nodes_to_be_evaluated_heap.size > 0:
		current_node = nodes_to_be_evaluated_heap.remove()
		current_node["evaluated"] = true
		node_evaluation_dict[current_node["cell"]] = current_node
		
		if current_node["cell"] == end_cell:
			break
		
		for cell_neighbor in CELL_NEIGHBORS_TO_CHECK:
			var cell_neighbor_position = tilemap.get_neighbor_cell(current_node["cell"], cell_neighbor)
			var neighbor_cell_data = tilemap.get_cell_tile_data(layer, cell_neighbor_position)
			
			if cell_neighbor_position in node_evaluation_dict and node_evaluation_dict[cell_neighbor_position]["evaluated"]:
				continue
				
			if allowed_tiles != null and not neighbor_cell_data.get_custom_data(allowed_tiles):
				continue
				
			var f_cost = _calculate_f_cost(
				cell_neighbor_position,
				current_node["cell"],
				end_cell,
				current_node["f_cost"])
				
			if (cell_neighbor_position not in node_evaluation_dict 
				or f_cost < node_evaluation_dict[cell_neighbor_position]["f_cost"]):
					var new_cell = {
						"cell": cell_neighbor_position,
						"f_cost": f_cost,
						"parent": current_node["cell"],
						"evaluated": false}
					if cell_neighbor_position not in node_evaluation_dict:
						nodes_to_be_evaluated_heap.insert(new_cell)
					node_evaluation_dict[cell_neighbor_position] = new_cell
	
	var path_node = current_node
	var node_path = []
	tilemap.clear_layer(2)
	while path_node["parent"] != null:
		node_path.append(path_node["cell"])
		tilemap.set_cell(2, path_node["cell"], 2, Vector2i(1, 0))
		path_node = node_evaluation_dict[path_node["parent"]]
	node_path.reverse()
	node_path_created.emit(node_path)


func _calculate_f_cost(
	cell: Vector2i,
	starting_cell: Vector2i,
	target_cell: Vector2i,
	f_cost: int = 0):
		var final_f_cost = f_cost
		# If one of the coords is the same, then we are right next to the
		# starting cell.
		if cell.x == starting_cell.x or cell.y == starting_cell.y:
			final_f_cost += neighbor_g_cell_value
		else:
			final_f_cost += diagonal_g_cell_value
		
		var distance_vector = (target_cell - cell).abs()
		# Calculate the smaller distance between rise vs run to see how many
		# diagonals we have to move
		var diagonals_to_move = mini(distance_vector.x, distance_vector.y)
		final_f_cost += diagonals_to_move * diagonal_g_cell_value
		
		var neighbors_to_move = max(distance_vector.x, distance_vector.y) - diagonals_to_move
		final_f_cost += neighbors_to_move * neighbor_g_cell_value
		
		return final_f_cost


func _on_mouse_hover_node_cell_clicked(cell):
	_create_graph(player_resource.cell, cell, 0)
