import "xs" for Render, Data, Input
import "xs_math" for Bits, Vec2, Math
import "grid" for Grid
import "random" for Random 

class Type {
    static none     { 0 << 0 }
    static player   { 1 << 0 }
    static enemy    { 1 << 1 }
    static bomb     { 1 << 2 }
    static wall     { 1 << 3 }
    static door     { 1 << 4 }
    static blocking { wall | door }
}

class Turn {
    static none     { 0 }
    static player   { 1 }
    static enemy    { 2 }
    static dead     { 3 }
}

class Game {

    static config() {
        Data.setString("Title", "Rogue", Data.system)
        Data.setNumber("Width", 180, Data.system)
        Data.setNumber("Height", 180, Data.system)
        Data.setNumber("Multiplier", 2, Data.system)
    }

    static init() {        
        System.print("player %(Type.player)")
        System.print("bomb %(Type.bomb)")

        __time = 0
        __grid = Grid.new(9, 9, Type.none) // Grid is the Model
        __turn = Turn.player
        __level = 3
        __rand = Random.new()

        
        // Add player
        __grid[4, 4] = Type.player
        spawnEnemies()
    }    

    static spawnEnemies() {
        var count = 0
        while(count < __level) {
            var x = __rand.int(0, __grid.width)
            var y = __rand.int(0, __grid.height)
            if(__grid[x, y] == Type.none) {
                __grid[x, y] = Type.enemy
                count = count + 1
            }
        }
    }

    // The update method is called once per tick.
    // Gameplay code goes here.
    static update(dt) {
        __time = __time + dt

        if(__turn == Turn.player) {
            playerTurn()        
        } else if(__turn == Turn.enemy) {
            enemyTurn()
        }
    }

    static playerTurn() {
        var player = null
        for(x in 0...__grid.width) {
            for(y in 0...__grid.height) {
                var val = __grid[x, y]
                if(val == Type.player) {
                    player = Vec2.new(x, y)
                }
            }
        }

        if(player == null) {
            __turn = Turn.dead
            return
        }

        var direction = getDirection()
        if(direction != Vec2.new(0, 0)) {
            moveDirection(player, direction)
            __turn = Turn.enemy
        }
    }

    static enemyTurn() {
        __turn = Turn.player
        var playerPos = null
        for(x in 0...__grid.width) {
            for(y in 0...__grid.height) {
                var val = __grid[x, y]
                if(val == Type.player) {
                    playerPos = Vec2.new(x, y)
                }
            }
        }

        if(playerPos == null) {
            __turn = Turn.dead
            return
        }

        var enemies = List.new()
        for(x in 0...__grid.width) {
            for(y in 0...__grid.height) {
                var enemy = __grid[x, y]
                if(enemy == Type.enemy) {
                    var pos = Vec2.new(x, y)
                    enemies.add(pos)
                }
            }
        }

        if(enemies.count == 0) {
            __level = __level + 1
            __turn = Turn.player
            spawnEnemies()
            return
        }

        for(ePos in enemies) {
            var dir = playerPos - ePos
            dir = manhattanize(dir)
            moveDirection(ePos, dir) 
        }
    }

    static manhattanize(dir) {
        if(dir.x.abs > dir.y.abs) {
            return Vec2.new(dir.x.sign, 0)
        } else {
            return Vec2.new(0, dir.y.sign)
        }
    }

    static getDirection() {
        if(Input.getKeyOnce(Input.keyUp)) {
            return Vec2.new(0, 1)
        } else if(Input.getKeyOnce(Input.keyDown)) {
            return Vec2.new(0, -1)
        } else if(Input.getKeyOnce(Input.keyLeft)) {
            return Vec2.new(-1, 0)
        } else if(Input.getKeyOnce(Input.keyRight)) {
            return Vec2.new(1, 0)
        } else {
            return Vec2.new(0, 0)
        }
    }

    static moveDirection(position, direction) {
        var from = position
        var to = position + direction
        to.x = Math.mod(to.x, __grid.width)
        to.y = Math.mod(to.y, __grid.height)
        if(__grid[to.x, to.y] != Type.none) {
            __grid[to.x, to.y] = Type.none            
        }
        __grid.swap(from.x, from.y, to.x, to.y)
    }

    // The render method is called once per tick, right after update.
    static render() {
        var pc = Data.getColor("Player Color")
        var r = 6
        var of = 2 * r + 4 
        var sx = (__grid.width - 1) / 2 * of
        var sy = (__grid.height - 1) / 2 * of 

        for(x in 0...__grid.width) {
            for(y in 0...__grid.height) {
                var val = __grid[x, y]
                if(val == Type.none) {
                    Render.setColor(pc)
                    Render.circle(x * of - sx, y * of - sy, r, 18)
                } else if(val == Type.player) {
                    Render.setColor(0.5, 0.5, 0.9)
                    Render.disk(x * of - sx, y * of - sy, r, 18)
                } else if(val == Type.enemy) {
                    Render.setColor(0.9, 0.5, 0.5)
                    Render.disk(x * of - sx, y * of - sy, r, 18)
                }
            }
        }

        if(__turn == Turn.dead) {
            Render.setColor(0xFFFFFFFF)
            Render.shapeText("You dead", -20, -75, 1)
        }
    }
}