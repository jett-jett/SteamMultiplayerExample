extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Steam.avatar_loaded.connect(_on_loaded_avatar)
	Steam.getPlayerAvatar()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_loaded_avatar(user_id: int, avatar_size: int, avatar_buffer: PackedByteArray) -> void:
	print("Avatar for user: %s" % user_id)
	print("Size: %s" % avatar_size)
	# Create the image and texture for loading
	var avatar_image: Image = Image.create_from_data(avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)
	# Optionally resize the image if it is too large
	if avatar_size > 128:
		avatar_image.resize(128, 128, Image.INTERPOLATE_LANCZOS)
	# Apply the image to a texture
	var avatar_texture: ImageTexture = ImageTexture.create_from_image(avatar_image)
	# Set the texture to a Sprite, TextureRect, etc.
	var sprite = Sprite2D.new()
	sprite.set_texture(avatar_texture)
	$PlayerPictureContainer.add_child(sprite)

func _on_leave_pressed():
	Menu.load_menu(Menu.MENU_LEVEL.MAIN)

func _on_invite_pressed():
	pass # Replace with function body.
