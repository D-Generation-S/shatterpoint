class_name EntityComponent extends Node2D

func enable():
	process_mode = PROCESS_MODE_INHERIT

func disable():
	process_mode = PROCESS_MODE_DISABLED
