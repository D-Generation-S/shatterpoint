extends Node2D

var scrap_drop: int = 0
var icon: Texture2D = null

func data_changed(data: UnitData):
    scrap_drop = randi_range(data.min_scrap_drop, data.max_scrap_drop)
    

func drop_requested():
    if scrap_drop <= 0:
        return
    
    GlobalDataAccess.get_item_path_system().create_new_travel_path(GlobalDataAccess.get_resource_overlay().scrap_icon,
                                                                    AutoDeleteNode.new(10, global_position),
                                                                    GlobalDataAccess.get_resource_overlay().scrap_animation_node,
                                                                    scrap_drop,
                                                                    1)

    GlobalDataAccess.get_resource_overlay().add_scrap(scrap_drop)
    
	