import "xs" for Render, Data
import "level" for Level

class Game {

    static config() {
        Data.setString("Title", "xs - hello", Data.system)
        Data.setNumber("Width", 320, Data.system)
        Data.setNumber("Height", 240, Data.system)
        Data.setNumber("Multiplier", 2, Data.system)
        Data.setBool("Fullscreen", false, Data.system)
    }

    static init() {        
        __time = 0
        Level.Initialize()
    }

    static update(dt) {
        __time = __time + dt
    }
    
    static render() {
        Level.Render()
    }
}