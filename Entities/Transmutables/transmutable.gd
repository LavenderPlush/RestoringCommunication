extends Node3D
class_name Transmutable

@export var rigid_body: RigidBody3D:
	get:
		return rigid_body

var transmute_controller: TransmuteController:
	set(body):
		transmute_controller = body
	get:
		return transmute_controller
