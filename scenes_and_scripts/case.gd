extends VBoxContainer


# Arrays of 2D textures. Representing the items available on each rarity tiers
@export var uncommon_items: Array[Texture2D]
@export var rare_items: Array[Texture2D]
@export var very_rare_items: Array[Texture2D]
@export var epic_items: Array[Texture2D]
@export var legendary_items: Array[Texture2D]

# All of case content in Dictionary. Where key is the rarity of the item
var case_items: Dictionary = {}

# Drop chances C-OPS
@export var uncommon_chance: int = 7446
@export var rare_chance: int = 1800
@export var very_rare_chance: int = 500
@export var epic_chance: int = 190
@export var legendary_chance: int = 64

var case_drop_chances: Dictionary = {}


func _ready():
	case_items = {
		"uncommon": uncommon_items,
		"rare": rare_items,
		"very_rare": very_rare_items,
		"epic": very_rare_items,
		"legendary": legendary_items
	}
	case_drop_chances = {
		"uncommon": uncommon_chance,
		"rare": rare_chance,
		"very_rare": very_rare_chance,
		"epic": epic_chance,
		"legendary": legendary_chance
	}


func _on_Button_pressed():
	var case_opening_recourse = load("res://scenes_and_scripts/case_opening.tscn")
	var case_opening = case_opening_recourse.instantiate()
	# Set data and connections first
	case_opening.case_items = case_items
	case_opening.drop_chances = case_drop_chances
	case_opening.completed.connect(_on_case_opening_completed)
	# Add case opening as child to the first node after root ("Main")
	get_tree().get_root().get_child(0).add_child(case_opening)
	self.hide()


func _on_case_opening_completed():
	self.show()
