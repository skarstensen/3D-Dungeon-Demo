extends Node3D

@export var map:Map
@export var player:Player
@export var playerStart:Vector2i

func _ready():
	if (map.random):
		setPlayerPosition(map.randomPlayerStart.x, map.randomPlayerStart.y)
	else:
		setPlayerPosition(playerStart.x, playerStart.y)
	

func _unhandled_key_input(event):
	
	if Input.is_action_just_pressed("ui_up"):
		moveForward()
	
	if Input.is_action_just_pressed("ui_left"):
		rotateCamera(90)
		
	if Input.is_action_just_pressed("ui_right"):
		rotateCamera(-90)

	if Input.is_action_just_pressed("map"):
		map.updateMarker(player.transform.origin.z, player.transform.origin.x)
		map.map.visible = !map.map.visible

################################################################################
# Camera/party movement functions
################################################################################
func setPlayerPosition(cellX, cellY):
	player.transform.origin.x = cellX
	player.transform.origin.z = cellY


func rotateCamera(amount):
	player.rotation_degrees.y += amount

	if (player.rotation_degrees.y < 0):
		player.rotation_degrees.y = 360 + player.rotation_degrees.y

	if (player.rotation_degrees.y == 360):
		player.rotation_degrees.y = 0


func moveForward():
	var destination = player.transform.origin - player.transform.basis.z
	
	# We need to round the values to cap 'em to the nearest whole number or else
	# the camera will start to 'float' off the grid.
	destination.x = round(destination.x)
	destination.z = round(destination.z)
	
	if (map.getTileData(destination.z, destination.x) == Map.Tile.EMPTY_TILE):
		setPlayerPosition(destination.x, destination.z)
		map.updateMarker(player.transform.origin.z, player.transform.origin.x)

