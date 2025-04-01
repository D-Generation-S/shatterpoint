extends TranslationParser

func get_name() -> String:
    return "Building menu group parser"

func parse(data: Resource) -> PackedStringArray:
    print("Parse Building menu group data")
    var return_data: PackedStringArray = []
    if data is BuildMenuGroup:
        return_data.append(data.display_name)
        return_data.append("%s_DESCRIPTION" % data.display_name)
    return return_data