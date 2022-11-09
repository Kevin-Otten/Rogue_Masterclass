import "xs" for Input
import "level" for Level

class GamePlay {
    
    static Init(){
        spawnPlayer()
        spawnEnemies()
    }

    static Update(){
        moveInput()
        attackInput()
    }

    static spawnPlayer(){
        //Level.levelGrid[(Level.width / 2).floor, (Level.height / 2).floor]
    }

    static spawnEnemies(){

    }

    static moveInput(){
        if (Input.getKeyOnce(Input.keyD) || Input.getKeyOnce(Input.keyRight)) {
            
        }
        if (Input.getKeyOnce(Input.keyA) || Input.getKeyOnce(Input.keyLeft)) {
            
        }
        if (Input.getKeyOnce(Input.keyW) || Input.getKeyOnce(Input.keyUp)) {
            
        }
        if (Input.getKeyOnce(Input.keyS) || Input.getKeyOnce(Input.keyDown)) {
            
        }
    }

    static attackInput(){
        if (Input.getKeyOnce(Input.keySpace)) {
            
        }
    }
}