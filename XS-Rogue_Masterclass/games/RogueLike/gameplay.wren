import "xs" for Input
import "level" for Level
import "types" for Type 
import "xs_math" for Vec2 

class GamePlay {
    
    static Init(){
        
        //Add walls for blockage checks
        for (x in 0...Level.width) {
            for (y in 0...Level.height) {
                
                if(Level.levelGrid[x,y] == Type.wall){
                    Level.gameplayGrid[x,y] = Type.wall
                }
            }
        }

        __playerPosition = spawnPlayer()
        spawnEnemies()
    }

    static Update(){
        moveInput()
        attackInput()
    }

    static spawnPlayer(){
        Level.gameplayGrid[(Level.width / 2).floor, (Level.height / 2).floor] = Type.player
        return Vec2.new((Level.width / 2).floor, (Level.height / 2).floor)
    }

    static spawnEnemies(){

    }

    static moveInput(){

        var newPosition = Vec2.new(__playerPosition.x,__playerPosition.y)
        var moved = false

        if (Input.getKeyOnce(Input.keyD) || Input.getKeyOnce(Input.keyRight)) {
            newPosition.x = newPosition.x + 1
            moved = true
        }
        if (Input.getKeyOnce(Input.keyA) || Input.getKeyOnce(Input.keyLeft)) {
            newPosition.x = newPosition.x - 1
            moved = true
        }
        if (Input.getKeyOnce(Input.keyW) || Input.getKeyOnce(Input.keyUp)) {
            newPosition.y = newPosition.y + 1
            moved = true
        }
        if (Input.getKeyOnce(Input.keyS) || Input.getKeyOnce(Input.keyDown)) {
            newPosition.y = newPosition.y - 1         
            moved = true
        }

        if(moved){
            if(Level.gameplayGrid.valid(newPosition.x, newPosition.y)){
                if(checkIfTileWalkable(newPosition.x, newPosition.y)){
                    Level.gameplayGrid[__playerPosition.x, __playerPosition.y] = Type.empty
                    __playerPosition = newPosition
                    Level.gameplayGrid[__playerPosition.x, __playerPosition.y] = Type.player
                }
            }
        }
    }

    static checkIfTileWalkable(x,y){

        var canMoveHere = false

        if(Level.gameplayGrid[x,y] != Type.wall && Level.gameplayGrid[x,y] != Type.enemy){
            canMoveHere = true
        }

        return canMoveHere
    }

    static attackInput(){
        if (Input.getKeyOnce(Input.keySpace)) {
            
        }
    }
}