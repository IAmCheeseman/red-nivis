extends Resource
class_name DataManager

const SAVE_DIR = "user://saves/"


signal game_saved
signal data_cleared


func save_data(data : Dictionary, path):
	var save_path = SAVE_DIR+path
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "l14M@ M41")
	if error == OK:
		file.store_var(data)
		file.close()
		emit_signal("game_saved")
		return true


func load_data(path):
	var save_path = SAVE_DIR+path
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "l14M@ M41")
		if error == OK:
			var data = file.get_var()
			file.close()
			return data
	return false


func clear_data(path):
	var save_path = SAVE_DIR+path
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "l14M@ M41")
	if error == OK:
		file.store_var({})
		file.close()
	emit_signal("data_cleared")


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files

