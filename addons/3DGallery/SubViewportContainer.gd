@tool
extends SubViewportContainer

func _input(event: InputEvent):
	$SubViewport.push_input(event)

func _gui_input(event: InputEvent):
	var focused = get_viewport().gui_get_focus_owner()

	# right clicks don't grab focus, so grab if its clicked
	if event is InputEventMouseButton and event.button_mask & 2:
		grab_focus()

	# Move back to the tree after releasing the mouse button
	if event is InputEventMouseButton:
		if not event.is_pressed() and focused.name == "GallerySubviewport":
			%GalleryTree.grab_focus()

	$SubViewport.push_input(event)
