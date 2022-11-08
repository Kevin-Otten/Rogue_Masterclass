import "xs_math" for Vec2, Math
import "level" for Level
import "random" for Random
import "types" for Directions, Type

class WalkerGeneration {

    static Generate(){
        __randomNumber = Random.new()
        __direction = Directions.upIdx
        __stepsTaken = 0
        __stepLimit = 15

        var amountOfWalkers = 15
        var startPos = Vec2.new((Level.width / 2).floor, (Level.height / 2).floor)
        System.print(startPos)
        for (i in 0..amountOfWalkers) {
            __stepsTaken = 0
            __position = startPos
            __direction = __randomNumber.int(0,4)
            walk()
        }
    }

    static walk(){

        Level.levelGrid[__position.x, __position.y] = Type.floor

        // rng check for turning
        if(__randomNumber.float(0.0, 1.0) < 0.2){
            //Left or right turn?
            if(__randomNumber.float(0.0, 1.0) < 0.5){
                __direction = Math.mod(__direction - 1, 4)
            } else {
                __direction = Math.mod(__direction + 1, 4)
            }
        }

        __position = __position + Directions[__direction]
        
        // If the new position lies inbounds
        if(Level.IsInBounds(__position.x, __position.y)){
            __stepsTaken = __stepsTaken + 1
        } else {
            __stepsTaken = __stepLimit
        }

        if(__stepsTaken < __stepLimit){
            walk()
        }
    }
}

class BSPGeneration {

    static Split(){

    }
}

class PostProcesser {
    
    static RemoveExcessWalls(){
        
    }

    static RemoveLonelyWalls(){

    }
}