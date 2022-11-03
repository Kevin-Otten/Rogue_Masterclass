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

        //Player related variables
        var playerStart = 0
        __playerPosition = playerStart
        __playerEnd = __level.count - 1
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
            if (__playerWon == true) {
                System.print("YOU WON! :)")
            } else {
                System.print("YOU DIED! :(")
            }
        }
        // __numberGenerator.int(3,__level - 4)
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

        checkMovedTile(true)

        //After checks updates the player position and then prints the level to the console
        __level[__playerPosition] = "@"
        printLevel()
    }

    static checkMovedTile(player){
        
        if (player) {
            if (__playerPosition == __playerEnd) {
                __playerWon = true
            }
            if (__level[__playerPosition] == "E") {
                __playerDied = true
            }
        } else {
            
        }
    }

    static playerAttack() {
        if (__level[__playerPosition - 1] == "E") {
            __level[__playerPosition - 1] = 0
        }
        if (__level[__playerPosition + 1] == "E") {
            __level[__playerPosition + 1] = 0
        }

        //After attacking, process enemies turn and then update the level
        updateEnemies()
        printLevel()
    }

    static setupEnemies() {

    }

    static updateEnemies() {

    }

    static setupLevel() {
        __level[__playerPosition] = "@"
        __level[__playerEnd] = "*"
    }

    static printLevel(){
        System.print(__level)
    }
}