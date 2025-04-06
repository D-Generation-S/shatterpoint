class_name UnitSpawnButton extends Button

signal spawn_requested(data: UnitData)

var stored_data: UnitData

func _ready():
    icon = stored_data.texture
    _scrap_updated(GlobalDataAccess.get_resource_overlay().get_scrap())
    GlobalDataAccess.get_resource_overlay().scrap_updated.connect(_scrap_updated)
    text = "%s (%s)" % [tr(stored_data.unit_name), stored_data.spawn_scrap_price]
    tooltip_text = tr("%s_DESCRIPTION" % stored_data.unit_name)

func _scrap_updated(amount: int):
    disabled = amount < stored_data.spawn_scrap_price

func _init(data: UnitData):
    stored_data = data
    pass

func _pressed():
    spawn_requested.emit(stored_data)