@tool
class_name TranslationPlugin extends EditorTranslationParserPlugin

var _sub_parser: Array[TranslationParser]

func get_plugin_name() -> String:
	return ""

func get_extension_name() -> String:
	return ""

func load_sub_parser(directory: String):
	print("Load sub parser from %s" % directory)
	var dir = DirAccess.open(directory)
	if dir == null:
		print("Directory not existing")
		return
	var files = dir.get_files()
	
	for file in files:
		if !file.ends_with(".gd"):
			continue
		var path = directory + file
		var parser = load(path).new() as TranslationParser
		if parser != null:
			print("Add \"%s\" as sub parser" % parser.get_name())
			_sub_parser.append(parser)