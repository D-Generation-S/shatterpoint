extends TranslationParser

func get_name() -> String:
    return "Stat modifier parser"

func parse(data: Resource) -> PackedStringArray:
    print("Parse Stat modifier data")
    var return_data: PackedStringArray = []
    if data is StatModifier:
        return_data.append(data._name)
        return_data.append("%s_DESCRIPTION" % data._name)
    return return_data