extends Node

@export_category("Designers")
@export var throw_momentum: Vector2

@export_category("Developers")
@export var interaction_area: Area3D
@export var holding_position: Marker3D
@export var dropping_position: Marker3D
@export var movement: PlayerMovement
@export var collision_timer: Timer

var object_in_range: Node3D
var held_object: RigidBody3D
var original_collider: CollisionShape3D
var player_held_collider: CollisionShape3D
var player_to_reset: PhysicsBody3D
var box_to_reset: RigidBody3D

func _ready() -> void:
	interaction_area.body_entered.connect(_object_entered)
	interaction_area.body_exited.connect(_object_exited)
	collision_timer.timeout.connect(_enable_dropped_collision)

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

#Freezes the box, disables its collider and creates a new collider.
func pick_up():
	held_object = object_in_range
	held_object.freeze = true
	original_collider = held_object.get_node_or_null("CollisionShape3D")

	if original_collider:
		original_collider.disabled = true

	player_held_collider = CollisionShape3D.new()
	player_held_collider.shape = original_collider.shape
	player_held_collider.position = holding_position.position

	get_parent().add_child(player_held_collider)

#Reverses the pickup process, adds an exception to prevent player from being launched and applies force to box.
func throw():
	var momentum = Vector3(0, throw_momentum.y, throw_momentum.x)
	if movement.is_facing_left:
		momentum.z *= -1

	player_held_collider.queue_free()
	original_collider.disabled = false

	var player = get_parent()

	held_object.add_collision_exception_with(player)
	held_object.freeze = false
	held_object.apply_central_force(momentum)
	player_to_reset = player
	box_to_reset = held_object
	collision_timer.start()
	held_object = null
	original_collider = null
	player_held_collider = null

func drop():
	var new_pos = dropping_position.global_position
	
	#maybe not the best way of handling this
	if movement.is_facing_left:
		new_pos.z -= 2 * (dropping_position.global_position.z - get_parent().global_position.z)
	
	player_held_collider.queue_free()
	original_collider.disabled = false
	held_object.global_position = new_pos
	held_object.freeze = false
	held_object = null
	original_collider = null
	player_held_collider = null

# Signals
func _object_entered(object: Node3D):
	if object.get_parent().is_in_group("Pickupable"):
		object_in_range = object

func _object_exited(object: Node3D):
	if object == object_in_range:
		object_in_range = null

func _enable_dropped_collision():
	box_to_reset.remove_collision_exception_with(player_to_reset)

	player_to_reset = null
	box_to_reset = null
