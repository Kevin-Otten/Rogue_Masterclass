import "types" for Type
import "data_structures" for Grid
import "xs" for Render
import "game" for Game

class Level {

    static Initialize() {

        __tileSize = 16
        __width = 10
        __height = 10
        __levelGrid = Grid.new(__width, __height, Type.floor)

        
        var tilesImage = Render.loadImage("[game]/assets/tiles_dungeon.png")
        __emptySprite = Render.createGridSprite(tilesImage, 20, 24, 3, 0)
        __testFloorSprite = Render.createGridSprite(tilesImage, 20, 24, 2, 0)

        __wallSprites = [
            Render.createGridSprite(tilesImage, 20, 24, 0, 8),      // 0000
            Render.createGridSprite(tilesImage, 20, 24, 0, 11),     // 0001
            Render.createGridSprite(tilesImage, 20, 24, 1, 8),      // 0010
            Render.createGridSprite(tilesImage, 20, 24, 1, 10),     // 0011
            Render.createGridSprite(tilesImage, 20, 24, 0, 9),      // 0100
            Render.createGridSprite(tilesImage, 20, 24, 0, 10),     // 0101
            Render.createGridSprite(tilesImage, 20, 24, 1, 9),      // 0110
            Render.createGridSprite(tilesImage, 20, 24, 3, 11),     // 0111
            Render.createGridSprite(tilesImage, 20, 24, 3, 8),      // 1000
            Render.createGridSprite(tilesImage, 20, 24, 2, 10),     // 1001
            Render.createGridSprite(tilesImage, 20, 24, 2, 8),      // 1010
            Render.createGridSprite(tilesImage, 20, 24, 3, 10),     // 1011
            Render.createGridSprite(tilesImage, 20, 24, 2, 9),      // 1100
            Render.createGridSprite(tilesImage, 20, 24, 1, 11),     // 1101
            Render.createGridSprite(tilesImage, 20, 24, 2, 11),     // 1110
            Render.createGridSprite(tilesImage, 20, 24, 3, 9)       // 1111
        ]

        __floorSprites = [
            Render.createGridSprite(tilesImage, 20, 24, 14, 8),
            Render.createGridSprite(tilesImage, 20, 24, 15, 8),
            Render.createGridSprite(tilesImage, 20, 24, 14, 9),
            Render.createGridSprite(tilesImage, 20, 24, 15, 9)
        ]
    }

    static Render(){

        //Offset tile generation based of the amount and size of the tiles
        var startX = (__width) * (-__tileSize / 2)
        var startY = (__height)  * (-__tileSize / 2)

        for (y in 0...__height) {
            for (x in 0...__width) {

                var tileType = __levelGrid[x,y]
                var positionX = startX + x * __tileSize
                var positionY = startY + y * __tileSize
                
                if (tileType != Type.empty) {
                    Render.sprite(__testFloorSprite, positionX, positionY)
                } else {
                }
            }
        }
    }
}