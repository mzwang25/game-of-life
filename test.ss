#lang racket
(require graphics/graphics)

(open-graphics)
(define window (open-viewport "a" 100 100))

(define (draw-at x y)
  (let (
      (adjX (* x 10))
      (adjY (* y 10))
    )
      ((draw-solid-rectangle window) (make-posn adjX adjY) 10 10 "black" )
  )
)

(define (clear-at x y)
  (let (
      (adjX (* x 10))
      (adjY (* y 10))
    )
      ((draw-solid-rectangle window) (make-posn adjX adjY) 10 10 "white" )
  )
)

(define (colored? x y)
  (let (
      (adjX (* x 10))
      (adjY (* y 10))
    )
    (if (equal? 0 ((get-pixel window) (make-posn adjX adjY))) #t #f)
  )
)

(draw-at 0 0 )
(clear-at 0 0)
(draw-at 1 0 )

(colored? 0 0)
(colored? 1 0)
