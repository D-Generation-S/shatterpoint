class_name InteractiveMessageTemplate extends MessageTemplate

signal meta_request(data: Dictionary)
signal clear_text()

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	clear_text.emit()
	text_changed.emit(tr(text))

func meta_changed(data):
	var json_parser = JSON.new()
	var result = json_parser.parse(data)
	if result != OK:
		printerr("Error while parsing %s" % data)
		return

	var dictionary = json_parser.get_data()
	meta_request.emit(dictionary)
