extends Control

@onready var resume_button: Button = $ButtonContainer/ResumeButton
@onready var main_menu_button: Button = $ButtonContainer/MainMenuButton
@onready var quit_button: Button = $ButtonContainer/QuitButton

func _ready():
	visible = false

	get_tree().paused = false

	resume_button.pressed.connect(_on_resume_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	var is_paused = !get_tree().paused

	get_tree().paused = is_paused

	visible = is_paused

	if is_paused:
		resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/Main Menu/main_menu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
