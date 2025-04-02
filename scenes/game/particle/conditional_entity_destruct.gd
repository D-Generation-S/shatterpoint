class_name ConditionalEntityDestruct extends ConditionalDeleting

signal texture_was_set(texture: Texture)	

func add_texture(texture: Texture):
	texture_was_set.emit(texture)

