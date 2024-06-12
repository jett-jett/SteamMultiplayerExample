extends Node

#Steam Variables
var is_on_steam_deck: bool = false
var is_online: bool = false
var is_owned: bool = false
var steam_app_id: int = 480
var steam_id: int = 0
var steam_username: String = ""

#Multiplayer Variables
var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

func _init():
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))

func _ready():
	initialize_steam()

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s " % initialize_response)
	if initialize_response['status'] > 0:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)
		#get_tree().quit()
		
	# Gather additional data
	is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
	is_online = Steam.loggedOn()
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Steam.run_callbacks()
	pass


func _on_lobby_created(connected, id):
	if connected:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()+"'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)

func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	Menu.load_menu(Menu.MENU_LEVEL.LOBBY)



