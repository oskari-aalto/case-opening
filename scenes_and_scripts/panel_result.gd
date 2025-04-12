extends Panel


signal result_button_pressed


@onready var fade_layer: ColorRect = $ColorRect
@onready var button: Button = $Button
@onready var result_item: TextureRect = $ResultItem
@onready var tween1: Tween
@onready var tween2: Tween


func appear(item: Texture2D) -> void:
	self.show()
	if item != null:
		result_item.texture = item
	else:
		result_item.texture = load("res://sprites/gold_gold_gold_250x250.png")
	result_item.show()
	tween1 = create_tween()
	tween2 = create_tween()
	tween1.tween_property(fade_layer,"modulate", Color(0,0,0,0), 2)
	tween2.tween_property(result_item,"scale", Vector2(1.25,1.25), 2)
	tween1.play()
	tween2.play()
	await tween1.finished
	await tween2.finished
	fade_layer.hide()
	button.show()


func _on_button_pressed() -> void:
	result_button_pressed.emit()
