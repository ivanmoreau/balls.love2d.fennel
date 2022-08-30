(local h-size 720)
(local w-size 1280)

(fn love.conf [t]
  (set t.window.title "Balls")
  (set t.window.width w-size)
  (set t.window.height h-size))

{:h-size h-size :w-size w-size}
