extends Transmutable

@export var rigid_body: RigidBody3D
@export var control_scheme: String = "alien"

# Movement script
const MOVEMENT = preload("uid://bkkcqtuj5t1cq")

var player_controller: PlayerMovement
var character_body: CharacterBody3D

func transmute() -> void:
	character_body = CharacterBody3D.new()
	add_child(character_body)
	character_body.global_transform = rigid_body.global_transform
	
	player_controller = MOVEMENT.instantiate()
	player_controller.player_prefix = control_scheme
	player_controller.set("player_body", character_body)
	character_body.add_child(player_controller)
	
	# Reparent meshes and collision shape
	Common.reparent_children(rigid_body, character_body)
	
	# Disable rigid body
	rigid_body.freeze = true
	
func release() -> void:
	player_controller.queue_free()
	player_controller = null
	
	# Reparent meshes and collision shape
	Common.reparent_children(character_body, rigid_body)
	
	# Remove character body
	character_body.queue_free()
	
	# Enable rigid body
	rigid_body.freeze = false
