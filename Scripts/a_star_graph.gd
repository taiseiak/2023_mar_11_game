extends Resource
class_name AStarGraph


## Nodes in the graph. They correspond to the center of the tile in a 16x16
## tile tilemap (So the top left hand corner of the 9th pixels).
@export
var nodes: Array[Vector2i] = []
