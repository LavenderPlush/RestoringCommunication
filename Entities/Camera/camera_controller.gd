extends Camera3D

@export_category("Developers")
@export var player1: Node3D
@export var player2: Node3D

@export_category("Designers")
##Small camera field of view.
@export var small_fov: float = 50.0
##Wide camera field of view.
@export var wide_fov: float = 80.0
##Transitioning speed between camera fields of view.
@export var transition_speed: float = 4.0
##Distance between players that triggers the switch to other FOVs.
@export var distance_treshold: float = 8.0
##Speed the camera follows the midpoint.
@export var follow_speed: float = 3.0
##Distance above midpoint.
@export var vertical_offset: float = 4.0

@export_category("Confiners")
@export var enable_confiners: bool = false
@export var small_fov_max: float = 50.0
@export var small_fov_min: float = 0.0
@export var wide_fov_max: float = 50.0
@export var wide_fov_min: float = 0.0

var cur_y_min: float
var cur_y_max: float

func _ready():
	cur_y_min = small_fov_min
	cur_y_max = small_fov_max

func _process(delta: float) -> void:
	var p1_pos: Vector3 = player1.get_target_position()
	var p2_pos: Vector3 = player2.get_target_position()
	var midpoint: Vector3 = (p1_pos + p2_pos) / 2.0
	var distance: float = p1_pos.distance_to(p2_pos)
	var target_fov: float
	var target_y_min: float
	var target_y_max: float

	if distance > distance_treshold:
		target_fov = wide_fov
		target_y_min = wide_fov_min
		target_y_max = wide_fov_max
	else:
		target_fov = small_fov
		target_y_min = small_fov_min
		target_y_max = small_fov_max
	
	self.fov = lerp(self.fov, target_fov, delta * transition_speed)
	
	cur_y_min = lerp(cur_y_min, target_y_min, delta * transition_speed)
	cur_y_max = lerp(cur_y_max, target_y_max, delta * transition_speed)

	var new_pos: Vector3 = self.global_position
	var target_y = midpoint.y + vertical_offset

	new_pos.y = lerp(new_pos.y, target_y, delta * follow_speed)
	new_pos.z = lerp(new_pos.z, midpoint.z, delta * follow_speed)

	if enable_confiners:
		new_pos.y = clamp(new_pos.y, cur_y_min, cur_y_max)
		
	self.global_position = new_pos
