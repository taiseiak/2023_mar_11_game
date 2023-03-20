extends Node2D


func _ready():
	$TurnHandler.register_character($Player, "Players")
	$TurnHandler.set_turn("Players")
