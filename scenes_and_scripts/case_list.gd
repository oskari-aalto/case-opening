extends GridContainer

var cases: int = 0

func _ready():
	for child in get_children():
		if get_children()[0].name.contains("Case"):
			cases += 1
	columns = cases
