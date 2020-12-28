#lang racket
(require graphics/graphics)

;==================================================

(define SCALE 10)
(define MAX-X 10)
(define MAX-Y 10)
;==================================================

(define (int->str x)
  (format "~v" x))

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
    (if (equal? 1 ((get-pixel window) (make-posn adjX adjY))) #t #f)
  )
)

;==================================================

; print point
(define (ppoint x y)
  (display (string-append 
              "(" 
              (int->str x) 
              "," 
              (int->str y) 
              ")" 
              "\n")
  )
)


; loops through all coordinates starting from (x,y)
; and calls the function "call" with the coordinate
; ex: `(loop (λ (x y) (display (colored? x y)) ) 0 0)`
(define (loop call x y)
  (let (
      (a (call x y))
    )
    
    (cond
      ((< y (- MAX-Y 1)) (loop call x (+ y 1)) )
      ((and (equal? y (- MAX-Y 1)) (< x (- MAX-X 1))) 
          (loop call (+ x 1) 0 ))
      (#t #t )
    )
      
  )
)

;==================================================
;Neighor Checks

(define (NBAlive x y)
  (let (
      (a (if (colored? (+ x 1) (+ y 0)) 1 0))
      (b (if (colored? (+ x 0) (+ y 0)) 1 0))
      (c (if (colored? (+ x 1) (+ y 1)) 1 0))
      (d (if (colored? (+ x 0) (+ y 1)) 1 0))
      (e (if (colored? (- x 1) (- y 0)) 1 0))
      (f (if (colored? (- x 0) (- y 0)) 1 0))
      (g (if (colored? (- x 1) (- y 1)) 1 0))
      (h (if (colored? (- x 0) (- y 1)) 1 0))
    )
    (+ a b c d e f g h)
  )
)

(define (3NBAlive x y)
  (= (NBAlive x y) 3))

(define (2Or3NBAlive x y)
  (let (
    (num (NBAlive x y))
    )
    (or (= num 3) (= num 2))  
  )
)

