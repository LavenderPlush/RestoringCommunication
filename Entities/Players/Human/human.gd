class_name Human extends Player

func _ready():
	super()
	add_to_group("Human")
	CheckpointManager.set_original_position(self)

func _physics_process(delta: float) -> void:
	if ((can_climb or movement.is_climbing)
		and not ability_active):
		movement.process_climb(can_climb)
	if !movement.is_climbing:
		if not weighed_down:
			movement.process_jump()
		movement.process_movement()
		movement.process_gravity(delta)
		ability.process_ability()
	move_and_slide()
	animator.process(delta)
	weighed_down = false

func get_target_position() -> Vector3:
	return self.global_position

func reset_state():
	super()

	if is_instance_valid(ability.held_object):
		ability.force_drop()
