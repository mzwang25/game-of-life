#lang racket
(require graphics/graphics)


(open-graphics)
(define window (open-viewport "a" 500 500))

(define draw-square 
  (lambda (x y) (
      (let (
          (a ((draw-solid-rectangle window) (make-posn x y) 10 10 "black" ))
        )
          (+ 2 3)
      )
    )
  )
)

(draw-square 250 250)
