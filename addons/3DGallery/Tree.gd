@tool
class_name GalleryTree
extends Tree

signal selected_tree_items_change(selected_tree_items: Array)

var file_tree: Dictionary
var items: Array[TreeItem] = []
var current_item_idx: int = 0

func _ready():
	connect("item_selected", _on_single_selected)
	connect("visibility_changed", _on_vis_change)
	build_file_tree()
	set_selected(items[current_item_idx], 0)

func _on_vis_change():
	if visible:
		grab_focus()
	else:
		release_focus()

func build_file_tree():
	walk_file_tree("res://")
	var root = create_item()
	var depth = 0
	add_items_to_tree(file_tree, root, self)

func add_items_to_tree(file_tree: Dictionary, root: TreeItem, tree: Tree):
	for key in file_tree.keys():
		var item = tree.create_item(root)
		items.append(item)
		item.set_text(0, key)
		if file_tree[key] is Dictionary and not file_tree[key].keys().is_empty():
			add_items_to_tree(file_tree[key], item, tree)
			item.set_meta("is_dir", true)
			item.set_meta("path", key)
		else:
			item.set_tooltip_text(0, file_tree[key])
			item.set_meta("path", file_tree[key])
			item.set_meta("is_dir", false)

func walk_file_tree(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if path != "res://":
					walk_file_tree("/".join([path, file_name]))
				else:
					walk_file_tree(path + file_name)
			elif file_name.ends_with(".fbx") \
				or file_name.ends_with(".gltf") \
				or file_name.ends_with(".glb") \
				or file_name.ends_with(".blend") \
				or file_name.ends_with(".obj") \
				or file_name.ends_with(".dae"):

				var full_path: String
				if path != "res://":
					full_path = "/".join([path, file_name])
				else:
					full_path = path + file_name

				var path_parts: PackedStringArray = full_path.split("/")
				var basename: String = path_parts[-1]

				var parts: PackedStringArray = []
				for part in path_parts:
					if part:
						# splitting removes the //, so re-add them
						if part == "res:":
							part = "res://"
						parts.append(part)

				_add_recursive_keys(file_tree, parts.slice(0, parts.size()), full_path)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _add_recursive_keys(d: Dictionary, keys: PackedStringArray, full_path: String):
	if len(keys) == 1:
		d[keys[0]] = full_path
	else:
		var key = keys[0]
		if not d.has(key):
			d[key] = {}

		_add_recursive_keys(d[key], keys.slice(1, keys.size()), full_path)

var selected_tree_items: Array = []

func _on_single_selected():
	selected_tree_items = []
	var item = get_selected()
	if !item.get_meta("is_dir"):
		var model_path = item.get_meta("path")
		selected_tree_items.append(model_path)

	emit_signal("selected_tree_items_change", selected_tree_items)


func _on_multi_selected(item: TreeItem, column: int, selected: bool):
	if item.get_meta("is_dir"):
		for c: TreeItem in item.get_children():
			if !c.get_meta("is_dir"):
				var model_path = c.get_meta("path")
				if selected:
					selected_tree_items.append(model_path)
				else:
					var idx = selected_tree_items.find(model_path)
					selected_tree_items.remove_at(idx)

	elif !item.get_meta("is_dir"):
		var model_path = item.get_meta("path")
		if selected:
			selected_tree_items.append(model_path)
		else:
			var idx = selected_tree_items.find(model_path)
			selected_tree_items.remove_at(idx)

	emit_signal("selected_tree_items_change", selected_tree_items)
