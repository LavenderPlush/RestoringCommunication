class_name Alien extends Player

func _ready():
	super()
	add_to_group("Alien")
	CheckpointManager.set_original_position(self)

func _physics_process(delta: float) -> void:
	if ((can_climb or movement.is_climbing)
		and not ability_active):
		movement.process_climb(can_climb)
	if !movement.is_climbing:
		if !ability_active:
			movement.process_jump()
			movement.process_movement()
		movement.process_gravity(delta)
		if movement.on_floor():
			ability.process_ability()
	move_and_slide()

func get_target_position() -> Vector3:
	if is_instance_valid(ability.transmuted_object):
		return ability.transmuted_object.global_position
	else:
		return self.global_position

func get_controlled_body() -> CharacterBody3D:
	if is_instance_valid(ability.transmuted_object):
		return ability.transmuted_object
	
	return self

func reset_state():
	super()

	if is_instance_valid(ability.transmuted_object):
		ability.untransmute_soul()