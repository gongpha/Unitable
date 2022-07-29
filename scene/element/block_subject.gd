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

func setup(sname_ : String, data_ : Dictionary) :
	data = data_
	sname = $name
	
	sname.text = sname_
	section = $section
	place = $place
	
	var SECTION : String = data_.get('section', String())
	var PLACE : String = data_.get('place', String())
	
	if SECTION.empty() :
		section.free()
		section = null
	else :
		section.text = SECTION
	
	if PLACE.empty() :
		place.free()
		place = null
	else :
		place.text = PLACE
	
	
	_on_block_mouse_exited()
	
	var bstyleb := StyleBoxFlat.new()
	bstyleb.draw_center = false
	bstyleb.border_width_bottom = 2.0
	bstyleb.border_width_top = 2.0
	bstyleb.border_width_left = 2.0
	bstyleb.border_width_right = 2.0
	
	match data_.get('tag') :
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
	
