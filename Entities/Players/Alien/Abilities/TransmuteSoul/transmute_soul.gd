extends Node

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
	movement.player_body = active_object.character_body

func make_transmutable(transmutable: Transmutable):
	# Create character body
	var character_body = CharacterBody3D.new()
	character_body.global_transform = transmutable.rigid_body.global_transform
	transmutable.add_child(character_body)
	transmutable.character_body = character_body
	
	# Reparent meshes and collision shape
	Common.reparent_children(transmutable.rigid_body, character_body)
	
	# Disable rigid body
	transmutable.rigid_body.freeze = true

func untransmute_soul():
	movement.player_body = alien_body
	reset_transmutable(active_object)
	
func reset_transmutable(transmutable: Transmutable):
	Common.reparent_children(transmutable.character_body, transmutable.rigid_body)
	transmutable.character_body.queue_free()
	transmutable.character_body = null
	transmutable.rigid_body.freeze = false

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
