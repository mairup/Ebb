class_name DualGridManager
extends Node2D

@export var tile_set: TileSet

const SOURCE := 0
const BLOCK_HEIGHT := 4
const DIRT_ATLAS := Vector2i(0, 3)  # dirt tile, bottom-left of block 0

# Add a biome here (and to the enum) and nothing else.
# block = which 4-row block of the atlas, base = what it sits on.
const BIOMES := {
	BiomeData.Biome.GRASS: {"block": 0, "base": BiomeData.Biome.DIRT},
	BiomeData.Biome.WHITE: {"block": 1, "base": BiomeData.Biome.GRASS},
	BiomeData.Biome.RED:   {"block": 2, "base": BiomeData.Biome.GRASS},
}

# Bits: TL=1, TR=2, BL=4, BR=8
const NEIGHBOR_TO_ATLAS := {
	0b0001: Vector2i(3, 3), 0b0010: Vector2i(0, 2), 0b0011: Vector2i(1, 2),
	0b0100: Vector2i(0, 0), 0b0101: Vector2i(3, 2), 0b0110: Vector2i(2, 3),
	0b0111: Vector2i(3, 1), 0b1000: Vector2i(1, 3), 0b1001: Vector2i(0, 1),
	0b1010: Vector2i(1, 0), 0b1011: Vector2i(2, 2), 0b1100: Vector2i(3, 0),
	0b1101: Vector2i(2, 0), 0b1110: Vector2i(1, 1), 0b1111: Vector2i(2, 1),
}

var _world: Dictionary = {}           # Vector2i -> BiomeData.Biome
var _layers: Array[TileMapLayer] = [] # index = tier
var _tier_biomes: Array = []          # _tier_biomes[tier] = [biomes in that tier]
var _fill: Dictionary = {}            # biome -> { biome: true, ... } counted as "filled"
var _top_tier := 0

func _ready() -> void:
	_build_biome_tables()
	var offset := -Vector2(tile_set.tile_size) / 2.0
	for t in range(_top_tier + 1):
		var layer := TileMapLayer.new()
		layer.tile_set = tile_set
		layer.position = offset
		add_child(layer)  # added in tier order, so higher tiers draw on top
		_layers.append(layer)

func _build_biome_tables() -> void:
	# Tier = depth in the base chain
	var tiers := {}
	for b in BIOMES:
		var t := 0
		var cur: int = b
		while cur != BiomeData.Biome.DIRT:
			t += 1
			cur = BIOMES[cur]["base"]
		tiers[b] = t
		_top_tier = max(_top_tier, t)

	_tier_biomes.resize(_top_tier + 1)
	for i in _tier_biomes.size():
		_tier_biomes[i] = []
	for b in BIOMES:
		_tier_biomes[tiers[b]].append(b)

	# Fill set: a biome plus everything that sits on it
	for b in BIOMES:
		_fill[b] = {}
	for b in BIOMES:
		var cur: int = b
		while cur != BiomeData.Biome.DIRT:
			_fill[cur][b] = true
			cur = BIOMES[cur]["base"]

# ---- Public API ----

## Draws the whole world from scratch.
##
## Clears every layer, then draws tiles for all cells in [param world].
## Cells missing from the dictionary are treated as [constant BiomeData.Biome.DIRT].
##
## [param world]: [Dictionary] mapping [Vector2i] cell positions (in tile units)
## to [enum BiomeData.Biome] values.
##
## Example:
## [codeblock]
## var world := {
##     Vector2i(0, 0): BiomeData.Biome.GRASS,
##     Vector2i(1, 0): BiomeData.Biome.WHITE,
## }
## dual_grid.render_world(world)
## [/codeblock]
func render_world(world: Dictionary) -> void:
	_world = world
	for layer in _layers:
		layer.clear()
	update_cells(world.keys())

# Redraw only around these world cells (use this for chunks or changes later).
func update_cells(world_cells: Array) -> void:
	var todo := {}
	for c in world_cells:
		# A world cell touches 4 display cells
		for o in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]:
			todo[c + o] = true
	for d in todo:
		_render_cell(d)

# ---- Internals ----

func _biome_at(c: Vector2i) -> int:
	return _world.get(c, BiomeData.Biome.DIRT)

func _mask(d: Vector2i, biome: int) -> int:
	var fill: Dictionary = _fill[biome]
	var mask := 0
	if _biome_at(d + Vector2i(-1, -1)) in fill: mask |= 1  # TL
	if _biome_at(d + Vector2i( 0, -1)) in fill: mask |= 2  # TR
	if _biome_at(d + Vector2i(-1,  0)) in fill: mask |= 4  # BL
	if _biome_at(d + Vector2i( 0,  0)) in fill: mask |= 8  # BR
	return mask

func _render_cell(d: Vector2i) -> void:
	var covered := false
	for tier in range(_top_tier, 0, -1):
		var layer := _layers[tier]
		var drawn := false
		if not covered:
			for biome in _tier_biomes[tier]:
				var mask := _mask(d, biome)
				if mask != 0:
					var atlas: Vector2i = NEIGHBOR_TO_ATLAS[mask] \
						+ Vector2i(0, BIOMES[biome]["block"] * BLOCK_HEIGHT)
					layer.set_cell(d, SOURCE, atlas)
					drawn = true
					covered = mask == 0b1111
					break
		if not drawn:
			layer.erase_cell(d)

	if covered:
		_layers[0].erase_cell(d)
	else:
		_layers[0].set_cell(d, SOURCE, DIRT_ATLAS)
