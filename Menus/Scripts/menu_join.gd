extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	open_lobby_list()

func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
	
func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby,"name")
		var memb_count = Steam.getNumLobbyMembers(lobby)
		var but = Button.new()
		but.set_text(str(lobby_name," | Player Count: ", memb_count))
		but.set_size(Vector2(100,5))
		but.connect("pressed", Callable(self,"join_lobby").bind(lobby))
		$LobbyContainer/Lobbies.add_child(but)

func _on_refresh_pressed():
	if $LobbyContainer/Lobbies.get_child_count() > 0 :
		for n in $LobbyContainer/Lobbies.get_children():
			n.queue_free()
	open_lobby_list()

func _on_back_pressed():
	Menu.load_menu(Menu.MENU_LEVEL.MAIN)
