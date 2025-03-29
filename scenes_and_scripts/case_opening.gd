extends Control


@onready var case_container: ScrollContainer = $"CaseScrollContainer"
@onready var item_container: HBoxContainer = $"CaseScrollContainer/ItemContainer"
@onready var panel_result: Panel = $PanelResult
@onready var debug_info: Label = $DebugInfo


var case_items: Dictionary = {}
var drop_chances: Dictionary = {}
var wheel_items: Array = [] # Item's textures chosen for wheel

var total_wheel_items: int = 37
var result_index: int  = total_wheel_items - 2 # Index of the reward
# land on index 35 which ROUGHLY 8335 - 8560

var wheel_timer: float = 0.0
var wheel_duration: float = 5.0
var wheel_initial_velocity: float = 2900
var wheel_velocity: float = wheel_initial_velocity
var wheel_deceleration_factor: float = -0.5
var wheel_distance: float = 0.0

func _ready() -> void:
	if self == get_tree().get_current_scene():  # TODO debug
		_mock_data()
	
	# Scaling scroll bar so it won't show. Option to set scroll mode to Never show
	#case_container.get_h_scroll_bar().scale.x = 0
	
	# Set up RNG seed
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	_choose_wheel_items(rng)


func _process(_delta: float) -> void:
	debug_info.text = "container scroll_h: %d \nwheel_velocity: %d \nTimer: %f" % [case_container.scroll_horizontal, wheel_velocity, wheel_timer]
	# Limit by duration and max position on the wheel
	# TODO we have to pick the landing spot in advance and adjust the speed to ensure timely landing
	# TODO randomize the landing spot min-max
	# TODO possibly change to tween
	wheel_timer += _delta
	if wheel_duration > wheel_timer and case_container.scroll_horizontal not in range(8335, 8560): # TODO dynamic container max position:
		
		if wheel_timer <= wheel_duration * 0.1:
			wheel_velocity = wheel_velocity
		if wheel_timer > wheel_duration * 0.1 and wheel_timer <= wheel_duration * 0.5:
			wheel_velocity = wheel_initial_velocity \
							* exp(wheel_deceleration_factor * (wheel_timer - wheel_duration * 0.1)) #= v_init * e^(k*t)
		elif wheel_timer > wheel_duration * 0.5:
			if wheel_velocity > 350: # TODO minimum speed
				wheel_velocity -= wheel_velocity * (wheel_timer - (wheel_duration * 0.5)) / wheel_duration * 0.5
			else:
				wheel_velocity = 350

		wheel_distance += wheel_velocity * _delta
		print("Timer: %f wheel_velocity: %f Distance: %f" % [wheel_timer, wheel_velocity, int(wheel_velocity * _delta)]) # TODO DEBUG
		# Required as ScrollContainer property uses int and we lose precision
		if int(wheel_distance) >= 1:
			case_container.scroll_horizontal += int(wheel_distance)
			wheel_distance = 0
	if wheel_timer > (wheel_duration + 1):
		panel_result.get_node("ResultItem").texture = wheel_items[result_index].texture
		panel_result.show()



func _choose_wheel_items(rng) -> void:
	# Sum up case drop chances
	var case_total_chance = 0
	for chance in drop_chances.values():
		case_total_chance += chance
	
	for i in range(total_wheel_items):
		var chance = rng.randi_range(1, case_total_chance)
		if chance in range(0, drop_chances["uncommon"]):
			_create_item("uncommon")
		elif chance in range(drop_chances["uncommon"], drop_chances["rare"]):
			_create_item("rare")
		elif chance in range(drop_chances["rare"], drop_chances["very_rare"]):
			_create_item("very_rare")
		elif chance in range(drop_chances["very_rare"], drop_chances["epic"]):
			_create_item("epic")
		else:
			_create_item("legendary")


func _create_item(item_rarity) -> void:
	# Select random item from the rarity
	var img_texture = randi() % case_items.get(item_rarity).size() # Random array position from rarity
	# TODO Maybe we don't need to create a new rectangle or we could handle loading textures here for the items needed
	var img = TextureRect.new()
	img.texture = case_items.get(item_rarity)[img_texture] # Set that texture to have chosen item
	wheel_items.append(img) # Add chosen item's texture to wheel items
	item_container.add_child(img)


func _on_PanelResultButton_pressed() -> void:
	queue_free()


func _mock_data() -> void:
	case_items = {
		"uncommon": [load("res://sprites/uncommon_green_250x250.png")],
		"rare": [load("res://sprites/rare_blue_250x250.png")],
		"very_rare": [load("res://sprites/very_rare_purple_250x250.png")],
		"epic": [load("res://sprites/epic_red_250x250.png")],
		"legendary": [load("res://sprites/legendary_orange_250x250.png")]
	}
	drop_chances = {
		"uncommon": 7,
		"rare": 5,
		"very_rare": 3,
		"epic": 2,
		"legendary": 1
	}
	print("DEBUG MODE")
