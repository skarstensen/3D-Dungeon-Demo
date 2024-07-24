extends Node

var tiles = []
var blocks = []

var width
var height

var entities:Dictionary = {}

func generate(map:TileMap, container:Node3D, prefab):
	
	for deletable in container.get_children():
		deletable.queue_free()
	
	initMapData(map)
	buildMap(container, prefab)
	
	
func initMapData(tilemap:TileMap):
	var x = 0
	var y = 0
	
	tiles.clear()
	blocks.clear()
	entities.clear()
	
	# map dimensions
	while tilemap.get_cell_atlas_coords(0, Vector2i(x, y)).x != Map.Tile.OUT_OF_BOUNDS:
		while tilemap.get_cell_atlas_coords(0, Vector2i(x, y)).y != Map.Tile.OUT_OF_BOUNDS:
			x = x + 1
			
		width = x
		
		x = 0
		y = y + 1
	
	height = y
	
	tiles.resize(height)
	blocks.resize(height)
	
	print("tilemap is %sx%s" % [width, height])
	
	# map init
	for row in range(height):
		tiles[row] = []
		tiles[row].resize(width)
		
		blocks[row] = []
		blocks[row].resize(width)
	
	# parse map data
	for col in range(width):
		for row in range(height):
			tiles[row][col] = tilemap.get_cell_atlas_coords(0, Vector2i(col, row)).x


func getTileData(row, col):

	if (col < 0 || col >= width):
		return Map.Tile.OUT_OF_BOUNDS
		
	if (row < 0 || row >= height):
		return Map.Tile.OUT_OF_BOUNDS
		
	return tiles[row][col]
	
	
func buildMap(blockContainer:Node3D, block):
	
	var newBlock
	
	for row in range(height):
		for col in range(width):
			
			if (getTileData(row, col) == Map.Tile.EMPTY_TILE):
				newBlock = constructBlock(row, col, block)
			
				newBlock.transform.origin.x = col
				newBlock.transform.origin.z = row
			
				blocks[row][col] = newBlock
				
				blockContainer.add_child(newBlock)


func constructBlock(row, col, block):
	
	var b = block.instantiate()
	
	var adjacentBlock
	var wall
	
	if (col > 0):
		if (getTileData(row, col - 1) == Map.Tile.EMPTY_TILE):
			
			adjacentBlock = blocks[row][col - 1]
			
			if (adjacentBlock != null):
				
				wall = adjacentBlock.get_node_or_null("East Wall")
				
				if (wall != null):
					wall.queue_free()
		
			wall = b.get_node_or_null("West Wall")
			
			if (wall != null):
				wall.queue_free()
		
	if (row > 0):
		if (getTileData(row - 1, col) == Map.Tile.EMPTY_TILE):
			
			adjacentBlock = blocks[row - 1][col]
			
			if (adjacentBlock != null):
				
				wall = adjacentBlock.get_node_or_null("South Wall")
				
				if (wall != null):
					wall.queue_free()
		
			wall = b.get_node_or_null("North Wall")
			
			if (wall != null):
				wall.queue_free()
	
	return b
