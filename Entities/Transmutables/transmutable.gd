extends Node3D
class_name Transmutable

@export var rigid_body: RigidBody3D:
	get:
		return rigid_body

var transmute_controller: TransmuteController:
	set(value):
		transmute_controller = value
	get:
		return transmute_controller
