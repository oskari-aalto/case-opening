extends VBoxContainer


var case_opening = preload("res://scenes_and_scripts/case_opening.tscn")

# Arrays of 2D textures. Representing the items available on each rarity tier
@export var uncommon_items: Array[Texture2D]
@export var rare_items: Array[Texture2D]
@export var very_rare_items: Array[Texture2D]
@export var epic_items: Array[Texture2D]
@export var legendary_items: Array[Texture2D]

# All of case content in Dictionary. Where key is the rarity of the item
var case_item_list: Dictionary = {}

# Drop chances
@export var uncommon_chance: int = 7446
@export var rare_chance: int = 1800
@export var very_rare_chance: int = 500
@export var epic_chance: int = 190
@export var legendary_chance: int = 64
var case_drop_chances: Dictionary = {}

func _ready():
	case_item_list = {
		"uncommon_items": uncommon_items,
		"rare_items": rare_items,
		"very_rare_items": very_rare_items,
		"epic_items": very_rare_items,
		"legendary_items": legendary_items
	}
	case_drop_chances = {
		"uncommon": uncommon_chance,
		"rare": rare_chance,
		"very_rare": very_rare_chance,
		"epic": very_rare_chance,
		"legendary": legendary_chance
	}


func _on_Button_pressed():
	var opening_scene = case_opening.instantiate()
	opening_scene.item_list = case_item_list
	opening_scene.drop_chances = case_drop_chances
	get_tree().get_root().add_child(opening_scene)
