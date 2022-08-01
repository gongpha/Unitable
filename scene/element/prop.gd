extends HBoxContainer
class_name Prop

export var fname : String = '@@@'
export var hint : String = ''
export var vectorclock : Vector2

onready var n := $n
onready var f := $f
onready var f2 := $f2
onready var d := $d

export var is_vector : bool = false
export var is_day : bool = false

func _ready() :
	n.text = fname
	f.placeholder_text = hint
	
	if !is_vector :
		f2.free()
	else :
		f.text = str(vectorclock.x)
		f2.text = str(vectorclock.y)
		
	if !is_day :
		d.free()
	else :
		f.free()

func set_value(v) :
	if is_day :
		d.select(v)
		return
	if is_vector :
		f.text = str(v.x)
		f2.text = str(v.y)
	else :
		f.text = str(v)

func get_value() :
	if is_day :
		return d.selected
		
	if is_vector :
		return Vector2(clamp(float(f.text), 8, 23), clamp(float(f2.text), 0, 59))
	return f.text
