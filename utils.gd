class_name utils 
# No 'extends' keyword means it defaults to RefCounted/Object

static func clean_container(container: Node) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
