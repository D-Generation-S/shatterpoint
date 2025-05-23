extends Node

signal building_added(building: Building)
signal building_removed(building: Building)

func building_was_added(building: Building):
	building_added.emit(building)

func building_was_removed(building: Building):
	building_removed.emit(building)