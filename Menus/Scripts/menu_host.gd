extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	#peer.connect_lobby(id)
	#multiplayer.multiplayer_peer = peer
	#lobby_id = id
	Menu.load_menu(Menu.MENU_LEVEL.LOBBY)


func _on_back_pressed():
	Menu.load_menu(Menu.MENU_LEVEL.MAIN)
