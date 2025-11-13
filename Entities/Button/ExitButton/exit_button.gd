extends ButtonBase
class_name ExitButton

signal engaged
signal disengaged

@onready var mesh: MeshInstance3D = $MeshInstance3D

var engaged_color: Color = Color.GREEN
var disengaged_color: Color = Color.RED
var material: StandardMaterial3D
var current_player_body: Node3D = null
var player_in_area: bool = false
var button_engaged: bool = false
var is_locked: bool = false

func _ready() -> void:
	super._ready()
	
	player_entered.connect(_on_player_entered)
	player_exited.connect(_on_player_exited)
	
	setup_material()
	set_process(true)

func _process(_delta):
	if is_locked: return

	if !player_in_area: return

	var player = current_player_body as Player
	var player_action = player.get_interact_action()

	if Input.is_action_just_pressed(player_action):
		update_state(true)

	if Input.is_action_just_released(player_action):
		update_state(false)

#Compares the desired state with the current state and emits the correct signal to engage or disengage the button.
func update_state(should_be_engaged: bool):
	if is_locked: return

	if should_be_engaged and not button_engaged:
		button_engaged = true

		engaged.emit()

		material.albedo_color = engaged_color
	elif not should_be_engaged and button_engaged:
		button_engaged = false

		disengaged.emit()
		
		material.albedo_color = disengaged_color

func lock_engaged():
	is_locked = true
	button_engaged = true
	material.albedo_color = engaged_color

func _on_player_entered(body: Node3D):
	if is_locked: return

	if current_player_body == null:
		current_player_body = body
		player_in_area = true

func _on_player_exited(body: Node3D):
	if is_locked: return

	if body == current_player_body:
		current_player_body = null
		player_in_area = false

		update_state(false)

#Creates a new material to not affect buttons that share the same mesh. Red is default.
func setup_material():
	material = StandardMaterial3D.new()

	mesh.material_override = material
	material.albedo_color = disengaged_color

func reset_state():
	super()

	is_locked = false
	player_in_area = false
	current_player_body = null

	update_state(false)
