extends Ability

@export_category("Developers")
@export var interaction_area: Area3D
@export var movement: Movement
@export var alien_body: CharacterBody3D

var transmutable_object: Interactable
var transmuted_object: Interactable

func _ready() -> void:
	interaction_area.body_entered.connect(_object_entered)
	interaction_area.body_exited.connect(_object_exited)
	
func process_ability() -> void:
	if Input.is_action_just_pressed("ability_transmute_soul"):
		if transmutable_object and not transmuted_object:
			transmute_soul()
			engange()

	if Input.is_action_just_pressed("ability_untransmute_soul"):
		if transmuted_object:
			untransmute_soul()
			disengage()
			
func _physics_process(_delta: float) -> void:
	if transmuted_object and not (transmuted_object.is_picked_up or transmuted_object.is_thrown):
		movement.process_movement()
		movement.process_jump()

func transmute_soul():
	transmuted_object = transmutable_object
	movement.set_body(transmutable_object)
	movement.set_floor_rays(transmutable_object.get_floor_rays())
	transmuted_object.control(true)

func untransmute_soul():
	transmuted_object.control(false)
	transmuted_object = null

# Signals
func _object_entered(object: Node3D):
	if object is Interactable:
		transmutable_object = object

func _object_exited(object: Node3D):
	if object == transmutable_object:
		transmutable_object = null
