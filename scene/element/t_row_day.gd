extends HBoxContainer
class_name TableRowDay

func setup(
	text : String,
	col : Color
) :
	var t : Label = $"h/0"
	t.add_color_override("font_color", col)
	t.text = text
