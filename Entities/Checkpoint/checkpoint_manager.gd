extends Node

var player1: Player
var player2: Player
var current_checkpoint_id: int = -1
var p1_spawn_transform: Transform3D
var p2_spawn_transform: Transform3D
var checkpoint_active: bool = false

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		reset_to_checkpoint()

func reset():
	current_checkpoint_id = -1
	checkpoint_active = false

func set_original_position(player: Player):
	if player.is_in_group("Human"):
		player1 = player
		p1_spawn_transform = player.global_transform
	elif player.is_in_group("Alien"):
		player2 = player
		p2_spawn_transform = player.global_transform

#Updates player spawn points. ID is used to differentiate checkpoints when resetting objects.
func set_active_checkpoint(p1_spawn: Transform3D, p2_spawn: Transform3D, id: int):
	if id > current_checkpoint_id:
		p1_spawn_transform = p1_spawn
		p2_spawn_transform = p2_spawn
		current_checkpoint_id = id

#Resets players and objects back to their original state.
func reset_to_checkpoint():
	var players = []

	if is_instance_valid(player1):
		players.append(player1)

	if is_instance_valid(player2):
		players.append(player2)

	for player in players:
		player.reset_state()

		var body_to_teleport = player.get_controlled_body()
		var spawn_transform: Transform3D

		if player.is_in_group("Human"):
			spawn_transform = p1_spawn_transform
		elif player.is_in_group("Alien"):
			spawn_transform = p2_spawn_transform

		if is_instance_valid(body_to_teleport):
			body_to_teleport.global_transform = spawn_transform
	
	var resettable_objects = get_tree().get_nodes_in_group("resettable")

	for obj in resettable_objects:
		var reset_id = obj.get("reset_until_checkpoint_id")

		if reset_id == -1 or current_checkpoint_id < reset_id:
			obj.reset_state()
