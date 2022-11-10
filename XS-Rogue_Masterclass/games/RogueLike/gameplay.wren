import "xs" for Input
import "level" for Level
import "types" for Type 
import "xs_math" for Vec2 
import "random" for Random

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

        __randomNumber = Random.new()
        __playerPosition = spawnPlayer()
        __enemyPositions = spawnEnemies()
    }

    static Update(){
        moveInput()
    }

    static spawnPlayer(){
        Level.gameplayGrid[(Level.width / 2).floor, (Level.height / 2).floor] = Type.player
        return Vec2.new((Level.width / 2).floor, (Level.height / 2).floor)
    }

    static spawnEnemies(){

        __enemyAmount = 5
        var amountSpawned = 0
        var newEnemyPositions = List.new()
        
        while (amountSpawned != __enemyAmount) {
            
            var randomX = __randomNumber.int(0, Level.width)
            var randomY = __randomNumber.int(0, Level.height)

            if (Level.levelGrid[randomX,randomY] == Type.floor) {

                var gridType = Level.gameplayGrid[randomX,randomY]

                if (gridType != Type.player && gridType != Type.enemy) {

                    Level.gameplayGrid[randomX,randomY] = Type.enemy
                    newEnemyPositions.add(Vec2.new(randomX,randomY))
                    amountSpawned = amountSpawned + 1
                }
            }
        }

        return newEnemyPositions
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
                if(Level.gameplayGrid[newPosition.x, newPosition.y] != Type.enemy){
                    if (Level.gameplayGrid[newPosition.x, newPosition.y] != Type.wall) {
                        Level.gameplayGrid[__playerPosition.x, __playerPosition.y] = Type.empty
                        __playerPosition = newPosition
                        Level.gameplayGrid[__playerPosition.x, __playerPosition.y] = Type.player
                    }
                } else {
                    attack(newPosition)
                }
            }
            enemyActions()
        }
    }

    static attack(attackedPosition){

        Level.gameplayGrid[attackedPosition.x, attackedPosition.y] = Type.empty
        for (i in 0...__enemyPositions.count) {
            if (__enemyPositions[i] == attackedPosition) {
                __enemyPositions.removeAt(i)
                return
            }
        }
    }

    static enemyActions(){
        
        var newPosition = Vec2.new(0,0)

        for (i in 0...__enemyPositions.count) {

            newPosition = simpleAlignmentPathfinding(__enemyPositions[i])

            if (Level.gameplayGrid[newPosition.x, newPosition.y] != Type.wall &&
            Level.gameplayGrid[newPosition.x, newPosition.y] != Type.enemy) {

                if (Level.gameplayGrid[newPosition.x, newPosition.y] != Type.player) {

                    Level.gameplayGrid[__enemyPositions[i].x, __enemyPositions[i].y] = Type.empty
                    Level.gameplayGrid[newPosition.x, newPosition.y] = Type.enemy
                    __enemyPositions[i] = newPosition

                } else {
                    
                }
            }
        }
    }

    static simpleAlignmentPathfinding(startPosition){
        
        var newPosition = startPosition
        var direction = Vec2.new(0,0)
        var plottedMove

        var distanceX = __playerPosition.x - startPosition.x
        var distanceY = __playerPosition.y - startPosition.y

        if (distanceX.abs > distanceY.abs) {
            direction.x = distanceX
        } else {
            direction.y = distanceY
        }

        System.print("X: %(distanceX.abs)")
        System.print("Y: %(distanceY.abs)")
        System.print("----------")

        direction = direction.normalise
        newPosition = newPosition + direction

        return newPosition
    }
}