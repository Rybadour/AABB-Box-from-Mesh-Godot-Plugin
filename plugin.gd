@tool
extends EditorPlugin

var currentNode: MeshInstance3D;
var generateButton: Button;

func _handles(object) -> bool:
	return object is MeshInstance3D;
	
func _edit(object: Object) -> void:
	if object:
		currentNode = object;
	
func _make_visible(visible):
	if !visible:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, generateButton);
		generateButton.queue_free();
		generateButton = null;
		return;
		
	if generateButton:
		return;
	
	generateButton = Button.new();
	generateButton.text = "Generate AABB BoxCollider";
	generateButton.flat = true;
	generateButton.pressed.connect(_onButtonPressed);
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, generateButton);
	
func _onButtonPressed():
	var aabb = currentNode.mesh.get_aabb();
	
	var body = StaticBody3D.new();
	body.name = "AABB_StaticBody3D";
	body.transform = Transform3D();
	currentNode.add_child(body);
	body.owner = currentNode.owner;
	
	var box = BoxShape3D.new();
	box.extents = Vector3(aabb.size/2);
	
	var coll_shape = CollisionShape3D.new();
	coll_shape.name = "AABB_CollisionShape3D";
	coll_shape.shape = box;
	coll_shape.transform = Transform3D();
	coll_shape.position = aabb.get_center();
	body.add_child(coll_shape);
	coll_shape.owner = currentNode.owner;
