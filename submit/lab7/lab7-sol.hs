-- Exercise 1

-- function which adds two numbers
add n1 n2 = n1 + n2

-- define without using args
-- is it the same as add?
plus = (+)

-- provide an explicit type declaration
plus' :: Num a => a -> a -> a
plus' = (+)

-- function which concats two lists
conc ls1 ls2 = ls1 ++ ls2

-- partially apply above functions:

add10 = add 10
plus5 = plus 5
concHello = conc "hello"

-- Exercise 2

first (v, _) = v
second (_, v) = v

fst3 (v, _, _) = v
snd3 (_, v, _) = v

sumFirst2 (a : (b : c)) = a+b
fnFirst2 [a, b] x y = x a b
fnFirst2 (a : (b : c)) x y = y a b

-- Exercise 3

cartesianProduct ls1 ls2 =
  [ (x, y) | x <- ls1, y <- ls2 ]

cartesianProductIf ls1 ls2 predicate =
  [ (x, y) | x <- ls1, y <- ls2, predicate x y ]

oddEvenPairs n =
  [ (x, y) | x <- [1..n], y <- [2, 4..n], odd x, even y ]

