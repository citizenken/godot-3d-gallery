@tool
extends Node3D

const CAMERA_DISTANCE = 0.5
const LOOKAROUND_SPEED = 0.0005

@onready var tree: GalleryTree = %GalleryTree


var current_model: int = 0
var models: Array[Dictionary]
var rot_z = 0
var rot_y = 0

func _ready():
	tree.selected_tree_items_change.connect(update_models)


func _input(event: InputEvent):
	if event is InputEventMouseMotion \
		and event.button_mask & 2:
			var model = models[current_model]["node"]
			rot_z += event.relative.y * LOOKAROUND_SPEED
			rot_y += event.relative.x * LOOKAROUND_SPEED
			transform.basis = Basis() # reset rotation
			model.rotate_object_local(Vector3(0, 1, 0), rot_y)


func update_models(selected_tree_items: Array):
	models = []
	for c in get_children():
		c.queue_free()

	var aabb := AABB()
	for item_idx in range(0, selected_tree_items.size()):
		var item_path = selected_tree_items[item_idx]
		var scene: PackedScene = load(item_path) as PackedScene
		var instance: Node3D = scene.instantiate()
		add_child(instance)

		var inst_aabb := AABB()
		for child in instance.get_children():
			inst_aabb = inst_aabb.merge(get_instance_aabb(child, inst_aabb))

		aabb = aabb.merge(inst_aabb)
		models.append({"node": instance, "aabb": aabb})

	if not models.is_empty():
		update_camera(aabb)

func update_camera(aabb: AABB):
	var new_pos = Vector3(aabb.size.x + CAMERA_DISTANCE, 0 , 0)
	var new_gimbal_pos = Vector3(0, aabb.size.y/2, 0)

	$"../Gimbal".position = new_gimbal_pos
	$"../Gimbal/Camera3D".position = new_pos

func get_instance_aabb(node: Node3D, aabb: AABB) -> AABB:
	if not node is MeshInstance3D:
		if node.get_child_count() > 0:
			var children_aabb = AABB()
			for c in node.get_children():
				children_aabb = children_aabb.merge(get_instance_aabb(c, children_aabb))
			return children_aabb
		else:
			return AABB()
	else:
		var mesh: MeshInstance3D = node as MeshInstance3D
		return mesh.get_aabb()
