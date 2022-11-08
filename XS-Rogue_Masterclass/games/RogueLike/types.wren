import "xs_math" for Vec2

class Type {
    static empty    { 0 << 0 }
    static floor    { 1 << 0 }
    static wall     { 1 << 1 }
    static player   { 1 << 2 }
    static enemy    { 1 << 3 }
    static door     { 1 << 4 }
    static lever    { 1 << 5 }
    static spikes   { 1 << 6 }
    static chest    { 1 << 7 }
    static crate    { 1 << 8 }
    static pot      { 1 << 9 }
    static stairs   { 1 << 10 }
    static light    { 1 << 11 }

//    static attackable   { enemy }
    static blocking     { (wall | enemy | door | player) }
//    static character    { (player | enemy) }

    static monsterBlock { (wall | light | pot | chest) }
}


class Directions {
    static upIdx    { 0 }
    static rightIdx { 1 }
    static downIdx  { 2 }
    static leftIdx  { 3 }
    static noneIdx  { 4 }

    static [i] {
        if(i == 0) {
            return Vec2.new(0, 1)   // Up
        } else if(i == 1) {
            return Vec2.new(1, 0)   // Right
        } else if(i == 2) {
            return Vec2.new(0, -1)  // Down
        } else if(i == 3) {
            return Vec2.new(-1, 0)  // Left
        } else if(i == 4) {
            return Vec2.new(0, 0)   // None
        }
    } 
}