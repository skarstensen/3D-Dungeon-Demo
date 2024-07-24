extends Node3D

class_name Map

enum Tile { OUT_OF_BOUNDS = -1, EMPTY_TILE, SOLID_TILE}

@export var mapBlockPrefab:PackedScene
@export var mapDataFile:PackedScene
@export var playerMarker:Texture2D

@export var mapDimensions:Vector2i

var map:TileMap
var marker:Sprite2D

func _ready():
	marker = Sprite2D.new()
	marker.texture = playerMarker
	marker.scale.x = 0.125
	marker.scale.y = 0.125
	marker.offset.x = 64
	marker.offset.y = 64
	
	map = mapDataFile.instantiate() as TileMap
	
#	DungeonGenerator.generate(map, mapDimensions.x, mapDimensions.y, 5, 5)
	
	MapBuilder3d.generate(map, self, mapBlockPrefab)
	
	add_child(map)
	map.add_child(marker)
	
	map.hide()

func getTileData(row, col):

	if (col < 0 || col >= mapDimensions.x):
		return Tile.OUT_OF_BOUNDS
		
	if (row < 0 || row >= mapDimensions.y):
		return Tile.OUT_OF_BOUNDS
		
	return map.get_cell_atlas_coords(0, Vector2i(col, row)).x


func updateMarker(row:int, col:int):
	marker.position.x = col * map.tile_set.tile_size.x
	marker.position.y = row * map.tile_set.tile_size.y
