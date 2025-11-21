class_name Interactable extends CharacterBody3D

@export_category("Designers")
@export var collision_push_off_velocity: float = 1.0
##This Object will keep resetting until Players reach this Checkpoint ID. Keep at -1 to always reset.
@export var reset_until_checkpoint_id: int = -1
@export var human_outline: Material
@export var alien_outline: Material
@export var together_outline: Material

@export_category("Developers")
@export var floor_rays: Node3D
@export var ability_extension_area: Area3D

@export_category("Sound")
@export var landing_sound: FmodEventEmitter3D

@onready var mesh: MeshInstance3D = $Mesh/Cube

var initial_transform: Transform3D

var interactable_extension: Interactable:
	get(): return interactable_extension

var gravity: float: 
	get(): return ProjectSettings.get_setting("physics/3d/default_gravity")

var is_picked_up: bool = false
var is_thrown: bool = false:
	get(): return is_thrown
var is_controlled: bool = false
var targeted_by_human: bool = false
var targeted_by_alien: bool = false

# throwing
var horizontal_velocity: float
var initial_vertical_velocity: float
var air_time: float

func _ready() -> void:
	add_to_group("resettable")

	initial_transform = self.global_transform

	for ray in floor_rays.get_children():
		ray.add_exception(self)
	
	ability_extension_area.connect("body_entered", _on_ability_extension_area_entered)
	ability_extension_area.connect("body_exited", _on_ability_extension_area_exited)

func control(new_controlled: bool) -> void:
	is_controlled = new_controlled

	for ray in floor_rays.get_children():
		ray.enabled = new_controlled

	_update_outline()

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
			var collision = get_last_slide_collision()
			if not collision.get_collider().is_in_group("Destructable"):
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
	if is_controlled: return
	var count = get_slide_collision_count()
	for i in range(count):
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if collider is Interactable:
			if collider.is_controlled:
				velocity.y += collision_push_off_velocity
		if collider is Player:
			if collider.global_position.y > global_position.y:
				return
			velocity.y += collision_push_off_velocity

func _update_outline():
	mesh.material_overlay = null

	var alien_active = targeted_by_alien or is_controlled

	if targeted_by_human and alien_active:
		mesh.material_overlay = together_outline
	elif targeted_by_human:
		mesh.material_overlay = human_outline
	elif alien_active:
		mesh.material_overlay = alien_outline

func set_targeted(is_human: bool, state: bool) -> void:
	if is_human:
		targeted_by_human = state
	else:
		targeted_by_alien = state
	
	_update_outline()

func reset_state():
	global_transform = initial_transform
	velocity = Vector3.ZERO
	air_time = 0
	horizontal_velocity = 0
	initial_vertical_velocity = 0
	is_picked_up = false
	is_thrown = false

	if is_controlled:
		control(false)

# Signals
func _on_ability_extension_area_entered(body: Node3D):
	if is_controlled and body is Interactable:
		interactable_extension = body

func _on_ability_extension_area_exited(body: Node3D):
	if interactable_extension and interactable_extension == body:
		interactable_extension = null
