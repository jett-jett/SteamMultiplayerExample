extends Node

#Steam Variables
var is_on_steam_deck: bool = false
var is_online: bool = false
var is_owned: bool = false
var steam_app_id: int = 480
var steam_id: int = 0
var steam_username: String = ""

#Multiplayer Variables
var peer = SteamMultiplayerPeer.new()

#Lobby Infomation
var lobby_id = 0
var lobby_data
var lobby_members: Array = []
var lobby_members_max: int = 10
var lobby_vote_kick: bool = false

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
	
	#Multiplayer
	peer.lobby_created.connect(_on_lobby_created)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Steam.run_callbacks()
	pass

#Multiplayer

func _on_lobby_created(connected, id):
	if connected:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()+"'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print("Lobby ID: " + str(lobby_id))

func create_lobby():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer

func join_lobby(id):
	lobby_id = id
	peer.connect_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer

func leave_lobby() -> void:
	# If in a lobby, leave it
	if lobby_id != 0:
		# Send leave request to Steam
		Steam.leaveLobby(lobby_id)
		# Wipe the Steam lobby ID then display the default lobby ID and player list title
		lobby_id = 0
		# Close session with all users
		for this_member in lobby_members:
		# Make sure this isn't your Steam ID
			if this_member['steam_id'] != steam_id:
				# Close the P2P session
				Steam.closeP2PSessionWithUser(this_member['steam_id'])
		# Clear the local lobby list
		lobby_members.clear()

func get_lobby_members()-> void:
	# Clear your previous lobby list
	lobby_members.clear()
	# Get the number of members from this lobby from Steam
	var num_of_members: int = Steam.getNumLobbyMembers(lobby_id)
	# Get the data of these players from Steam
	for this_member in range(0, num_of_members):
		# Get the member's Steam ID
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, this_member)
		# Get the member's Steam name
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		# Add them to the list
		lobby_members.append({"steam_id":member_steam_id, "steam_name":member_steam_name})

# A user's information has changed
func _on_persona_change(this_steam_id: int, _flag: int) -> void:
	# Make sure you're in a lobby and this user is valid or Steam might spam your console log
	if lobby_id > 0:
		print("A user (%s) had information change, update the lobby list" % this_steam_id)
		# Update the player list
		get_lobby_members()
