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
		
		for t in 12 :
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
	table.add_child(float_, true)

func add_blocks(bb : Array) :
	for b in bb :
		var block : BlockSubject = b
		var bdata : Dictionary = b.data
		
		var thatday : Array = dayrows[bdata.day + 1] # +1 for header
		var timenode : TableHeadBody = thatday[1][int(bdata.teach_start.x) - 8]
		
		var hourv : Vector2 = bdata.teach_end - bdata.teach_start
		var hour : float = hourv.x + (hourv.y / 60.0)
		
		if hour == 0.0 :
			b.free()
			return
			
		var arr := [
			b,
			timenode,
			hour
		]
		
		_repos(arr)
		
		float_.add_child(b)
		blocks.append(arr)
		
	repos_all()

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
	
	var timex : float = lerp(100, peak.x,
		inverse_lerp(
			timev_to_int(Vector3(8, 0, 0)), timev_to_int(Vector3(20, 0, 0)),
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
