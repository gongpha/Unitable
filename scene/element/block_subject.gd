extends Panel
class_name BlockSubject

var data : Dictionary

export var panel_normal : StyleBox
export var panel_hover : StyleBox
export var tcolor_normal : Color
export var tcolor_hover : Color

export var tag_lec : Color
export var tag_pra : Color

var panel : Panel
var sname : Label
var section : Label
var place : Label

var added_id : int = -1

signal clicked()

func setup(data_ : Dictionary) :
	data = data_
	sname = $name
	section = $section
	place = $place
	
	refresh()
	
func refresh() :
	var SECTION : String = data.get('section', String())
	var PLACE : String = data.get('place', String())
	
	section.visible = !SECTION.empty()
	section.text = SECTION
	
	sname.text = data.get('subject_name', String())
	
	place.visible = !PLACE.empty()
	place.text = PLACE
	
	
	_on_block_mouse_exited()
	
	var bstyleb := StyleBoxFlat.new()
	bstyleb.draw_center = false
	bstyleb.border_width_bottom = 2.0
	bstyleb.border_width_top = 2.0
	bstyleb.border_width_left = 2.0
	bstyleb.border_width_right = 2.0
	
	match data.get('tag') :
		'ท' :
			bstyleb.border_color = tag_lec
		'ป' :
			bstyleb.border_color = tag_pra
		_ :
			bstyleb = null
			
	if bstyleb != null :
		var bpanel := Panel.new()
		bpanel.add_stylebox_override('panel', bstyleb)
		bpanel.set_anchors_and_margins_preset(Control.PRESET_WIDE)
		bpanel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bpanel)
	


func _on_block_mouse_entered() :
	add_stylebox_override('panel', panel_hover)
	sname.add_color_override('font_color', tcolor_hover)


func _on_block_mouse_exited() :
	add_stylebox_override('panel', panel_normal)
	sname.add_color_override('font_color', tcolor_normal)
	


func _on_block_gui_input(event) :
	if event is InputEventMouseButton :
		if event.pressed and event.button_index == BUTTON_LEFT :
			emit_signal("clicked")
