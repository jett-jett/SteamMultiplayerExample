extends Node

enum MENU_LEVEL {
	NONE,
	MAIN,
	SINGLEPLAYER,
	MULTIPLAYER,
	OPTIONS
}

var menus = {
	MENU_LEVEL.MAIN : preload("res://menu_main.tscn").instantiate(),
	MENU_LEVEL.MULTIPLAYER : preload("res://menu_lobby.tscn").instantiate()
}

var current_menu : Node = null

func load_menu(menulevel):
	call_deferred("_deferred_load_menu", menulevel)
	
func _deferred_load_menu(menulevel):
	current_menu = menus[menulevel]
	var container = get_tree().current_scene.get_node("menu")
	if not container:
		var menunode = Node.new()
		menunode.set_name("menu")
		get_tree().current_scene.add_child(menunode)
		container = menunode
	for location in container.get_children():
		container.remove_child(location)
	container.add_child(current_menu)
	
func _ready():
	load_menu(MENU_LEVEL.MAIN)
