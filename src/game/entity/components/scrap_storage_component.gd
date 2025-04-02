extends Node2D

signal update_death_animation(scene: PackedScene)

func building_data_updated(building_data: BuildingBase):
	if building_data is StorageData:
		update_death_animation.emit(building_data.death_animation)