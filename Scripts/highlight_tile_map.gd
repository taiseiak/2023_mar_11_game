class_name HighlightTileMap
extends TileMap


enum {
	DATA_LAYER = 0,
	SELECTION_LAYER = 1,
	PATH_HIGHLIGHT_LAYER = 2,
}


const HIGHLIGHT_LAYER: int = 1
const HIGHLIGHT_CELL_ID: int = 2
const HIGHLIGH_CELL_ATLAS_COORDS := Vector2i(1, 0)
const ALLOWED_CUSTOM_DATA_LAYER: String = "Moveable"


## Cells should be Array[Vector2i]. Somehow bringing errors if I type hint this.
func highlight_cells(cells: Array, highlight_layer: int):
		clear_layer(highlight_layer)
		for cell in cells:
			var cell_data = get_cell_tile_data(0, cell)
			if cell_data:
				if cell_data.get_custom_data(ALLOWED_CUSTOM_DATA_LAYER) == true:
					set_cell(highlight_layer, cell, HIGHLIGHT_CELL_ID,
							HIGHLIGH_CELL_ATLAS_COORDS)


func clear_highlight_cells():
	clear_layer(SELECTION_LAYER)
	clear_layer(PATH_HIGHLIGHT_LAYER)
