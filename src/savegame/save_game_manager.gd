class_name SaveGameManager extends Node

var _profile_repository: ProfilesRepository = ProfilesRepository.new()
var _current_profile: Profile = null

func create_profile(profile_name: String) -> Profile:
    return _profile_repository.create_profile(profile_name)

func save_profile(save_game: Profile) -> bool:
    return _profile_repository.save_profile(save_game)

func load_profile(profile_name: String) -> Profile:    
    if _current_profile != null and _current_profile.get_display_name() == profile_name:
        return _current_profile
    _current_profile = _profile_repository.load_profile(profile_name)

    return _current_profile

func list_profiles() -> Array[Dictionary]:
    return _profile_repository.get_all_profile_names()

func get_current_profile() -> Profile:
    return _current_profile