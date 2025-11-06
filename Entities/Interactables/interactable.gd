class_name Interactable extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_picked_up: bool = false
var is_thrown: bool = false
var is_controlled: bool = false

# throwing
var horizontal_velocity: float
var initial_vertical_velocity: float
var air_time: float


func control(new_controlled: bool) -> void:
	is_controlled = new_controlled

func throw(initial_velocity: Vector3) -> void:
	is_thrown = true
	
	horizontal_velocity = initial_velocity.z
	initial_vertical_velocity = initial_velocity.y
	air_time = 0

func pick_up(new_picked_up: bool) -> void:
	is_picked_up = new_picked_up

func _physics_process(delta: float) -> void:
	if not (is_picked_up):
		move_and_slide()

	if is_thrown:
		if is_on_wall():
			horizontal_velocity = 0
		
		if is_on_floor():
			is_thrown = false
		else:
			# Physics taken from: https://www.sciencefacts.net/projectile-motion.html
			air_time += delta
			velocity.z = horizontal_velocity
			velocity.y = initial_vertical_velocity - gravity * air_time
	else:
		velocity.z = 0
		velocity.y -= gravity * delta
