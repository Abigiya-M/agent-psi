!(register-module! ../../pln-openpsi)
!(import! &self pln-openpsi:utils:util)

!(assertEqual (isMember (1 2 3 4) 3) 1) 
!(assertEqual (isMember (1 2 3 4) 5) 0) 

!(assertEqual (sum (1 2 3 4 5)) 15) 
!(assertEqual (sum ()) 0)

!(assertEqual (countSimilar (1 2 3 4) (3 4 5 6)) 2) 
!(assertEqual (countSimilar (1 2 3) (4 5 6)) 0)

!(assertEqual (areSimilar (1 2 3) (3 2 1)) True) 
!(assertEqual (areSimilar (1 2 3) (4 5 6)) False)
!(assertEqual (areSimilar (1 2 3) (1 2)) False)

!(assertEqual (min 5 10) 5) 