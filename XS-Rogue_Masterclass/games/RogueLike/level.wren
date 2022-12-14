import "types" for Type, Directions
import "data_structures" for Grid
import "xs" for Render
import "xs_math" for Vec2
import "game" for Game

class Level {

    static Init() {

        __tileSize = 16
        __width = 21
        __height = 21
        __levelGrid = Grid.new(__width, __height, Type.wall)
        __gameplayGrid = Grid.new(__width, __height, Type.empty)

        var tilesImage = Render.loadImage("[game]/assets/tiles_dungeon.png")
        var heroImage = Render.loadImage("[game]/assets/chara_hero.png")
        var ratImage = Render.loadImage("[game]/assets/chara_rat.png")

        __emptySprite = Render.createGridSprite(tilesImage, 20, 24, 3, 0)
        __testFloorSprite = Render.createGridSprite(tilesImage, 20, 24, 2, 0)
        __playerSprite = Render.createGridSprite(heroImage, 4, 11, 0, 0)
        __enemySprite = Render.createGridSprite(ratImage, 4, 11, 0, 0)

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
                    if (tileType == Type.wall) {
                        var neighbourPos = Vec2.new(x, y)  
                        var flag = 0
                        for(i in 0...4) {
                            var neighbour = neighbourPos + Directions[i]
                            if(__levelGrid.valid(neighbour.x, neighbour.y) && __levelGrid[neighbour.x, neighbour.y] == Type.wall) {
                                flag = flag | 1 << i  // |
                            }
                        }
                        Render.sprite(__wallSprites[flag], positionX, positionY)
                    } else {
                        Render.sprite(__testFloorSprite, positionX, positionY)
                    }
                } else {
                    Render.sprite(__emptySprite, positionX, positionY)
                }
            }
        }

        for (y in 0...__height) {
            for (x in 0...__width) {

                var tileType = __gameplayGrid[x,y]
                var positionX = startX + x * __tileSize
                var positionY = startY + y * __tileSize

                //Applying offset sicne the players sprite is larger than the tiles
                positionX = positionX - __tileSize
                positionY = positionY - __tileSize

                if (tileType == Type.player){
                    Render.sprite(__playerSprite, positionX, positionY)
                } else if(tileType == Type.enemy){
                    Render.sprite(__enemySprite, positionX, positionY)
                }
            }
        }
    }

    static width {__width}
    static height {__height}
    static levelGrid {__levelGrid}
    static gameplayGrid {__gameplayGrid}

    static IsInBounds(x,y){
        
        var inBounds = true
        if(x < 0 || x > __width - 1 || y < 0 || y > __height - 1){
            inBounds = false
        }
        return inBounds

    }
}