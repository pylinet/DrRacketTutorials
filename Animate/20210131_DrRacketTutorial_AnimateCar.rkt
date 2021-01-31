;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 20210131_DrRacketTutorial_AnimateCar) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
(define WIDTH-OF-WORLD 200)


; Create a car wheels
(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))

(define WHEEL
  (circle WHEEL-RADIUS "solid" "saddle brown"))
(define SPACE
  (rectangle 8 5 "solid" "coral"))
(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL))

; Create clouds
(define CLOUD
  (underlay/offset (circle 15 "solid" "Floral white") 16 10 (circle 12 "solid" "Floral white")))

; Create car body
(define CAR-BODY
  (rectangle (* 4 WHEEL-RADIUS)(* 4 WHEEL-RADIUS) "solid" "coral"))
(define CAR-BODY-SIDE
  (rectangle (* 2 WHEEL-RADIUS)(* 2 WHEEL-RADIUS) "solid" "coral"))
(define TOTAL-CAR-BODY
  (beside/align "bottom" CAR-BODY-SIDE CAR-BODY CAR-BODY-SIDE))

; Combine the wheels and car body
(define COMPLETE-CAR
  (underlay/align/offset "center" "bottom" TOTAL-CAR-BODY 0 WHEEL-RADIUS BOTH-WHEELS))

; Create houses
(define HOUSE-ROOF
  (regular-polygon 36 3 "solid" "sienna"))
(define HOUSE-BODY
  (rectangle 30 30 "solid" "peru"))
(define TOTAL-HOUSE
  (overlay/xy HOUSE-ROOF 3 30 HOUSE-BODY))


; Create trees
(define TREE
  (underlay/xy (circle 12 "solid" "seagreen") 10 24 (rectangle 3 20 "solid" "brown")))

; Create background scene
(define SCENE
  (above/align "middle" (rectangle WIDTH-OF-WORLD 80 "solid" "Light Cyan") (rectangle WIDTH-OF-WORLD 90 "solid" "Medium Goldenrod") (rectangle WIDTH-OF-WORLD 30 "solid" "Gainsboro")))

; Create background for which car and trees will live
(define BACKGROUND-1
  (underlay/xy SCENE 50 70 (underlay/xy TOTAL-HOUSE 50 20 (underlay/xy TREE 40 -10 TREE))))

(define BACKGROUND
  (underlay/xy BACKGROUND-1 20 20 CLOUD))

; WorldState -> Image
; places the car into the BACKGROUND scene,
; according to the given world state
(define Y-CAR 170)
(define (render cw) (place-image COMPLETE-CAR cw Y-CAR BACKGROUND))


; WorldState -> WorldState
; moves the car by 3 pixels for every clock tick
(define (tock cw) (+ cw 3))


(define (main ws)
   (big-bang ws
     [on-tick tock]
     [on-mouse hyper]
     [to-draw render]))


; WorldState Number Number String -> WorldState
; places the car at x-mouse
; if the given me is "button-down" 
(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond
    [(string=? "button-down" me) x-mouse]
    [else x-position-of-car]))