extends MessageCenter

func _handle_message_vanished():
	clear_all_messages()
	super()
