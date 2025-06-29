extends Node

var player_id := ""
var session_data := {}
var start_time := 0
var session_id := 0

func _ready():
	randomize()
	player_id = _generate_uuid()
	_ensure_player_metrics_folder()

func _ensure_player_metrics_folder():
	var player_metrics_path = "user://metrics/" + player_id
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("metrics"):
		dir.make_dir("metrics")
	if not dir.dir_exists("metrics/" + player_id):
		dir.make_dir("metrics/" + player_id)

func _generate_uuid() -> String:
	var hex = "0123456789abcdef"
	var uuid = ""
	for i in 32:
		if i in [8, 12, 16, 20]:
			uuid += "-"
		if i == 12:
			uuid += "4"
		elif i == 16:
			uuid += hex[8 + randi() % 4]
		else:
			uuid += hex[randi() % 16]
	return uuid

func start_session(name: String):
	session_id += 1
	start_time = Time.get_unix_time_from_system()
	session_data = {
		"session_name": name,
		"session_id": session_id,
		"start_time": start_time,
		"events": [],
		"duration": 0
	}
	print("session %s started" % name)

func log_event(name: String, extra_data := {}):
	if !session_data:
		return
	session_data["events"].append({
		"time": Time.get_unix_time_from_system() - start_time,
		"event": name,
		"data": extra_data
	})
	print("event %s logged" % name)

func end_session():
	if !session_data:
		return
	session_data["duration"] = Time.get_unix_time_from_system() - start_time
	_save_json()
	_save_xml()
	print("session %s ended and files saved" % name)

func _save_json():
	if !session_data:
		return
	var folder_path = "user://metrics/%s" % player_id
	var file_path = "%s/session_%s.json" % [folder_path, session_id]
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(session_data, "\t"))
		file.close()

func _save_xml():
	if !session_data:
		return
	var folder_path = "user://metrics/%s" % player_id
	var file_path = "%s/session_%s.xml" % [folder_path, session_id]
	var xml_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<session>\n"
	xml_string += "\t<id>%d</id>\n" % session_data["session_id"]
	xml_string += "\t<start_time>%d</start_time>\n" % session_data["start_time"]
	xml_string += "\t<duration>%d</duration>\n" % session_data["duration"]
	xml_string += "\t<events>\n"
	for ev in session_data["events"]:
		xml_string += "\t\t<event>\n"
		xml_string += "\t\t\t<time>%d</time>\n" % ev["time"]
		xml_string += "\t\t\t<name>%s</name>\n" % ev["event"]
		if ev.has("data"):
			xml_string += "\t\t\t<data>%s</data>\n" % str(ev["data"])
		xml_string += "\t\t</event>\n"
	xml_string += "\t</events>\n</session>"

	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(xml_string)
		file.close()
