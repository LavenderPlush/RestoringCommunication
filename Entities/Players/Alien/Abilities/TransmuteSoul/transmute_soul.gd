extends Node
const TRANSMUTE_CONTROLLER = preload("uid://bhqmr26arldx3")

@export_category("Developers")
@export var interaction_area: Area3D
@export var movement: PlayerMovement
@export var alien_body: CharacterBody3D

var transmutable_object: Transmutable
var active_object: Transmutable

func _ready() -> void:
	interaction_area.body_entered.connect(_object_entered)
	interaction_area.body_exited.connect(_object_exited)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ability_transmute_soul"):
		if transmutable_object and not active_object:
			transmute_soul()
		elif active_object:
			untransmute_soul()

func transmute_soul():
	active_object = transmutable_object
	make_transmutable(active_object)
	movement.controls_locked = true

func make_transmutable(transmutable: Transmutable):
	# Create character body
	var transmute_controller = TRANSMUTE_CONTROLLER.instantiate()
	transmute_controller.global_transform = transmutable.rigid_body.global_transform
	transmutable.add_child(transmute_controller)
	transmutable.transmute_controller = transmute_controller
	
	# Reparent meshes and collision shape
	Common.reparent_children(transmutable.rigid_body, transmute_controller)
	
	# Disable rigid body
	transmutable.rigid_body.freeze = true

func untransmute_soul():
	movement.controls_locked = false
	reset_transmutable(active_object)
	active_object = null
	
func reset_transmutable(transmutable: Transmutable):
	Common.reparent_children(transmutable.transmute_controller, transmutable.rigid_body)
	transmutable.transmute_controller.release()
	transmutable.rigid_body.freeze = false
	transmutable.rigid_body.linear_velocity = transmutable.transmute_controller.get_real_velocity()
	transmutable.transmute_controller.queue_free()
	transmutable.transmute_controller = null

# Signals
func _object_entered(object: Node3D):
	var object_root = object.get_parent()
	if object_root is Transmutable:
		transmutable_object = object_root

func _object_exited(object: Node3D):
	if not transmutable_object:
		return
	var object_root = object.get_parent()
	if object_root == transmutable_object:
		transmutable_object = null
