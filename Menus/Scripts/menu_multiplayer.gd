extends Control

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	open_lobby_list()

func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	Menu.load_menu(Menu.MENU_LEVEL.LOBBY)

func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	Menu.load_menu(Menu.MENU_LEVEL.LOBBY)

func _on_lobby_created(connected, id):
	if connected:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()+"'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)

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
