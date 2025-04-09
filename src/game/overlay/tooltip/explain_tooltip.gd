class_name ExplainTooltip extends PanelContainer

signal is_locked()
signal closing_now(key: String)

@export var tooltip_header: Label
@export var tooltip_icon: TextureRect
@export var tooltip_content: RichTextLabel

@export var lock_time: float = 4 

var lock_timer: Timer
var locked: bool = false

func _init():
	lock_timer = Timer.new()
	lock_timer.wait_time = lock_time
	lock_timer.one_shot = true
	lock_timer.autostart = false
	lock_timer.timeout.connect(_lock_now)
	#transient = true

	add_child(lock_timer)
	
	mouse_entered.connect(_mouse_in)
	mouse_exited.connect(_mouse_out)

var _key: String
var text: String
var description: String
var icon: Texture


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	tooltip_header.text = text
	tooltip_content.text = description
	tooltip_icon.texture = icon
	if icon == null:
		tooltip_icon.visible = false

func get_key():
	return _key

func setup(data: TooltipData):
	_key = data.key
	text = data.headline.key
	description = data.content.key
	icon = data.icon

func _lock_now():
	locked = true
	is_locked.emit()

func _mouse_in():
	if locked:
		return
	lock_timer.start(lock_time)

func _mouse_out():
	if locked:
		return
	lock_timer.stop()
	close_now()

func explanation_requested(_meta: Variant):
	_lock_now()

func close_now():
	closing_now.emit(_key)
	queue_free()