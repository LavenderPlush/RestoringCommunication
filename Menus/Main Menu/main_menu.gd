extends Control

@onready var play_button: TextureButton = $Buttons/PlayButton
@onready var controls_button: TextureButton = $Buttons/ControlsButton
@onready var quit_button: TextureButton = $Buttons/QuitButton
@onready var back_button: TextureButton = $ControlsGroup/BackButton

@export var controls_image = Control

func _ready():
	controls_image.visible = false

	play_button.pressed.connect(_on_play_button_pressed)
	controls_button.pressed.connect(_on_controls_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_controls_button_pressed() -> void:
	controls_image.visible = true
		
	back_button.grab_focus()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	controls_image.visible = false

	play_button.grab_focus()
