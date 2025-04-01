@tool
extends EditorPlugin

var plugins: Array[TranslationPlugin]

var addon_plugin_directory: String = "res://addons/resource_translation_plugin/plugins/"
var addon_plugin_sub_parser_directory: String = "res://addons/resource_translation_plugin/sub_parser/"
var user_plugin_directory: String = "res://translations/plugins/"
var user_plugin_sub_parser_directory: String = "res://translations/sub_parser/"

func _enter_tree():
	_add_translation_plugins_from_directory(addon_plugin_directory)
	_add_translation_plugins_from_directory(user_plugin_directory)

func _add_translation_plugins_from_directory(directory: String):
	for plugin in _load_translation_plugins_in_directory(directory):
		if plugin is TranslationPlugin:
			print("load %s plugin" % plugin.get_plugin_name() )
			var addon_sub_type_directory = "%s%s/" % [addon_plugin_sub_parser_directory, plugin.get_extension_name()]
			var user_sub_type_directory = "%s%s/" % [user_plugin_sub_parser_directory, plugin.get_extension_name()]

			plugin.load_sub_parser(addon_sub_type_directory)
			plugin.load_sub_parser(user_sub_type_directory)

			plugins.append(plugin)
			add_translation_parser_plugin(plugin)

func _exit_tree():
	for plugin in plugins:
		remove_translation_parser_plugin(plugin)

func _load_translation_plugins_in_directory(directory: String) -> Array[TranslationPlugin]:
	var dir = DirAccess.open(directory)
	if dir == null:
		return []
	var loaded_plugins: Array[TranslationPlugin]
	var files = dir.get_files()
	for file in files:
		if !file.ends_with(".gd"):
			continue
		
		var path = directory + file
		var plugin = load(path).new() as TranslationPlugin
		if plugin != null:
			loaded_plugins.append(plugin)

	return loaded_plugins
