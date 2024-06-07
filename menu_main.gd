extends Control

var lobby_scene = preload("res://menu_lobby.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_multiplayer_pressed():
	get_tree().root.add_child(lobby_scene)
	$".".hide()
	
