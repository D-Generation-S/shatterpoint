extends TranslationParser

func get_name() -> String:
    return "Building validator parser"

func parse(data: Resource) -> PackedStringArray:
    print("Parse Building validator data")
    var return_data: PackedStringArray = []
    if data is BuildValidator:
        return_data.append(data.display_name)
        return_data.append("%s_DESCRIPTION" % data.display_name)
    return return_data