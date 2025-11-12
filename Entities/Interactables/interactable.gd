class_name Interactable extends CharacterBody3D

@export_category("Designers")
@export var collision_push_off_velocity: float = 1.0

@export_category("Developers")
@export var floor_rays: Node3D
@export var ability_extension_area: Area3D

@export_category("Sound")
@export var landing_sound: FmodEventEmitter3D

var interactable_extension: Interactable:
	get(): return interactable_extension

var gravity: float: 
	get(): return ProjectSettings.get_setting("physics/3d/default_gravity")

var is_picked_up: bool = false
var is_thrown: bool = false
var is_controlled: bool = false

# throwing
var horizontal_velocity: float
var initial_vertical_velocity: float
var air_time: float

func _ready() -> void:
	for ray in floor_rays.get_children():
		ray.add_exception(self)
	
	ability_extension_area.connect("body_entered", _on_ability_extension_area_entered)
	ability_extension_area.connect("body_exited", _on_ability_extension_area_exited)

func control(new_controlled: bool) -> void:
	is_controlled = new_controlled
	for ray in floor_rays.get_children():
		ray.enabled = new_controlled

func throw(initial_velocity: Vector3) -> void:
	is_thrown = true
	
	horizontal_velocity = initial_velocity.z
	initial_vertical_velocity = initial_velocity.y
	air_time = 0

func pick_up(new_picked_up: bool) -> void:
	is_picked_up = new_picked_up

func get_floor_rays():
	return floor_rays.get_children()

func _physics_process(delta: float) -> void:
	if is_picked_up:
		return

	move_and_slide()
	_handle_collisions()

	if is_thrown:
		if is_on_wall():
			horizontal_velocity = 0
		
		if is_on_floor():
			Common.play_sound(landing_sound)
			is_thrown = false
		else:
			# Physics taken from: https://www.sciencefacts.net/projectile-motion.html
			air_time += delta
			velocity.z = horizontal_velocity
			velocity.y = initial_vertical_velocity - gravity * air_time
	else:
		velocity.z = 0
		velocity.y -= gravity * delta

func _handle_collisions():
	var count = get_slide_collision_count()
	for i in range(count):
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if collider is Interactable:
			if collider.is_controlled:
				velocity.y += collision_push_off_velocity
		if not is_controlled:
			if collider is Player:
				velocity.y += collision_push_off_velocity


# Signals
func _on_ability_extension_area_entered(body: Node3D):
	if is_controlled and body is Interactable:
		interactable_extension = body

func _on_ability_extension_area_exited(body: Node3D):
	if interactable_extension and interactable_extension == body:
		interactable_extension = null
