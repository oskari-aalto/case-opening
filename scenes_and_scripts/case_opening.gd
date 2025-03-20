extends Control


@onready var case_container: ScrollContainer = $"CaseScrollContainer"
@onready var item_container: HBoxContainer = $"CaseScrollContainer/ItemContainer"
@onready var panel: Panel = $Panel


var item_list: Dictionary = {}

var drop_chances: Dictionary = {} # TODO
var uncommon: Array = range(1,7447)
var rare: Array = range(7447,9248)
var very_rare: Array = range(9248,9749)
var epic: Array = range(9749,9940)
var legendary: Array = range(9940,10005)


var texture_rects: Array = []
var increase_value: int = 0
var index_number = 2
var high_limit = 270
var speed = 40
var case_stopped = false


func _ready() -> void:
	# Scaling scroll bar so it won't show. Option to set scroll mode to Never show
	#case_container.get_h_scroll_bar().scale.x = 0
	# Set up RNG
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(uncommon[0],legendary[-1]):
		var chance = rng.randi_range(uncommon[0],legendary[-1])
		if chance in uncommon:
			create_item("uncommon_items")
		elif chance in rare:
			create_item("rare_items")
		elif chance in very_rare:
			create_item("very_rare_items")
		elif chance in epic:
			create_item("epic_items")
		else:
			create_item("legendary_items")


func _process(_delta: float) -> void:
	if not case_stopped:
		increase_value += speed
		case_container.scroll_horizontal = increase_value # The current horizontal scroll value
		if case_container.scroll_horizontal > high_limit:
			index_number += 1
			high_limit += 260


func create_item(item_type_key) -> void:
	var img_texture = randi() % item_list.get(item_type_key).size()
	var img = TextureRect.new()
	img.texture = item_list.get(item_type_key)[img_texture]
	texture_rects.append(img)
	item_container.add_child(img)


func _on_Timer_timeout()  -> void:
	if speed > 0 and not case_stopped:
		speed -= 0.5
	elif speed <= 0:
		case_stopped = true
		panel.get_node("TextureRect").texture = texture_rects[index_number].texture
		panel.show()


func _on_ButtonPanel_pressed() -> void:
	queue_free()
