extends Control

var black_list = ["", " "]

func _on_Send_pressed():
	if not $Input.text in black_list:
		Network.send_to_host($Input.text)
		$Input.text = ""
