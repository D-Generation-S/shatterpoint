class_name ScrapDropModifier extends StatModifier


func modifier_selected():
    GlobalDataAccess.get_resource_overlay().add_scrap(int(value))
