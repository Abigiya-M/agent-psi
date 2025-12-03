(: Rule 1
    (TTV 0)
    (STV 0.5 0.002)  
    (Complexity 1)
    (IMPLICATION
        (AND 
            (Context (STV 0.2 0.1) (AND (
                (LEFT_SQUARE (STV 0.2 0.1))
                (STILL_ALIVE (STV 0.2 0.1)))))
            (Action (SEQ_AND (MOVE_RIGHT)) ) )
        (Goal (STV 0.2 0.1) (AND (
                (CENTER_SQUARE (STV 0.2 0.1))
                (STILL_ALIVE (STV 0.2 0.1)))
    )) 
))

(: Rule 2
    (TTV 0)
    (STV 0.5 0.002)  
    (Complexity 1)
    (IMPLICATION
        (AND 
            (Context (STV 0.2 0.1) (AND (
                (LEFT_SQUARE (STV 0.2 0.1))
                (STILL_ALIVE (STV 0.2 0.1)))))
            (Action (SEQ_AND (MOVE_RIGHT)) ) )
        (Goal (STV 0.2 0.1) (AND (
                (CENTER_SQUARE (STV 0.2 0.1))
                (STILL_LIVE (STV 0.2 0.1)))
    )) 
))