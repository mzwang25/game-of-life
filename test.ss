#lang racket
(require graphics/graphics)

;==================================================

(define SCALE 10)
(define MAX-X 10)
(define MAX-Y 10)

;==================================================
(open-graphics)

(define (mkwindow x y)
  (open-viewport "a" (* SCALE x) (* SCALE y)))

(define window (mkwindow MAX-X MAX-Y) )

;==================================================

(define (draw-at x y)
  (let (
      (adjX (* x SCALE))
      (adjY (* y SCALE))
    )
      ((draw-solid-rectangle window) 
          (make-posn adjX adjY) SCALE SCALE "black" )
  )
)

(define (clear-at x y)
  (let (
      (adjX (* x SCALE))
      (adjY (* y SCALE))
    )
      ((draw-solid-rectangle window) 
          (make-posn adjX adjY) SCALE SCALE "white" )
  )
)

(define (colored? x y)
  (let (
      (adjX (* x SCALE))
      (adjY (* y SCALE))
    )
    (if (equal? 0 ((get-pixel window) (make-posn adjX adjY))) #t #f)
  )
)

;==================================================

(draw-at 0 0 )
(draw-at 2 0 )
(draw-at 4 0 )
(draw-at 6 0 )
(draw-at 8 0 )
