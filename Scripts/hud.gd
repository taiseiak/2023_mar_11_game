extends Node


signal turn_animation_finished(turn_group: StringName)


func _ready():
	$TurnLabel.visible = false


func _on_turn_handler_turn_changed(turn_group):
	$TurnLabel.text = turn_group + " turn"
	$TurnLabel.visible = true
	var timer = get_tree().create_timer(2)
	await timer.timeout
	if turn_group == Constants.PLAYER_TURN_GROUP:
		$TurnLabel.text = "Go!"
		timer = get_tree().create_timer(1)
		await timer.timeout
	$TurnLabel.visible = false
	turn_animation_finished.emit(turn_group)


func _on_turn_handler_game_ended(winner_group):
	$TurnLabel.text = winner_group + " won"
	$TurnLabel.visible = true
