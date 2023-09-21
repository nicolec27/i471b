(define (quadratic-roots a b c)
	(if (= a 0)
		'error
		(let ((discriminant (- (* b b) (* 4 (* a c)))))
			(list(/ (-(- b(sqrt discriminant))) (* 2 a)) (/ (-(+ b(sqrt discriminant))) (* 2 a))))))
			
(define (cmp-gt ls1 ls2)
	(if (null? ls1)
		'()
	(cons (> (car ls1) (car ls2))
		(cmp-gt (cdr ls1) (cdr ls2)))))

(define (ls-prod ls1 ls2)
	(if (null? ls1)
		'()
	(cons (> (car ls1) (car ls2))
		(ls-prod (cdr ls1) (cdr ls2)))))			
		
