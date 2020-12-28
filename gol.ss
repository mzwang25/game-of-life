#lang racket
(require graphics/graphics)

;==================================================

(define SCALE 10)
(define MAX-X 50)
(define MAX-Y 50)
(define UPDATE-INTERVAL 50)
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
      (adjX (modulo (* x SCALE) (* SCALE MAX-X)))
      (adjY (modulo (* y SCALE) (* SCALE MAX-Y)))
    )
      ((draw-solid-rectangle window) 
          (make-posn adjX adjY) SCALE SCALE "black" )
  )
)

(define (clear-at x y)
  (let (
      (adjX (modulo (* x SCALE) (* SCALE MAX-X)))
      (adjY (modulo (* y SCALE) (* SCALE MAX-Y)))
    )
      ((draw-solid-rectangle window) 
          (make-posn adjX adjY) SCALE SCALE "white" )
  )
)

(define (colored? x y)
  (let (
      (adjX (modulo (* x SCALE) (* SCALE MAX-X)))
      (adjY (modulo (* y SCALE) (* SCALE MAX-Y)))
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
      (a (if (colored? (- x 1) (- y 1)) 1 0))
      (b (if (colored? (+ x 0) (- y 1)) 1 0))
      (c (if (colored? (+ x 1) (- y 1)) 1 0))
      (d (if (colored? (- x 1) (+ y 0)) 1 0))
      (e (if (colored? (+ x 1) (+ y 0)) 1 0))
      (f (if (colored? (- x 1) (+ y 1)) 1 0))
      (g (if (colored? (+ x 0) (+ y 1)) 1 0))
      (h (if (colored? (+ x 1) (+ y 1)) 1 0))
    )
    (+ a b c d e f g h)
  )
)

(define (3NBAlive nalive)
  (= nalive 3))

(define (2Or3NBAlive nalive)
  (or (= nalive 3) (= nalive 2))  
)

;==================================================

(define toFlip (list))

(define (aliveNextRound? x y)
  (let (
      (alive (colored? x y))
      (nalive (NBAlive x y))
    )

      (cond
        ((and (equal? alive #f) (3NBAlive nalive)) #t)
        ((and (equal? alive #t) (2Or3NBAlive nalive)) #t)
        (#t #f)
      )
  )
)

(define (addToFlip x y)
  (let (
      (alive (colored? x y))
      (aNR (aliveNextRound? x y))
  )
      (cond
        ((and (equal? alive #f) (equal? aNR #t) 
            (set! toFlip (cons (list x y) toFlip) )   ))
        ((and (equal? alive #t) (equal? aNR #f) 
            (set! toFlip (cons (list x y) toFlip) )   ))
        (#t )
      )
  )
)


(define (update x y)
    (cond
      ((colored? x y) (clear-at x y) )
      (#t (draw-at x y) )
    )
)

(define (updateAll items callback)
  (let (
      (a (update (car (car items)) (car (cdr (car items))) ))
      (next (cdr items))
  )
      (cond
        ((equal? (length next) 0) (callback 2) )
        (#t (updateAll next callback))
      )
  )
)

(define (clearToFlip x)
  (set! toFlip (list)) )


;==================================================
; Runner

(draw-at 11 19)
(draw-at 13 19)
(draw-at 13 18)
(draw-at 15 17)
(draw-at 15 16)
(draw-at 15 15)
(draw-at 17 16)
(draw-at 17 15)
(draw-at 17 14)
(draw-at 18 15)


(define (getNextStep x)
  (let (
          (a (loop addToFlip 0 0))
          (b (updateAll toFlip clearToFlip))
       )
    #t
  )

)

((set-on-tick-event window) UPDATE-INTERVAL getNextStep )
