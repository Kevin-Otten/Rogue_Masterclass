import "xs" for Render, Data
import "level" for Level
import "level_generation" for WalkerGeneration 
import "gameplay" for GamePlay

class Game {

    static config() {
        Data.setString("Title", "xs - hello", Data.system)
        Data.setNumber("Width", 640, Data.system)
        Data.setNumber("Height", 360, Data.system)
        Data.setNumber("Multiplier", 2, Data.system)
        Data.setBool("Fullscreen", false, Data.system)
    }

    static init() {        
        __time = 0
        //Setup level
        Level.Init()
        WalkerGeneration.Generate()

        //Setup gameplay elements (Player and enemies for example)
        GamePlay.Init()
    }

    static update(dt) {
        __time = __time + dt

        GamePlay.Update()
    }
    
    static render() {
        Level.Render()
        GamePlay.Render()
    }
}