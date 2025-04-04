class_name Profile extends Resource

var _display_name: String = tr("NEW_PROFILE")
var _creation_date: float = Time.get_unix_time_from_system()


var save_game: SaveGame = SaveGame.new()

func get_directory_name() -> String:
    return _display_name.to_snake_case()

func set_display_name(new_name: String) -> void:
    _display_name = new_name

func get_display_name() -> String:
    return _display_name

func get_creation_date_as_unix_time() -> float:
    return _creation_date

func set_creation_date_as_unix_time(new_time: float) -> void:
    _creation_date = new_time