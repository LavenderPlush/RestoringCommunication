class_name Common

static func reparent_children(a: Node3D, b: Node3D):
	for child in a.get_children():
		if child != b:
			child.reparent(b, true)
