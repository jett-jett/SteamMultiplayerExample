extends Control

func _on_host_pressed():
	Menu.load_menu(Menu.MENU_LEVEL.HOST)


func _on_button_pressed():
	Menu.load_menu(Menu.MENU_LEVEL.JOIN)
