extends Resource
class_name Log

export var day := 1
export var month := 1
export var year := 9208

export(
	String,
	"LOGGER_SYSTEM",
	"LOGGER_HANK",
	"LOGGER_GNOME",
	"LOGGER_BILL",
	"LOGGER_BRUCE",
	"LOGGER_ADRIAN",
	"LOGGER_JERRY",
	"LOGGER_YOU"
) var logger := "LOGGER_SYSTEM"

export var text := "LOG"
