extends Control


@onready var case_container: ScrollContainer = $"CaseScrollContainer"
@onready var item_container: HBoxContainer = $"CaseScrollContainer/ItemContainer"
@onready var panel: Panel = $Panel


var item_list: Dictionary = {}
var drop_chances: Dictionary = {}


var wheel_items: Array = [] # Items chosen for wheel
var increase_value: int = 0
var index_number = 2
var high_limit = 270
var speed = 40
var case_stopped = false
var total_wheel_items: int = 35


func _ready() -> void:
	if self == get_tree().get_current_scene():  # TODO debug
		item_list = {
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
		print("True - Debug mode")
	
	# Scaling scroll bar so it won't show. Option to set scroll mode to Never show
	#case_container.get_h_scroll_bar().scale.x = 0
	
	# Set up RNG seed
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	print(drop_chances) # TODO debug
	var case_total_chance = 0
	for chance in drop_chances.values():
		case_total_chance += chance
	
	for i in range(total_wheel_items):
		var chance = rng.randi_range(1, case_total_chance)
		if chance in range(0, drop_chances["uncommon"]):
			create_item("uncommon")
		elif chance in range(drop_chances["uncommon"], drop_chances["rare"]):
			create_item("rare")
		elif chance in range(drop_chances["rare"], drop_chances["very_rare"]):
			create_item("very_rare")
		elif chance in range(drop_chances["very_rare"], drop_chances["epic"]):
			create_item("epic")
		else:
			create_item("legendary")


func _process(_delta: float) -> void:
	if not case_stopped:
		increase_value += speed
		case_container.scroll_horizontal = increase_value # The current horizontal scroll value
		if case_container.scroll_horizontal > high_limit:
			index_number += 1
			high_limit += 260


func create_item(item_rarity) -> void:
	# Select random item from the rarity
	var img_texture = randi() % item_list.get(item_rarity).size() # Array size for rarity
	var img = TextureRect.new() # New texture
	img.texture = item_list.get(item_rarity)[img_texture] # Set that texture to have chosen item
	wheel_items.append(img) # Add chosen item to wheel
	item_container.add_child(img)


func _on_Timer_timeout()  -> void:
	if speed > 0 and not case_stopped:
		speed -= 0.5
	elif speed <= 0:
		case_stopped = true
		panel.get_node("TextureRect").texture = wheel_items[index_number].texture
		panel.show()


func _on_ButtonPanel_pressed() -> void:
	queue_free()
