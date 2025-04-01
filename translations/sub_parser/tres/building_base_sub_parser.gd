extends TranslationParser

func get_name() -> String:
    return "Building base parser"

func parse(data: Resource) -> PackedStringArray:
    print("Parse building data")
    var return_data: PackedStringArray = []
    if data is BuildingBase:
        return_data.append(data.building_name)
        return_data.append("%s_DESCRIPTION" % data.building_name)
    return return_data