extends Control
class_name Table

onready var table : VBoxContainer = $table
onready var draw : Control = $draw

const HTIME := preload("res://scene/element/t_head_time.tscn")
const RDAY := preload("res://scene/element/t_row_day.tscn")
const HBDY := preload("res://scene/element/t_head_body.tscn")

const DAYS := [
	["จันทร์", Color.yellow],
	["อังคาร", Color.magenta],
	["พุธ", Color.green],
	["พฤหัสบดี", Color.orange],
	["ศุกร์", Color.aqua],
	["เสาร์", Color.purple],
	["อาทิตย์", Color.red],
]

var float_ : Control
	
var blocks : Array

var dayrows : Array
var current_time := Vector3(8, 0, 0)

signal blocks_updated()
signal block_clicked()

func _ready() :
	call_deferred('imple')
	
func imple() :
	for r in [null] + DAYS :
		#if r == null :	
		
		var R : TableRowDay = RDAY.instance()
		if r != null :
			R.setup(r[0], r[1])
		else :
			R.setup("เวลา", Color.white)
		table.add_child(R, true)
		
		var rownodes : Array
		
		for t in 16 :
			var T : Control
			
			if r == null :
				T = HTIME.instance()
				T.setup(str(t + 1), "%02d:00 - %02d:00" % [t + 8, t + 9])
			else :
				T = HBDY.instance()
			R.add_child(T, true)
			rownodes.append(T)
			
		dayrows.append([
			R, rownodes
		])
	float_ = Control.new()
	float_.name = "0"
	float_.rect_min_size.y = 32
	table.add_child(float_, true)
	
func _clicked(b) :
	emit_signal('block_clicked', b)
	
func refresh_block(b : BlockSubject) :
	var bdata : Dictionary = b.data
	
	
	
	var start : Vector2 = bdata.get('teach_start', Vector2(8, 0))
	var end : Vector2 = bdata.get('teach_end', Vector2(9, 0))
	
	var thatday : Array = dayrows[bdata.get('day', 0) + 1] # +1 for header
	var timenode : TableHeadBody = thatday[1][int(start.x) - 8]
	
	var hourv : Vector2 = end - start
	var hour : float = hourv.x + (hourv.y / 60.0)
	
	if hour == 0.0 :
		b.free()
		return
		
	var arr : Array
	
	if b.added_id == -1 :
		arr = [
			b,
			timenode,
			hour
		]
	else :
		arr = blocks[b.added_id]
		arr[1] = timenode
		arr[2] = hour
	
	if b.added_id == -1 :
		Real.worldmas_array_push(blocks, arr)
		b.added_id = blocks.size() - 1
		
	_repos(arr)
	emit_signal('blocks_updated')

func add_blocks(bb : Array) :
	for b in bb :
		b.connect('clicked', self, '_clicked', [b])
		float_.add_child(b)
		refresh_block(b)
		
	repos_all()
	emit_signal('blocks_updated')

func _repos(a : Array) :
	a[0].rect_size.x = a[1].rect_size.x * a[2]
	a[0].rect_global_position = a[1].rect_global_position

func repos_all() :
	for b in blocks :
		_repos(b)
		
const TIMECOL := Color(1, 0, 0.5)

func _on_tableroot_resized() :
	call_deferred('repos_all')
	
static func timev_to_int(v : Vector3) -> int :
	return int(
		(v.x * 3600) +
		(v.y * 60) +
		v.z
	)

func _on_draw_draw() :
	var peak := table.rect_size
	if float_ :
		peak.y -= float_.rect_min_size.y
	
	var timex : float = lerp(100, peak.x,
		inverse_lerp(
			timev_to_int(Vector3(8, 0, 0)), timev_to_int(Vector3(24, 0, 0)),
			timev_to_int(current_time)
		)
	)
	
	var bottom := Vector2(timex, peak.y)
	
	draw.draw_line(Vector2(timex, 0), bottom, TIMECOL)
	var font := get_font("")
	var times := "%02d:%02d:%02d" % [current_time.x, current_time.y, current_time.z]
	var s := font.get_string_size(times)
	var dp := bottom + Vector2(-s.x / 2.0, s.y)
	draw.draw_string(font, dp, times, TIMECOL)
	


func _physics_process(delta : float) :
	var s := Time.get_time_dict_from_system()
	var v := Vector3(
		s.hour, s.minute, s.second
	)
	
	
	if v == current_time :
		return
		
	current_time = v
	draw.update()

func delete_block(b : BlockSubject) :
	assert(b.added_id != -1)
	
	blocks[b.added_id] = null
	Real.worldmas_array_optimize(blocks, b.added_id)
	
	b.free()
	
	emit_signal('blocks_updated')
