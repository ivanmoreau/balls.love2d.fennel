(local conf (require :conf))
(local h-size conf.h-size)
(local w-size conf.w-size)

(local lphy love.physics)
(local lg love.graphics)

(local radius 100)

(var world nil)
(var current-color [1 1 1])
(var current-velocity 7)
(var selected-option 0)
(var circles {})

(fn impulse-circle [circle angle]
  (let [radians (math.rad angle)]
    (var x (* (math.cos radians) circle.velocity))
    (var y (* (math.sin radians) circle.velocity))
    (circle.body:applyLinearImpulse x y)))

(fn make-circle [velocity color direction x y]
  (var circle {})
  (set circle.color color)
  (set circle.velocity (* velocity 100))
  (set circle.direction direction)
  (set circle.body (lphy.newBody world x y "dynamic"))
  (set circle.shape (lphy.newCircleShape radius))
  (set circle.fixture (lphy.newFixture circle.body circle.shape 1))
  (circle.fixture:setRestitution 1) 
  (circle.body:setLinearDamping 0)
  (circle.body:setAngularDamping 0)
  (circle.body:setMass 0)
  (circle.fixture:setFriction 0)
  (impulse-circle circle circle.direction)
  circle)

(fn draw-circle [circle]
  (lg.setColor circle.color)
  (lg.circle "fill"
             (circle.body:getX) 
             (circle.body:getY) 
             (circle.shape:getRadius)))

(fn new-world-margin [w h x y]
  (local body (lphy.newBody world (+ x (/ w 2)) (+ y (/ h 2))))
  (local shape (lphy.newRectangleShape w h))
  (local fixture (lphy.newFixture body shape)))

(fn set-margins []
  (new-world-margin 0 h-size 0 0)
  (new-world-margin w-size 0 0 0)
  (new-world-margin w-size 0 0 h-size)
  (new-world-margin 0 h-size w-size 0))

(fn love.load []
  (love.physics.setMeter 64)
  (set world (lphy.newWorld 0 0 true))
  (set-margins))

(fn increase-option []
  (if (= selected-option 0)
      (tset current-color 1 (+ (. current-color 1) 0.1))
      (= selected-option 1)
      (tset current-color 2 (+ (. current-color 2) 0.1))
      (= selected-option 2)
      (tset current-color 3 (+ (. current-color 3) 0.1))
      (= selected-option 3)
      (set current-velocity (+ current-velocity 1))))

(fn decrease-option []
  (if (= selected-option 0)
      (tset current-color 1 (- (. current-color 1) 0.1))
      (= selected-option 1)
      (tset current-color 2 (- (. current-color 2) 0.1))
      (= selected-option 2)
      (tset current-color 3 (- (. current-color 3) 0.1))
      (= selected-option 3)
      (set current-velocity (- current-velocity 1))))

(fn previous-option []
  (set selected-option (- selected-option 1))
  (if (< selected-option 0)
      (set selected-option 3)))

(fn next-option []
  (set selected-option (+ selected-option 1))
  (if (> selected-option 3)
      (set selected-option 0)))

(fn generate-circle []
  (table.insert circles (make-circle current-velocity
                                    current-color
                                    (math.random 360)
                                    (math.random w-size)
                                    (math.random h-size))))

(fn love.update [dt]
  (world:update dt)
  (when (love.keyboard.isDown "right")
    (increase-option))
  (when (love.keyboard.isDown "left")
    (decrease-option))
  (when (love.keyboard.isDown "up")
    (previous-option))
  (when (love.keyboard.isDown "down")
    (next-option))
  (when (love.keyboard.isDown "return")
    (generate-circle)))

(fn current-color-text []
  (local text (string.format "%sR %sG %sB" 
                             (. current-color 1)
                             (. current-color 2)
                             (. current-color 3)))
  text)

(fn selected-option-text []
  (if (= selected-option 0)
      "Color R Value"
      (= selected-option 1)
      "Color G Value"
      (= selected-option 2)
      "Color B Value"
      (= selected-option 3)
      "Velocity Value"
      "Unknown"))

(fn gui-text []
  (lg.setColor [1 1 1])
  (lg.print (.. "Current color: " (current-color-text)) 10 10)
  (lg.print (.. "Current velocity: " current-velocity) 10 30)
  (lg.print (.. "Selected option: " (selected-option-text)) 10 50)
  (lg.print (.. "Press up/down to change selected option") 10 70)
  (lg.print (.. "Press left/right to change value") 10 90)
  (lg.print (.. "Press enter to create new circle") 10 110))

(fn draw-circles []
  (each [i v (ipairs circles)]
    (draw-circle v)))

(fn love.draw []
  (draw-circles)
  (gui-text))
