extends Control

onready var tab_import : TabImport = $"tab/นำเข้า"
onready var table : Table = $"tab/ตาราง/table"
onready var datetime : Label = $datetime

const DAYS := [
	"วันอาทิตย์", "วันจันทร์", "วันอังคาร", "วันพุธ", "วันพฤหัสบดี", "วันศุกร์", "วันเสาร์"
]

const MONTHS := [
	"มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
]

func _ready():
	tab_import.connect("add_blocks", self, "_add_blocks")
	_on_tick_timeout()
	
func _add_blocks(b) :
	table.add_blocks(b)

func _on_tick_timeout() :
	var t := Time.get_datetime_dict_from_system()
	datetime.text = "%s ที่ %d %s พ.ศ. %d ณ %02d:%02d:%02d น." % [
		DAYS[t.weekday],
		t.day,
		MONTHS[t.month - 1],
		t.year + 543,
		t.hour,
		t.minute,
		t.second
	]
