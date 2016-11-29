; MEEP script used to compute the total transmittance and reflectance from a slab containing a pattern of holes
; The hole positions and radius (x,y,r) should be given in a tab-delimited text file (3 columns, N lines, with N the number of holes)

; Author: Kevin Vynck
; Last modification: November 23, 2012 by Yinnon Sanders

; Related paper : K. Vynck, M. Burresi, F. Riboli, and D. S. Wiersma, "Photon management in two-dimensional disordered media", Nature Mater. 11, 1017 (2012).

;(set! eps-averaging? false)

; Empty space, slab or slab with holes
(define-param no-struct false)
(define-param no-holes true)

(define-param rodpos "rodpos.txt")

; Computation parameters
(define-param res 40)	; Resolution
(define-param fcen .9) ; Center frequency
(define-param df 0.8)	; Frequency width
(define-param nfreq 300); Frequency sampling
(define-param time 500) ; Computation time

(define-param dPML 1)		; Thickness of PMLs
(define-param H 5)		; Height of computational domain
(define-param L 4)		; Lateral size of sample
(define-param th 0.15)		; Thickness of sample

(define-param epsre 12)		; Slab permittivity (real)
;(define-param epsim 0.012251882); Slab permittivity (imag) li=45
;(define-param epsim 0.036755302); Slab permittivity (imag) li=15
(define-param epsim 0.110266942); Slab permittivity (imag) li=5

;(define diel (make dielectric (epsilon epsre) (D-conductivity (/ (* 2 pi fcen epsim) epsre))))
(define diel (make dielectric (epsilon epsre) (D-conductivity (/ (* 2 pi 1.0 epsim) epsre))))

(define-param angledegx 0)
(define-param angledegy 0)
(define angleradx (/ (* angledegx pi) 180))
(define anglerady (/ (* angledegy pi) 180))
(define kx (* fcen (sin angleradx)))
(define ky (* fcen (sin anglerady)))

(define (my-amp-func p) (exp (* 0+2i pi kx (vector3-x p))))

(define sx L)
(define sy L)
(define sz H)

(set! geometry-lattice (make lattice (size sx sy sz)))

(define slab
  (list
    (make block (material diel)
      (center 0 0 0) (size infinity infinity th))))

(define empty
  (list
    (make block (material nothing)
      (center 0 0 0) (size infinity infinity th))))

(if no-struct
  (list (set! geometry empty))
  (list (set! geometry slab))
)

(if (not no-holes)
  (let () 
    (define port1 (open-input-file rodpos))
    (define x 0)
    (define y 0)
    (define r 0)
    (define (readfile) 
      (begin 
        (set! x (read port1))
        (set! y (read port1))
        (set! r (read port1))
        (if (not (eof-object? x))
          (begin
            (set! geometry 
              (append geometry 
                (list 
                  (make cylinder (center x y) (height th) (radius r) (material air)))))				
            (readfile)))))
    (readfile)
))

; Perfectly Matched Layers
(set! pml-layers (list (make pml (thickness dPML) (direction Z))))

; Sources
(set! sources
  (list
    (make source
      (src (make gaussian-src (frequency fcen) (fwidth df)))
      (component Ex) (center 0 0 (- (/ sz 2) dPML)) (size sx sy 0)
      (amp-func my-amp-func))))

; Periodicity of structure
(set! k-point (vector3 kx ky 0))
(set! ensure-periodicity true)

; Resolution
(set! resolution res)

; Flux spectrum monitors
(define refl
  (add-flux fcen df nfreq
    (make flux-region
      (center 0 0 (- (/ sz 2) (+ dPML 1)))
      (size sx sy 0))))

(define trans 
  (add-flux fcen df nfreq
    (make flux-region 
      (center 0 0 (+ (/ sz -2) (+ dPML 1)))
      (size sx sy 0))))

; Load flux without structure
(if (not no-struct) (load-minus-flux "refl-flux" refl))

;(use-output-directory)

;(run-sources+ (stop-when-fields-decayed 10 Ex (vector3 0 0 (+ (/ sz -2) (+ dPML 1))) 1e-4)
(run-until time
  (at-beginning output-epsilon)
;  (at-every (/ 1 fcen 10) (in-volume (volume (center 0 0 0) (size sx sy 0)) (output-png Ex "-Zc bluered")))
;  (at-every (/ 1 fcen 10) output-efield-x)
)

; Save flux without structure
(if no-struct (save-flux "refl-flux" refl))

(display-fluxes refl trans)