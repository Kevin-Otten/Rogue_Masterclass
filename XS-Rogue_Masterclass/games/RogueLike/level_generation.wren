import "xs_math" for Vec2, Math
import "xs" for Data
import "level" for Level
import "random" for Random
import "types" for Directions, Type

class WalkerGeneration {

    static Generate(){
        __randomNumber = Random.new()
        __direction = Directions.upIdx
        __stepsTaken = 0
        __stepLimit = 15

        var amountOfWalkers = 10
        var startPos = Vec2.new((Level.width / 2).floor, (Level.height / 2).floor)

        for (i in 0..amountOfWalkers) {
            __stepsTaken = 0
            __position = startPos
            __direction = __randomNumber.int(0,4)
            walk()
        }

        if (Data.getBool("Perform second pass", Data.debug)) {
            PostProcesser.RemoveLonelyWalls(2)   
        }
        PostProcesser.RemoveExcessWalls()
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

        var toRemove = []

        for (x in 0...Level.width) {
            for (y in 0...Level.height) {

                var deleteThis = true

                for (nx in x-1..x+1) {
                    for (ny in y-1..y+1) {
                        if(Level.levelGrid.valid(nx, ny)) {
                            if(Level.levelGrid[nx, ny] != Type.wall) {
                                deleteThis = false
                            }
                        }
                    }
                }

                if(deleteThis) {
                    toRemove.add(Vec2.new(x, y))
                }
            }
        }

        for (remove in toRemove) {
            Level.levelGrid[remove.x, remove.y] = Type.empty
        }
    }

    static RemoveLonelyWalls(minimumNeighbours){

        var toRemove = []

        for (x in 0...Level.width) {
            for (y in 0...Level.height) {
                if (Level.levelGrid[x,y] == Type.wall) {
                    
                    var neighbourCount = 0

                    //Check left, right, above and bellow
                    if (Level.levelGrid.valid(x - 1, y)) {
                        if (Level.levelGrid[x - 1, y] == Type.wall) {
                            neighbourCount = neighbourCount + 1
                        }
                    }
                    if (Level.levelGrid.valid(x + 1, y)){
                        if (Level.levelGrid[x + 1, y] == Type.wall) {
                            neighbourCount = neighbourCount + 1
                        }
                    }
                    if (Level.levelGrid.valid(x, y - 1)){
                        if (Level.levelGrid[x, y - 1] == Type.wall) {
                            neighbourCount = neighbourCount + 1
                        }
                    }
                    if (Level.levelGrid.valid(x, y + 1)){
                        if (Level.levelGrid[x, y + 1] == Type.wall) {
                            neighbourCount = neighbourCount + 1
                        }
                    }
                    
                    //If less neighbours than requested, change tile into floor
                    if(neighbourCount < minimumNeighbours) {
                        toRemove.add(Vec2.new(x, y))
                    }
                }
            }
        }

        for (remove in toRemove) {
            Level.levelGrid[remove.x, remove.y] = Type.floor
        }

        //Remove remaining single pillars
        for (x in 0...Level.width) {
            for (y in 0...Level.height) {
                if (Level.levelGrid[x,y] == Type.wall) {
                    
                    var aNeighbour = false

                    //Check left
                    if (Level.levelGrid.valid(x - 1, y)) {
                        if (Level.levelGrid[x - 1, y] == Type.wall) {
                            aNeighbour = true
                        }
                    }
                    //Check right
                    if (Level.levelGrid.valid(x + 1, y)){
                        if (Level.levelGrid[x + 1, y] == Type.wall) {
                            aNeighbour = true
                        }
                    }
                    //Check up
                    if (Level.levelGrid.valid(x, y - 1)){
                        if (Level.levelGrid[x, y - 1] == Type.wall) {
                            aNeighbour = true
                        }
                    }
                    //Check down
                    if (Level.levelGrid.valid(x, y + 1)){
                        if (Level.levelGrid[x, y + 1] == Type.wall) {
                            aNeighbour = true
                        }
                    }

                    if (aNeighbour == false){
                        Level.levelGrid[x, y] = Type.floor
                    }
                }
            }
        }
    }
}