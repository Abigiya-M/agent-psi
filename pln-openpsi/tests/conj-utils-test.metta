!(register-module! ../../pln-openpsi)
!(import! &self pln-openpsi:utils:conj-utils)
!(import! &self pln-openpsi:utils:rule-ops)
!(import! &self pln-openpsi:utils:util)

(= (TestRule1) (: Rule 1
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (LEFT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))
        )) 
    ))
)

(= (TestRule2) (: Rule 2
        (TTV 1)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT)) ) )
            (Goal (STV 0.2 0.1) (AND (
                    (RIGHT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))
        )) 
    ))
)

(= (TestRule3) (: Rule 3
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (LEFT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (DEAD (STV 0.2 0.1)))
        )) 
    ))
)

(= (ReasonedRule) ((: Rule 200 (TTV 1) (STV 0.25 0.002) (Complexity 1) (IMPLICATION (AND (Context (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))) (Action (SEQ_AND (MOVE_RIGHT)))) (Goal (STV 0.2 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)) (DEAD (STV 0.2 0.1)))))))))

(= (AllRules) (
    (TestRule1)
    (TestRule2)
    (TestRule3)
))

!(assertEqual (findMatchingConjunctions (CENTER_SQUARE STILL_ALIVE) (MOVE_RIGHT) (AllRules)) ((TestRule2)))
!(assertEqual (findConjunctions (TestRule1) ((TestRule2) (TestRule3))) (ReasonedRule)) ;; Newly reasoned rule
!(assertEqual ((reason-conj (TestRule1) (TestRule3))) (ReasonedRule))