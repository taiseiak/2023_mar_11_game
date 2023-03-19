extends Node2D


## Groups that have turns.
@export var turn_groups: Array[StringName] = ["Players", "Enemies"]
## The first turn that the turn handler should start with.
## If empty, will choose the first element in `turn_groups`.
@export var first_turn: StringName


var current_turn: StringName:
	set(_current_turn):
		current_turn = _current_turn
		Events.turn_changed.emit(current_turn)
var turn_group_characters: Dictionary


func _ready():
	if first_turn == null:
		current_turn = turn_groups[0]
	for turn_group in turn_groups:
		turn_group_characters[turn_group] = {}


func register_character(character: Node2D, turn_group: StringName):
	assert(turn_group in turn_groups)
	assert(character.has_signal("turn_ended"))
	
	character.turn_ended.connect(_handle_turn_ended)
	turn_group_characters[turn_group][character] = {"ended_turn": true}


func set_turn(turn_group: StringName):
	_initialize_turn_group(turn_group)
	current_turn = turn_group


func _handle_turn_ended(character: Node2D):
	turn_group_characters[current_turn][character]["ended_turn"] = true
	var characters = turn_group_characters[current_turn].values()
	if (characters.values()
			.map(func(values): return values["ended_turn"])
			.all()):
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
