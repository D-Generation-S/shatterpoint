extends Node

var initial_profile_name: String = "Default_Prototype"
var current_profile: Profile

func _init():
    _register_commands()
    current_profile = GlobalSaveGameManager.load_profile(initial_profile_name)
    if !current_profile:
        current_profile = GlobalSaveGameManager.create_profile(initial_profile_name)

func _list_profiles_command() -> String:
    var return_data = ""
    for profile in GlobalSaveGameManager.list_profiles():
        return_data += "[b]Profile: %s[/b]\n" % profile.display_name
        return_data += "[i]actions[/i]\n"
        var interaction = Interaction.new()
        interaction.from_raw("enter", "delete_profile %s" % profile.display_name)
        return_data += "[b][url=%s]delete profile [/url][/b]\n" % interaction.get_as_string()
        var load_interaction = Interaction.new()
        load_interaction.from_raw("enter", "load_profile %s" % profile.display_name)
        return_data += "[b][url=%s]load profile [/url][/b]\n" % load_interaction.get_as_string()

    return return_data

func _delete_profile_command(profile_name: String) -> String:
    if GlobalSaveGameManager.remove_profile(profile_name):
        return "[color=green]Profile %s was deleted[/color]" % profile_name
    else:
        return "[color=red]Profile %s was not found[/color]" % profile_name

func _add_new_profile(profile_name: String) -> String:
    if GlobalSaveGameManager.create_profile(profile_name):
        return "[color=green]Profile %s was created[/color]" % profile_name
    else:
        return "[color=red]Profile %s was not created[/color]" % profile_name

func _load_profile_command(profile_name: String) -> String:
    current_profile = GlobalSaveGameManager.load_profile(profile_name)
    if current_profile:
        return "[color=green]Profile %s was loaded[/color]" % profile_name
    else:
        return "[color=red]Profile %s was not found[/color]" % profile_name

func _get_current_profile_info() -> String:
    if current_profile == null:
        return "[color=red]No profile loaded[/color]"
    var return_data = ""
    return_data += "[b]Profile: %s[/b]\n" % current_profile.get_display_name()

    return return_data

func _register_commands():
    Console.register_custom_command("list_profiles", _list_profiles_command, [], "List all the save game profiles")
    Console.register_custom_command("delete_profile", _list_profiles_command, [], "Delete a given profile")
    Console.register_custom_command("add_profile", _add_new_profile, [], "Create and use a new profile")
    Console.register_custom_command("load_profile", _load_profile_command, [], "Load a given profile")
    Console.register_custom_command("get_loaded_profile", _get_current_profile_info, [], "Get information about the current profile")

func _exit_tree():
    _unregister_commands()

func _unregister_commands():
    Console.remove_command("list_profiles")
    Console.remove_command("delete_profile")
    Console.remove_command("add_profile")
    Console.remove_command("load_profile")
    Console.remove_command("get_loaded_profile")