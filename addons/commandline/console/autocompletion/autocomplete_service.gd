class_name AutocompleteService extends Resource


func search_autocomplete(typed: String) -> Array[StrippedCommand]:
    return Console.get_autocomplete_commands().filter(func(command): return command.command.find(typed) == 0)
    