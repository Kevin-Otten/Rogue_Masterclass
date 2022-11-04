class Grid {
    construct new(width,height,z) {
        _width = width
        _height = height
        _grid = List.new()
        for (i in 0...(_width * _height) ) {
            _grid.add(z)
        }
    }

    [x,y]=(val){
        _grid[y * _width + x] = val
    }

    [x,y] { _grid[y * _width + x] }

    width { _width }
    height { _height}
}