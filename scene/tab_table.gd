extends VBoxContainer

onready var daynodes := [
	$"hbox2/day_m",
	$"hbox2/day_t",
	$"hbox2/day_w",
	$"hbox2/day_th",
	$"hbox2/day_f",
	$"hbox2/day_sa",
	$"hbox2/day_s"
]

onready var propnodes := {
	"subject_name" : $hbox/vbox/subject_name,
	"where" : $hbox/vbox/where,
	"section" : $hbox/vbox3/section,
	"tag" : $hbox/vbox3/tag,
	"teachstart" : $hbox/vbox2/teachstart,
	"teachend" : $hbox/vbox2/teachend,
	"teachday" : $hbox/vbox2/teachday,
}

onready var table : Table = $scroll/table
onready var total : Label = $hbox2/total

const BLOCKSUBJECT := preload('res://scene/element/block_subject.tscn')

var current_block : BlockSubject

func set_day_is_free(day : int, free : bool) :
	var dayn : Label = daynodes[day]
	var box : StyleBoxFlat = dayn.get_stylebox('normal')
	
	if free :
		box.draw_center = true
		box.border_width_bottom = 0.0
		box.border_width_left = 0.0
		box.border_width_right = 0.0
		box.border_width_top = 0.0
		dayn.add_color_override('font_color', Color.black)
	else :
		box.draw_center = false
		box.border_width_bottom = 1.0
		box.border_width_left = 1.0
		box.border_width_right = 1.0
		box.border_width_top = 1.0
		box.border_color = box.bg_color
		dayn.add_color_override('font_color', Color.white)


func _on_add_block_pressed() :
	var b : BlockSubject = BLOCKSUBJECT.instance()
	b.setup({})
	table.add_blocks([b])
	
	_on_table_block_clicked(b)

func _on_table_blocks_updated() :
	for d in 7 :
		set_day_is_free(d, true)
		
	var hour_total : int = 0
		
	for b in table.blocks :
		var data : Dictionary = b[0].data
		
		var start : Vector2 = data.get('teach_start', Vector2(8, 0))
		var end : Vector2 = data.get('teach_end', Vector2(9, 0))
		
		var hour : float = end.x - start.x
		hour_total += hour
		
		var d : int = data.get('day', 0)
		set_day_is_free(d, false)
	
	total.text = "%d หน่วยกิต" % hour_total

func _on_table_block_clicked(b : BlockSubject) :
	if current_block == b :
		return
		
	current_block = b
	
	var prop := {
		"subject_name" : b.sname.text,
		"where" : b.data.get('place', ''),
		"section" : b.data.get('section', ''),
		"tag" : b.data.get('tag', ''),
		"teachstart" : b.data.get('teach_start', Vector2(8, 0)),
		"teachend" : b.data.get('teach_end', Vector2(9, 0)),
		"teachday" : b.data.get('day', 0),
	}
	
	for k in prop :
		var pn : Prop = propnodes[k]
		pn.set_value(prop[k])

func _on_update_field_pressed() :
	if !current_block :
		return
		
	var start = propnodes.teachstart.get_value()
	var end = propnodes.teachend.get_value()
	
	if start == end :
		return
		
	current_block.data.subject_name = propnodes.subject_name.get_value()
	current_block.data.place = propnodes.where.get_value()
	current_block.data.section = propnodes.section.get_value()
	current_block.data.tag = propnodes.tag.get_value()
	current_block.data.teach_start = start
	current_block.data.teach_end = end
	current_block.data.day = int(propnodes.teachday.get_value())
	
	current_block.refresh()
	table.refresh_block(current_block)
	
func _on_delete_block_pressed() :
	if !current_block :
		return
		
	table.delete_block(current_block)
	
	current_block = null
