extends Player

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("human_move_left") or
		event.is_action_pressed("human_move_right")):
		if current_state == State.IDLE:
			set_state(State.WALKING)
	if (event.is_action_pressed("human_jump")):
		if current_state != State.CLIMBING:
			set_state(State.JUMPING)

func _physics_process(_delta: float) -> void:
	if current_state not in [State.CLIMBING, State.JUMPING]:
		if Input.is_action_just_pressed("human_jump"):
			pass

func can_walk():
	pass

func can_jump():
	pass
