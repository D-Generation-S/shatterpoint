extends Node

var base_folder: String = "res://assets/resources/modifiers/generators/"
var max_depth: int = 2

var _generators: Array[StatGenerator] = []

func _ready():
	_generators.append_array(_load_generators_from_root(base_folder))

func _load_generators_from_root(root: String, depth: int = 0) -> Array[StatGenerator]:
	var return_data: Array[StatGenerator] = []
	if depth >= max_depth:
		return return_data

	for file in DirAccess.get_files_at(root):
		var path = "%s%s" % [root, file]
		# https://forum.godotengine.org/t/issue-with-reading-tres-files-after-exporting-project/75731/4
		if path.ends_with(".remap"):
			path = path.trim_suffix(".remap")
		var data = load(path) as StatGenerator
		if data != null:
			return_data.append(data)

	for directory in DirAccess.get_directories_at(root):
		var path = "%s%s" % [root, directory]
		return_data.append(_load_generators_from_root(path, depth + 1))

	return return_data

func get_generators_with_tag(tag: Tag) -> Array[StatGenerator]:
	var return_data: Array[StatGenerator] = []
	for generator in _generators:
		if generator.contains_tag(tag):
			return_data.append(generator)

	return return_data


func get_generators_with_tags(tags: Array[Tag]) -> Array[StatGenerator]:
	var return_data := {}
	for tag in tags:
		for generator in get_generators_with_tag(tag):
			return_data[generator.resource_path] =  generator

	var return_array: Array[StatGenerator] = []
	for entry in return_data.values():
		if entry is StatGenerator:
			return_array.append(entry)
	
	return return_array