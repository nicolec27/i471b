(define (quadratic-roots a b c . d)
	(let ((extract (if (null? d) sqrt(car d))))
	(if (= a 0)
		'error
		(let ((discriminant (- (* b b) (* 4 (* a c)))))
			(list(/ (-(- b(extract discriminant))) (* 2 a)) (/ (-(+ b(extract discriminant))) (* 2 a)))))))
			
(define (cmp-gt ls1 ls2)
	(if (null? ls1)
		'()
	(cons (> (car ls1) (car ls2))
		(cmp-gt (cdr ls1) (cdr ls2)))))

(define (ls-prod ls1 ls2)
	(if (null? ls1)
		'()
	(cons (* (car ls1) (car ls2))
		(ls-prod (cdr ls1) (cdr ls2)))))	

(define ls-f
    (lambda (ls1 ls2 (fn (lambda (a b) (+ a b))))
	(if (null? ls1)
		'()
    (cons (fn (car ls1) (car ls2))
		(ls-f (cdr ls1) (cdr ls2) fn)))))
		
(define (greater-than ls1 v)
	(if (null? v)
		0
	(if (null? ls1)
		'()
		(cons (> (car ls1) v)
			(greater-than (cdr ls1) v)))))

(define (my-sqrt n)
 	(letrec ([aux-sqrt
            (lambda (guess)
              	(if (> (/ (abs (- (* guess guess) n)) n) 0.0001)
                  	(aux-sqrt (/ (+ guess (/ n guess)) 2))
                  	guess))])
    	(aux-sqrt 1.0)))

