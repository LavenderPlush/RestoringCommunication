extends Control

@export var camera: Camera3D

var camera_controller: Camera3D

@export var small_fov_control: LineEdit
@export var wide_fov_control: LineEdit
@export var transition_speed_control: LineEdit
@export var distance_treshold_control: LineEdit
@export var follow_speed_control: LineEdit
@export var vertical_offset_control: LineEdit

func _ready() -> void:
	camera_controller = camera
	small_fov_control.text = str(camera_controller.small_fov)
	wide_fov_control.text = str(camera_controller.wide_fov)
	transition_speed_control.text = str(camera_controller.transition_speed)
	distance_treshold_control.text = str(camera_controller.distance_treshold)
	follow_speed_control.text = str(camera_controller.follow_speed)
	vertical_offset_control.text = str(camera_controller.vertical_offset)

func _process(_delta: float) -> void:
	camera_controller.small_fov = float(small_fov_control.text)
	camera_controller.wide_fov = float(wide_fov_control.text)
	camera_controller.transition_speed = float(transition_speed_control.text)
	camera_controller.distance_treshold = float(distance_treshold_control.text)
	camera_controller.follow_speed = float(follow_speed_control.text)
	camera_controller.vertical_offset = float(vertical_offset_control.text)
