class_name ConsoleTemplate extends Node

signal command_requested(text: String)
signal output_append(text: String)
signal clear_output()
signal clear_input()

signal autocomplete_found(autocompletion: String)

@export_group("GameConsole Setup")
@export var console_content_output: RichTextLabel
@export var console_input: LineEdit
@export var console_send_button: Button
@export var autocomplete_service: AutocompleteService

# Called when the node enters the scene tree for the first time.
func _ready():
	if console_content_output == null:
		printerr("GameConsole template is missing output window")
		queue_free()
		
	if console_input == null:
		printerr("GameConsole template is missing input box")
		queue_free()
		
	if console_send_button == null:
		printerr("GameConsole template is missing send button")
		queue_free()

	Console._register_custom_builtin_command("clear", clear_command,  [], "Command to clear the console window")

	console_input.grab_focus()


func execute_command(command: Command):
	command_requested.emit(command)

func request_command(text: String):
	command_requested.emit(text)
	clear_input.emit()

func add_console_output(text: String):
	output_append.emit(text)

func clear_command():
	clear_output.emit()

func autocomplete_requested(typed: String):
	if autocomplete_service == null:
		return

	var matches = autocomplete_service.search_autocomplete(typed)
	if matches.size() > 0:
		autocomplete_found.emit(matches[0])
