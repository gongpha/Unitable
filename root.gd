extends Control

onready var tab_import : TabImport = $"tab/นำเข้า"
onready var table : Table = $"tab/ตาราง/table"

func _ready():
	tab_import.connect("add_blocks", self, "_add_blocks")
	
func _add_blocks(b) :
	table.add_blocks(b)
