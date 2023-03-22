class_name TurnHandler
extends Node2D


signal turn_changed(turn_group: StringName)
signal game_ended(winner_group: StringName)


## Groups that have turns.
@export var turn_groups: Array[StringName] = ["Players", "Enemies"]
## The first turn that the turn handler should start with.
## If empty, will choose the first element in `turn_groups`.
@export var first_turn: StringName


var current_turn: StringName:
	set(_current_turn):
		current_turn = _current_turn
		Events.turn_changed.emit(current_turn)
		turn_changed.emit(current_turn)
var turn_group_characters: Dictionary


func _ready():
	if first_turn == null:
		current_turn = turn_groups[0]
	for turn_group in turn_groups:
		turn_group_characters[turn_group] = {}


func register_character(character: Node2D, turn_group: StringName):
	assert(turn_group in turn_groups)
	assert(character.has_signal("turn_ended"))
	assert(character.turn_ended)
	
	character.turn_ended.connect(_handle_turn_ended)
	turn_group_characters[turn_group][character] = {"ended_turn": true}


func set_turn(turn_group: StringName):
	_initialize_turn_group(turn_group)
	current_turn = turn_group


func _handle_turn_ended(character: Node2D):
	turn_group_characters[current_turn][character]["ended_turn"] = true
	var characters = turn_group_characters[current_turn].values()
	if (characters.map(func(values): return values["ended_turn"])
			.all(func(value): return value)):
		_go_next_turn()


func _go_next_turn():
	var turn_index = turn_groups.find(current_turn)
	var next_turn = (
		turn_groups[turn_index + 1]
		if turn_index + 1 < turn_groups.size() 
		else turn_groups[0])
	_initialize_turn_group(next_turn)
	current_turn = next_turn


func _initialize_turn_group(turn_group: StringName):
	var characters_to_initialize = turn_group_characters[turn_group]
	for character in characters_to_initialize:
		if not character.is_inside_tree():
			characters_to_initialize.erase(character)
		characters_to_initialize[character]["ended_turn"] = false


func _on_enemy_attacked_player():
	game_ended.emit("Enemies")
	queue_free()


func _on_player_attacked_enemy(cell_position):
	game_ended.emit(Constants.PLAYER_TURN_GROUP)
	queue_free()
