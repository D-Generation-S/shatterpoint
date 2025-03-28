extends CommandTemplate

func create_command() -> Command:
    var command = Command.new("man", manual, ["Name of the command"], "Command to get a manual for an command")
    return command

func manual(command_name: String) -> String:
    var command = Console.console_commands[command_name]
    if command == null:
        return "No command with name %s was found" % command_name
    
    return command.get_man_page()
