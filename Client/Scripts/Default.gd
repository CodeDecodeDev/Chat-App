extends Control



func _on_Connect_Button_pressed():
	Network._connect($Panel/Host.text, $Panel/Nickname.text)
	get_tree().change_scene("res://Scenes/Chat.tscn")
