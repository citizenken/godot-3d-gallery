@tool
extends Node3D

const LOOKAROUND_SPEED = 0.01
var rot_z = 0
var rot_x = 0

func _input(event: InputEvent):
	if event is InputEventMouseMotion \
		and event.button_mask & 1:
		# modify accumulated mouse rotation
		rot_z += event.relative.y * LOOKAROUND_SPEED
		rot_x += event.relative.x * LOOKAROUND_SPEED
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		rotate_object_local(Vector3(0, 0, 1), rot_z) # first rotate in Y
