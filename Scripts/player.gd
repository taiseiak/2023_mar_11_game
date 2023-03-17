extends CharacterBody2D

@export
var tilemap: TileMap

@export
var player_resource: PlayerResource

var tween

func _ready():
	var cell_on_map = tilemap.local_to_map(position)
	player_resource.cell = cell_on_map

func _on_a_star_graph_maker_node_path_created(node_path):
	if tween:
		tween.kill()
	tween = create_tween()
	for cell_position in node_path:
		tween.chain().tween_property(self, "position", tilemap.map_to_local(cell_position), 0.2)
		player_resource.cell = cell_position
	
