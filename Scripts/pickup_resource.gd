class_name PickupResource
extends Resource

@export var pickup_texture: Texture2D
## The layers that this resource can be picked up by.
@export_flags_2d_physics var mask: int
@export var x_offset: int = 0
@export var y_offset: int = 0
