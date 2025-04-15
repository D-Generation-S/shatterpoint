class_name ProfilesRepository extends Resource

var base_folder = "user://profiles/"
var save_name = "save_game.sav"
var display_name = "dname"
var backup_folder = "backups/"
var backup_count = 10

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(base_folder)

func get_all_profile_names() -> Array[Dictionary]:
	var return_data: Array[Dictionary] = []
	for profile in DirAccess.get_directories_at(base_folder):
		var profile_directory = "%s%s/" % [base_folder, profile]
		var profile_display_name = FileAccess.get_file_as_string("%s%s" % [profile_directory, display_name])
		var data = {
			"directory": profile,
			"display_name": profile_display_name,
		}
		return_data.append(data)
	return return_data

func create_profile(name: String) -> Profile:
	for existing_profile in get_all_profile_names():
		if existing_profile.get("display_name") == name:
			printerr("Profile with name %s already exists" % [name])
			return null
	var profile = Profile.new()
	profile.set_display_name(name)
	
	save_profile(profile)
	return load_profile(profile.get_display_name())

func save_profile(profile: Profile) -> bool:
	if profile == null:
		return false
	var profile_directory = "%s%s/" % [base_folder, profile.get_directory_name()]
	var save_file_name = "%s%s" % [profile_directory, save_name]
	var display_name_file_name = "%s%s" % [profile_directory, display_name]
	DirAccess.make_dir_recursive_absolute(profile_directory)
	if !FileAccess.file_exists(display_name_file_name):
		var display_name_file = FileAccess.open(display_name_file_name, FileAccess.WRITE)
		display_name_file.store_string(profile.get_display_name())
		display_name_file.close()
	
	if FileAccess.file_exists(save_file_name):
		var backup_directory = "%s%s" % [profile_directory, backup_folder]
		var date_time = Time.get_datetime_dict_from_system()
		var date_time_string = "%s%s%s_%s%s%s" % [
			date_time.year,
			date_time.month,
			date_time.day,
			date_time.hour,
			date_time.minute,
			date_time.second
		]
		var backup_file_name = "%s%s_%s" % [backup_directory, date_time_string, save_name]
		DirAccess.make_dir_recursive_absolute(backup_directory)
		DirAccess.rename_absolute(save_file_name, backup_file_name)
		cleanup_backups(backup_directory)


	return _store_profile_data(profile, save_file_name)

func cleanup_backups(backup_directory: String) -> void:
	if !DirAccess.dir_exists_absolute(backup_directory):
		return
	var files = DirAccess.get_files_at(backup_directory)
	if files.size() <= backup_count:
		return
	var file_list = files as Array[String]
	file_list.sort_custom(_file_sort)

	for index in range(files.size() - backup_count - 1):
		var file_to_remove = file_list[index]
		var absolute_file = "%s%s" % [backup_directory, file_to_remove]
		DirAccess.remove_absolute(absolute_file)

func _file_sort(a: String, b: String) -> int:
	var a_time = FileAccess.get_modified_time(a)
	var b_time = FileAccess.get_modified_time(b)
	return a_time > b_time

func _store_profile_data(profile: Profile, path: String) -> bool:
	var file = FileAccess.open(path, FileAccess.WRITE)
	var data = {
		"display_name": profile.get_display_name(),
		"creation_date": profile.get_creation_date_as_unix_time(),
		"data": {
			"meta": {
				"ranks": profile.save_game.meta_progression.ranks
			},
			"statistic": {
				"highest_wave": profile.save_game.statistic.highest_wave,
			}
		}
	}
	file.store_string(JSON.stringify(data))
	file.close()
	return true

func remove_profile(profile_name: String) -> bool:
	profile_name = profile_name.to_snake_case()
	var folder_name = "%s%s/%s" % [base_folder, profile_name]
	if !DirAccess.dir_exists_absolute(folder_name):
		printerr("Profile with name %s was not found" % [profile_name])
		return false
	DirAccess.remove_absolute(folder_name)
	return !DirAccess.dir_exists_absolute(folder_name)

func load_profile(profile_name: String) -> Profile:
	profile_name = profile_name.to_snake_case()
	var file_name = "%s%s/%s" % [base_folder, profile_name, save_name]
	if !FileAccess.file_exists(file_name):
		printerr("Profile with name %s was not found" % [profile_name])
		return null

	var parser = JSON.new()
	var file = FileAccess.open(file_name, FileAccess.READ)
	var parse_result = parser.parse(file.get_as_text())
	if parse_result != OK:
		printerr("Failed to parse profile %s" % [profile_name])
		return null
	file.close()
	var data = parser.get_data() as Dictionary

	var return_profile = Profile.new()
	return_profile.set_display_name(data.get("display_name"))
	return_profile.set_creation_date_as_unix_time(data.get("creation_date"))
	var statistic = return_profile.save_game.statistic
	statistic.highest_wave = data.get("data").get("statistic").get("highest_wave")
	
	var meta_progression = return_profile.save_game.meta_progression
	var meta_progression_data_set: Dictionary = data.get("data").get("meta")
	meta_progression.ranks = meta_progression_data_set.get_or_add("ranks", 0)
	
	return return_profile
