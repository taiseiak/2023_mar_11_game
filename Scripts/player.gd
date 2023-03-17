extends CharacterBody2D

@export
var tilemap: TileMap

@export
var player_resource: PlayerResource

func _ready():
	var cell_on_map = tilemap.local_to_map(position)
	player_resource.cell = cell_on_map
