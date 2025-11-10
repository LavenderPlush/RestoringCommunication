extends ButtonBase
class_name ExitButton

signal engaged(player_body: Node3D)
signal disengaged

var engaged_color: Color = Color.GREEN
var disengaged_color: Color = Color.RED

@onready var mesh: MeshInstance3D = $MeshInstance3D

var material_instance: StandardMaterial3D
var current_player_body: Node3D = null
var press_offset: float = -0.05
var is_in_area: bool = false
var is_engaged: bool = false
var is_locked: bool = false

func _ready() -> void:
	super._ready()
	
	player_entered.connect(_on_player_entered)
	player_exited.connect(_on_player_exited)
	
	material_instance = StandardMaterial3D.new()

	var base_material = mesh.get_active_material(0)
	
	if base_material and base_material is StandardMaterial3D:
		material_instance.albedo_texture = base_material.albedo_texture

	material_instance.vertex_color_use_as_albedo = false
	mesh.material_override = material_instance
	material_instance.albedo_color = disengaged_color
	
	set_process(true)

func _process(_delta):
	if is_locked: return

	if not is_in_area: return

	var player_action = current_player_body.get("interact_action")
	var is_input_held = Input.is_action_pressed(player_action)

	update_state(is_input_held)

func update_state(should_be_engaged: bool):
	if is_locked: return

	if should_be_engaged and not is_engaged:
		is_engaged = true

		engaged.emit(current_player_body)

		animate_button(original_position.y + press_offset)

		material_instance.albedo_color = engaged_color
	elif not should_be_engaged and is_engaged:
		is_engaged = false

		disengaged.emit()

		animate_button(original_position.y)
		
		material_instance.albedo_color = disengaged_color

func lock_engaged():
	is_locked = true
	is_engaged = true

	animate_button(original_position.y + press_offset)

	material_instance.albedo_color = engaged_color

func _on_player_entered(body: Node3D):
	if is_locked: return

	if current_player_body == null:
		current_player_body = body
		is_in_area = true

func _on_player_exited(body: Node3D):
	if is_locked: return

	if body == current_player_body:
		current_player_body = null
		is_in_area = false

		update_state(false)
