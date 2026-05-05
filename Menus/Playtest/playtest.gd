extends CanvasLayer

var textbox: TextEdit

func _ready() -> void:
	textbox = $TextEdit

func _on_button_pressed() -> void:
	var code = textbox.text
	Talo.players.identify("version_" + code[0], code)
	queue_free()
