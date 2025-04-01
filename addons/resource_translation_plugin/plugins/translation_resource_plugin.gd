@tool
extends TranslationPlugin

func get_plugin_name() -> String:
    return "Resource File Translation"

func get_extension_name() -> String:
    return "tres"

func _parse_file(path: String, msgids: Array[String], msgids_context_plural: Array[Array]) -> void:
    var res: Resource = load(path)
    if not res:
        return

    if res is TranslationResource:
        var item: TranslationResource = res as TranslationResource
        if item.key == "":
            printerr("Empty translation in %s" % path)
            return
        msgids.append(item.key)

    for sub in _sub_parser:
        for data in sub.parse(res):
            msgids.append(data)

func _get_recognized_extensions() -> PackedStringArray:
    return [get_extension_name()]
    