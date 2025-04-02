extends TranslationParser

func get_name() -> String:
    return "Thread Determination parser"

func parse(data: Resource) -> PackedStringArray:
    print("Parse thread determination data")
    var return_data: PackedStringArray = []
    if data is ThreatDetermination:
        return_data.append(data.get_display_name())
    return return_data