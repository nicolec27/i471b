quadratic_roots(A, B, C, Z):-
    Z is (-B + sqrt(B*B - 4*A*C)) / (2*A).

quadratic_roots(A, B, C, Z):-
    Z is (-B - sqrt(B*B - 4*A*C)) / (2*A).

quadratic_roots2(A, B, C, Z):-
    Discr is (B*B - 4*A*C),
    quad_roots(A, B, Discr, Z).

quad_roots(A, B, Discr, Z):-
    Z is (-B + sqrt(Discr)) / (2*A).

quad_roots(A, B, Discr, Z):-
    Z is (-B - sqrt(Discr)) / (2*A).

sum_lengths([], 0).
    sum_lengths([N|Ns], Sum):-
        length(N, L),
        sum_lengths(Ns, NsL),
        Sum is L + NsL.
