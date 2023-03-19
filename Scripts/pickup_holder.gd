class_name PickupHolder
extends Node2D

func pick_up(pickup_2d: Pickup2D):
	pickup_2d.get_parent().call_deferred("remove_child", pickup_2d)
	call_deferred("add_child", pickup_2d)
	pickup_2d.position = position + Vector2(
			pickup_2d.pickup_resource.x_offset,
			pickup_2d.pickup_resource.y_offset)
