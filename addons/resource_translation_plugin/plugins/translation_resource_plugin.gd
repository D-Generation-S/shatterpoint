@tool
extends TranslationPlugin

func get_plugin_name() -> String:
    return "Resource File Translation"

func get_extension_name() -> String:
    return "tres"

func _parse_file(path: String) -> Array[PackedStringArray]:
    var msgids: Array[PackedStringArray] = []
    var res: Resource = load(path)
    if not res:
        return msgids

    if res is TranslationResource:
        var item: TranslationResource = res as TranslationResource
        if item.key == "":
            printerr("Empty translation in %s" % path)
            return msgids
        msgids.append(item.key)

    for sub in _sub_parser:
        for data in sub.parse(res):
            msgids.append(data)

    return msgids

func _get_recognized_extensions() -> PackedStringArray:
    return [get_extension_name()]
    