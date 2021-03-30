extends Control



func _on_Connect_Button_pressed():
	Network.connect_to_host($Panel/Host.text, $Panel/Nickname.text)
