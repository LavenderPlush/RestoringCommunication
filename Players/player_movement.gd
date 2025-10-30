extends CharacterBody3D

enum PlayerType { Human, Alien }

@export var player_type: PlayerType = PlayerType.Human
@export var speed: float = 5
@export var jump_velocity: float = 8.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player_prefix: String

func _ready() -> void:
    if player_type == PlayerType.Human:
        player_prefix = "human"
    elif player_type == PlayerType.Alien:
        player_prefix = "alien"

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta

    if Input.is_action_just_pressed("%s_jump" % player_prefix) and is_on_floor():
        velocity.y = jump_velocity

    var input_direction = Input.get_vector("%s_move_left" % player_prefix, "%s_move_right" % player_prefix, "%s_move_forward" % player_prefix, "%s_move_backward" % player_prefix)
    var direction = Vector3.ZERO

    direction.z = input_direction.x

    if direction:
        velocity.z = direction.z * speed
    else:
        velocity.z = move_toward(velocity.z, 0, speed)

    velocity.x = 0

    move_and_slide()