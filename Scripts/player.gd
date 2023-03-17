extends CharacterBody2D

@export
var tilemap: TileMap

@export
var player_resource: PlayerResource

func _ready():
	var cell_on_map = tilemap.local_to_map(position)
	player_resource.cell = cell_on_map

func _on_mouse_hover_node_cell_clicked(cell: Vector2i):
#	var local_position = tilemap.map_to_local(cell)
#	self.position = local_position - Vector2(8, 8)
#	player_resource.cell = cell
	pass
