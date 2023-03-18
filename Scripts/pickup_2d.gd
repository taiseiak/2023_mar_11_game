@tool
class_name Pickup2D
extends Node2D


@export var pickup_resource: PickupResource:
	set(_pickup_resource):
		pickup_resource = _pickup_resource
		$Sprite2D.texture = pickup_resource.pickup_texture


func _convert_to_picked_up_item():
	if has_node("Area2D"):
		get_node("Area2D").queue_free()


func _on_area_2d_body_entered(body):
	if (
		not body is PhysicsBody2D
		# Bitwise AND to check if mask and layer collide.
		or not body.collision_layer & pickup_resource.mask
	):
		pass
	
	var pickup_nodes = body.get_children().filter(
		func(node): return node is PickupHolder)
	if pickup_nodes:
		_convert_to_picked_up_item()
		# We assume that PickupHolder class implements `pick_up`.
		pickup_nodes.front().pick_up(self)
