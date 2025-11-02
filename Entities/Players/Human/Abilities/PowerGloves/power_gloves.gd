extends Node

@export_category("Designers")
@export var throw_momentum: Vector2

@export_category("Developers")
@export var interaction_area: Area3D
@export var holding_position: Marker3D
@export var dropping_position: Marker3D

var object_in_range: Node3D
var held_object: RigidBody3D

func _ready() -> void:
	interaction_area.body_entered.connect(_object_entered)
	interaction_area.body_exited.connect(_object_exited)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ability_power_gloves"):
		if object_in_range and not held_object:
			pick_up()
		elif held_object:
			throw()
	elif event.is_action_pressed("ability_power_gloves_drop"):
		if held_object:
			drop()

func _process(_delta: float) -> void:
	if held_object:
		held_object.global_position = holding_position.global_position


func pick_up():
	held_object = object_in_range
	held_object.freeze = true

func throw():
	held_object.freeze = false
	held_object.apply_central_force(Vector3(0, throw_momentum.y, throw_momentum.x))
	held_object = null

func drop():
	held_object.global_position = dropping_position.global_position
	held_object.freeze = false
	held_object = null

# Signals
func _object_entered(object: Node3D):
	if object.get_parent().is_in_group("Pickupable"):
		object_in_range = object

func _object_exited(object: Node3D):
	if object == object_in_range:
		object_in_range = null
