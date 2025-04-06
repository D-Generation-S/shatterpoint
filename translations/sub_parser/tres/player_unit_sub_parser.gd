extends TranslationParser

func get_name() -> String:
    return "Player unit parser"

func parse(data: Resource) -> PackedStringArray:
    print("Parse Player unit")
    var return_data: PackedStringArray = []
    if data is UnitData:
        return_data.append(data.unit_name)
        return_data.append("%s_DESCRIPTION" % data.unit_name)
    return return_data