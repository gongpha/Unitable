extends VBoxContainer
class_name TabImport

onready var code : TextEdit = $code

const BLOCK := preload("res://scene/element/block_subject.tscn")

signal add_blocks

func kmitl_block(
	tstart : Vector2,
	tend : Vector2,
	day : int,
	s : Dictionary
) -> Dictionary :
	var b : Dictionary
	b.teach_start = tstart
	b.teach_end = tend
	b.day = day - 2
	
	b.tag = s.get('lect_or_prac', '')
	b.section = s.get('section', '')
	b.place = s.get('place', '')
	
	return b

func _on_import_pressed() :
	if code.text.empty() :
		return
		
	var res = JSON.parse(code.text)
	if res.error != OK :
		return
	var subjects : Array = res.result
	
	var block_nodes : Array
	
	for s in subjects :
		
		match 'KMITL' :
			'KMITL' :
				var bdata : Dictionary
				bdata.subject_name = s.get('subject_tname', "ไม่ทราบ")
				
				var regex := RegEx.new()
				var err := regex.compile('^([0-1]?[0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])?$')
				
				var ts : Vector2
				var te : Vector2
				var day : int
				
				# teach start
				var rgr := regex.search(s.get('teach_time', ''))
				if rgr == null :
					return false
					
				ts = Vector2(int(rgr.strings[1]), int(rgr.strings[2]))
				
				rgr = regex.search(s.get('teach_time2', ''))
				if rgr == null :
					return false
					
				te = Vector2(int(rgr.strings[1]), int(rgr.strings[2]))
				day = int(s.get('teach_day', '-1'))
				
				bdata = kmitl_block(ts, te, day, s)
				
				block_nodes.append(new_block(bdata))
				
				############################################################
				
				# extra
				var extrar = s.get('teachtime_str', '')
				if extrar is String :
					if !extrar.empty() :
						regex = RegEx.new()
						err = regex.compile('(\\d)x([0-9][0-9]):([0-9][0-9])-([0-9][0-9]):([0-9][0-9])')
						
						rgr = regex.search(extrar)
						if rgr == null :
							return false
							
						day = int(rgr.strings[1])
						ts = Vector2(int(rgr.strings[2]), int(rgr.strings[3]))
						te = Vector2(int(rgr.strings[4]), int(rgr.strings[5]))
						
						bdata.tag = s.get('lect_or_prac', '')
						block_nodes.append(new_block(bdata))
						
				bdata = kmitl_block(ts, te, day, s)
				block_nodes.append(new_block(bdata))
	
	emit_signal('add_blocks', block_nodes)
	
func new_block(dict : Dictionary) -> BlockSubject :
	var b : BlockSubject = BLOCK.instance()
	b.setup(dict)
	return b
