class_name PowerGloves extends Ability

@export_category("Designers")
@export var throw_momentum: Vector2

@export_category("Developers")
@export var player: Player
@export var shape_cast: ShapeCast3D
@export var interaction_area: Area3D
@export var holding_position: Marker3D
@export var dropping_position: Marker3D
@export var movement: Movement
@export var collision_timer: Timer
@export var outline: Material

@export_category("Sound")
@export var engage_emitter: FmodEventEmitter3D
@export var disengage_emitter: FmodEventEmitter3D

var object_in_range: Node3D
var held_object: Interactable
var original_collider: CollisionShape3D
var player_held_collider: CollisionShape3D
var player_to_reset: PhysicsBody3D
var box_to_reset: Interactable
var object_mesh: MeshInstance3D

func _ready() -> void:
	interaction_area.body_entered.connect(_object_entered)
	interaction_area.body_exited.connect(_object_exited)
	collision_timer.timeout.connect(_enable_dropped_collision)
	shape_cast.add_exception(player)

func process_ability() -> void:
	if Input.is_action_just_pressed("ability_power_gloves"):
		if object_in_range and not held_object and movement.on_floor():
			engange()
			pick_up()
			Common.play_sound(engage_emitter)
		elif held_object:
			throw()
			Common.play_sound(disengage_emitter)
			disengage()
	elif Input.is_action_just_pressed("ability_power_gloves_drop"):
		if held_object:
			drop()

	if held_object:
		held_object.global_position = holding_position.global_position

#Freezes the box, disables its collider and creates a new collider.
func pick_up():
	held_object = object_in_range
	original_collider = held_object.get_node_or_null("CollisionShape3D")
	if check_box_collide(holding_position.global_position):
		held_object = null
		original_collider = null
		disengage()
		return
	held_object.pick_up(true)

	if original_collider:
		original_collider.disabled = true

	player_held_collider = CollisionShape3D.new()
	player_held_collider.shape = original_collider.shape
	player_held_collider.position = holding_position.position

	get_parent().add_child(player_held_collider)

#Reverses the pickup process, adds an exception to prevent player from being launched and applies force to box.
func throw():
	var momentum = Vector3(0, throw_momentum.y, throw_momentum.x)
	if movement.is_facing_left:
		momentum.z *= -1

	player_held_collider.queue_free()
	original_collider.disabled = false

	held_object.add_collision_exception_with(player)
	held_object.pick_up(false)
	held_object.throw(momentum)
	player_to_reset = player
	box_to_reset = held_object
	collision_timer.start()
	held_object = null
	original_collider = null
	player_held_collider = null

func drop():
	var new_pos = dropping_position.global_position
	
	#maybe not the best way of handling this
	if movement.is_facing_left:
		new_pos.z -= 2 * (dropping_position.global_position.z - get_parent().global_position.z)
	
	if check_box_collide(new_pos):
		return
	
	player_held_collider.queue_free()
	original_collider.disabled = false
	
	# Avoid colliding with player
	held_object.add_collision_exception_with(player)
	box_to_reset = held_object
	collision_timer.start()
	
	held_object.global_position = new_pos
	held_object.pick_up(false)
	held_object = null
	original_collider = null
	player_held_collider = null
	disengage()

func force_drop():
	if !is_instance_valid(held_object): return

	if is_instance_valid(player_held_collider):
		player_held_collider.queue_free()

	if is_instance_valid(original_collider):
		original_collider.disabled = false

	if is_instance_valid(box_to_reset):
		box_to_reset.remove_collision_exception_with(player)
		
	held_object.pick_up(false)
	held_object = null
	original_collider = null
	player_held_collider = null
	box_to_reset = null

	disengage()

## Requires a global position
func check_box_collide(target_position: Vector3):
	var ray_target = target_position - player.global_position
	shape_cast.global_position = player.global_position
	shape_cast.add_exception(held_object)
	# Avoid collision with floor
	shape_cast.global_position.y += 0.2
	shape_cast.shape = original_collider.shape
	shape_cast.target_position = ray_target
	shape_cast.force_shapecast_update()
	shape_cast.remove_exception(held_object)
	return shape_cast.is_colliding()

# Signals
func _object_entered(object: Node3D):
	if object is Interactable:
		object_in_range = object
		object_mesh = object_in_range.get_node("MeshInstance3D")
		object_mesh.material_overlay = outline

func _object_exited(object: Node3D):
	if object == object_in_range:
		object_mesh.material_overlay = null
		object_in_range = null

func _enable_dropped_collision():
	box_to_reset.remove_collision_exception_with(player)
	box_to_reset = null
