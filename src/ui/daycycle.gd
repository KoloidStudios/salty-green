extends Control

@onready var day_label: Label = %day_label
@onready var time_label: Label = %time_label

#for label
func set_daytime(day: int, hour: int, minute: int) -> void:
	day_label.text = "day" + str(day + 1)
	time_label.text = _amfm_hour(hour) + ":" + _minute(minute) + " " + _am_pm(hour)

#conversion things
func _amfm_hour(hour:int) -> String:
	if hour == 0:
		return str(12)
	if hour > 12:
		return str(hour - 12)
	return str(hour)

func _minute(minute:int) -> String:
	if minute < 10:
		return "0" + str(minute)
	return str(minute)

func _am_pm(hour:int) -> String:
	if hour < 12:
		return "am"
	else:
		return "pm"
