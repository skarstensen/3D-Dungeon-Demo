extends Node3D

class_name Map

enum Tile { OUT_OF_BOUNDS = -1, EMPTY_TILE, SOLID_TILE}

@export var mapBlockPrefab:PackedScene
@export var mapDataFile:PackedScene

@export var mapDimensions:Vector2i

var map:TileMap

func _ready():
	
	map = mapDataFile.instantiate() as TileMap
	
#	DungeonGenerator.generate(map, mapDimensions.x, mapDimensions.y, 5, 5)
	
	MapBuilder3d.generate(map, self, mapBlockPrefab)
	
	add_child(map)
	
	map.hide()

func getTileData(row, col):

	if (col < 0 || col >= mapDimensions.x):
		return Tile.OUT_OF_BOUNDS
		
	if (row < 0 || row >= mapDimensions.y):
		return Tile.OUT_OF_BOUNDS
		
	return map.get_cell_atlas_coords(0, Vector2i(col, row)).x
