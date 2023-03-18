@tool
extends CharacterBody2D

@export
var tilemap: TileMap

@export
var player_resource: PlayerResource

var tween: Tween

func _ready():
	var cell_on_map = tilemap.local_to_map(position)
	player_resource.cell = cell_on_map

func _on_a_star_graph_maker_node_path_created(node_path):
	if node_path.size() <= 0:
		return

	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)

	for cell_position in node_path:
		if tween:
			tween.kill()
		tween = create_tween()

		var target_position = tilemap.map_to_local(cell_position)
		tween.tween_callback(func():
				if target_position.x < position.x:
					scale.x = -1
				elif target_position.x > position.x:
					scale.x = 1
				)
		tween.tween_property(self, "position", target_position, 0.2)

		player_resource.cell = cell_position

		$AsepriteAnimationPlayer.play("Walk")
		await tween.finished

	$AsepriteAnimationPlayer.play("Attack")
	await $AsepriteAnimationPlayer.animation_finished
	$AsepriteAnimationPlayer.play("Idle")
