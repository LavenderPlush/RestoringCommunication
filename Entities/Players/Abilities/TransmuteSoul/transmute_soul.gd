extends Ability

@export_category("Developers")
@export var interaction_area: Area3D
@export var movement: Movement
@export var alien_body: CharacterBody3D

@export_category("Sound")
@export var engage_emitter: FmodEventEmitter3D
@export var disengage_emitter: FmodEventEmitter3D

var transmutable_object: Interactable
var transmuted_object: Interactable

func _ready() -> void:
	interaction_area.body_entered.connect(_on_object_entered_area)
	interaction_area.body_exited.connect(_on_object_exited_area)
	
func process_ability() -> void:
	if Input.is_action_just_pressed("ability_transmute_soul"):
		if transmutable_object and not transmuted_object:
			transmute_soul()
			engange()
		elif transmuted_object:
			extend_transmute()

	if Input.is_action_just_pressed("ability_untransmute_soul"):
		if transmuted_object:
			untransmute_soul()
			disengage()
			
func _physics_process(_delta: float) -> void:
	if not transmuted_object:
		transmutable_object = get_closest_interactable(alien_body.global_position, false)

	if transmuted_object and not (transmuted_object.is_picked_up or transmuted_object.is_thrown):
		movement.process_movement()
		movement.process_jump()

func transmute_soul():
	transmuted_object = transmutable_object
	movement.set_body(transmutable_object)
	movement.set_floor_rays(transmutable_object.get_floor_rays())
	transmuted_object.control(true)
	Common.play_sound(engage_emitter)

func untransmute_soul():
	transmuted_object.control(false)
	transmuted_object = null
	Common.play_sound(disengage_emitter)

func extend_transmute():
	if transmuted_object.interactable_extension:
		transmutable_object = transmuted_object.interactable_extension
		untransmute_soul()
		transmute_soul()
