@tool
extends SubViewportContainer

func _input(event):
	$SubViewport.push_input(event)
