extends TileMap


const HIGHLIGHT_LAYER: int = 1
const HIGHLIGHT_CELL_ID: int = 2
const HIGHLIGH_CELL_ATLAS_COORDS := Vector2i(1, 0)
const ALLOWED_CUSTOM_DATA_LAYER: String = "Moveable"


## Cells should be Array[Vector2i]. Somehow bringing errors if I type hint this.
func highlight_cells(cells: Array):
		clear_layer(HIGHLIGHT_LAYER)
		for cell in cells:
			var cell_data = get_cell_tile_data(0, cell)
			if cell_data:
				if cell_data.get_custom_data(ALLOWED_CUSTOM_DATA_LAYER) == true:
					set_cell(HIGHLIGHT_LAYER, cell, HIGHLIGHT_CELL_ID,
							HIGHLIGH_CELL_ATLAS_COORDS)
