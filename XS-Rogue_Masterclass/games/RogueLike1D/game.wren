// This is just confirmation, remove this line as soon as you
// start making your game
System.print("Wren just got compiled to bytecode")

// The xs module is 
import "xs" for Render, Data, Input
// WREN modules
import "random" for Random

// The game class it the entry point to your game
class Game {

    // The config method is called before the device, window, renderer
    // and most other systems are created. You can use it to change the
    // window title and size (for example).
    // You can remove this method
    static config() {
        System.print("config")
        
        // This can be saved to the system.json using the
        // Data UI. This code overrides the values from the system.json
        // and can be removed if there is no need for that
        Data.setString("Title", "Rogue Like Game", Data.system)
        Data.setNumber("Width", 960, Data.system)
        Data.setNumber("Height", 540, Data.system)
        Data.setNumber("Multiplier", 1, Data.system)
        Data.setBool("Fullscreen", false, Data.system)
        Data.setBool("Always on top", false, Data.system)
    }

    // The init method is called when all system have been created.
    // You can initialize you game specific data here.
    static init() {        
        System.print("init")

        // The "__" means that __time is a static variable (belongs to the class)
        __time = 0

        // Variable that exists only in this function 
        var image = Render.loadImage("[games]/shared/images/FMOD_White.png")
        __sprite = Render.createSprite(image, 0, 0, 1, 1)

        //Level list
        var levelSize = 20
        __level = List.filled(levelSize,0)

        //Enemy related variables
        var amountOfEnemies = 4
        __enemyPositions = List.filled(amountOfEnemies, 0)
        __spawnRange = levelSize / 10 //Minimum range enemies spawn appart from eachother

        //Player related variables
        var playerStart = 0
        __playerPosition = playerStart
        __playerEnd = levelSize - 1
        __playerWon = false
        __playerDied = false


        //RNG
        __numberGenerator = Random.new()

        setupEnemies()
        setupLevel()

        //Tutorial
        System.print("
        How to play:
        To win the game, reach the exit without dying.
        If an enemy moves onto the player or a player onto a enemy the player dies.
        To kill an enemy press space when standing next to it.
        A: Moves to the left, D: Moves to the right, Space: Attacks around the player.
        @: The player, E: An enemy, *: The exit.")

        //Initial level print
        printLevel()
    }

    // The update method is called once per tick.
    // Gameplay code goes here.
    static update(dt) {
        __time = __time + dt

        if (__playerWon == false && __playerDied == false) {
            if (Input.getKeyOnce(Input.keyD) || Input.getKeyOnce(Input.keyRight)) {
                move(true)
            }
            if (Input.getKeyOnce(Input.keyA) || Input.getKeyOnce(Input.keyLeft)) {
                move(false)
            }
            if (Input.getKeyOnce(Input.keySpace)) {
                playerAttack()
            }
        } else {
            if (__playerWon) {
                System.print("YOU WON! :)")
            } else {
                System.print("YOU DIED! :(")
            }
        }
        
        System.print()
    }

    // The render method is called once per tick, right after update.
    static render() {
        Render.setColor(
            (__time * 10 + 1).sin.abs,
            (__time * 10 + 2).sin.abs,
            (__time * 10 + 3).sin.abs)
        Render.shapeText("xs", -100, 100, 20)
        Render.shapeText("Made with love at Games@BUas", -100, -50, 1)
        Render.setColor(0.5, 0.5, 0.5)
        Render.shapeText("Time: %(__time)", -300, -160, 1)

        Render.sprite(__sprite, 180, -152, 0, 0.16, 0.0, 0xFFFFFFFF, 0x00000000, 0)
    }

    static move(right) {
        
        if (right) {
            if (__playerPosition < (__level.count - 1)) {
                __level[__playerPosition] = 0
                __playerPosition = __playerPosition + 1
            }
        } else {
            if (__playerPosition > 0 ) {
                __level[__playerPosition] = 0
                __playerPosition = __playerPosition - 1
            }
        }

        checkMovedTile()
        //After checks updates the player position and then prints the level to the console
        __level[__playerPosition] = "@"
        updateEnemies()

        printLevel()
    }

    static checkMovedTile(){

        if (__playerPosition == __playerEnd) {
            __playerWon = true
        }
        if (__level[__playerPosition] == "E") {
            __playerDied = true
        }
    }

    static playerAttack() {

        if (__level[__playerPosition - 1] == "E") {
            __level[__playerPosition - 1] = 0
            //System.print(__enemyPositions.remove(__playerPosition - 1))
        }

        if (__level[__playerPosition + 1] == "E") {
            __level[__playerPosition + 1] = 0
            //System.print(__enemyPositions.remove(__playerPosition + 1))
        }

        //After attacking, process enemies turn and then update the level
        updateEnemies()
        printLevel()
    }

    static setupEnemies() {

        var edgeOffset = 4
        var itteration = 0

        for (i in 1..__enemyPositions.count) {
            
            var validPosition = false

            while (!validPosition) {
                
                var newPosition = __numberGenerator.int(edgeOffset - 1, __level.count - edgeOffset)

                for (position in __enemyPositions) {
                    //If the position of the new enemy is not within other enemies spawn range
                    if (newPosition < position - __spawnRange || newPosition > position + __spawnRange ) {
                        validPosition = true
                    } else {
                        validPosition = false
                        break
                    }
                }

                if (validPosition) {
                    __enemyPositions[itteration] = newPosition
                    __level[newPosition] = "E"
                }
            }

            itteration = itteration + 1
        }

        System.print(__enemyPositions)
    }

    static updateEnemies() {

        var itteration = 0

        for (position in __enemyPositions) {
            //Value between 0 and 1 (50/50 chance, theoretically)
            var value = __numberGenerator.int(2)
            if (value == 0) {
                //if it wont walk of the level or on the exit
                if (position > 0 && position - 1 != __playerEnd) {
                    __enemyPositions[itteration] = position - 1
                }
            } else {
                //if it wont walk of the level or on the exit
                if (position < __level.count - 1 && position + 1 != __playerEnd) {
                    __enemyPositions[itteration] = position + 1
                }
            }
            
            //Check if the killed the player, move the enemy there nomather what and increment the itteration
            checkMovedTileEnemies(__enemyPositions[itteration])
            __level[position] = "0"
            __level[__enemyPositions[itteration]] = "E"
            itteration = itteration + 1
        }
    }

    static checkMovedTileEnemies(position){

        if (position == __playerPosition) {
            __playerDied = true
        }
    }

    static setupLevel() {

        __level[__playerPosition] = "@"
        __level[__playerEnd] = "*"
    }

    static printLevel(){

        System.print(__level)
    }
}