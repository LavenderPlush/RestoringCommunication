class_name Interactable extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_picked_up: bool = false
var is_thrown: bool = false
var is_controlled: bool = false

func control(new_controlled: bool) -> void:
	is_controlled = new_controlled

func throw() -> void:
	is_thrown = true

func pick_up(new_picked_up: bool) -> void:
	is_picked_up = new_picked_up

func _physics_process(delta: float) -> void:
	if not (is_picked_up or is_controlled):
		velocity.y -= gravity * delta
		move_and_slide()
	
	if is_thrown:
		if is_on_floor():
			is_thrown = false
	# Manually apply physics here
