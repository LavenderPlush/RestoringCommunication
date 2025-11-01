extends Node

@export_category("Developers")
@export var interaction_area: Area3D
@export var movement: PlayerMovement
@export var alien_body: CharacterBody3D

var transmutable_object: Transmutable
var active_transmute: Transmutable

func _ready() -> void:
	interaction_area.body_entered.connect(_object_entered)
	interaction_area.body_exited.connect(_object_exited)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ability_transmute_soul"):
		if transmutable_object and not active_transmute:
			transmute_soul()
		elif active_transmute:
			untransmute_soul()

func transmute_soul():
	active_transmute = transmutable_object
	movement.controls_locked = true
	active_transmute.transmute()

func untransmute_soul():
	movement.controls_locked = false
	active_transmute.release()
	active_transmute = null

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
