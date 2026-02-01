;; Main Simulation Loop for Galactic Trader
;; Orchestrates the trading simulation with rule learning

;; ======================================
;; Simulation state
;; (SimState $step $trader-state $rules $history)
;; ======================================

(: SimState Type)

;; --------------------------------------
;; Initialization
;; --------------------------------------

(: init-simulation (-> Expression))
(= (init-simulation)
   (SimState
     0
     (State A None 100)
     (init-beta-rules)
     ()))

(: init-beta-rules (-> Expression))
(= (init-beta-rules)
   (list
     (BetaRule (Rule "TRAVEL_A_C" TRAVEL A C) 1 1)
     (BetaRule (Rule "BUY_FUEL_C" BUY C FUEL) 1 1)
     (BetaRule (Rule "TRAVEL_C_A" TRAVEL C A) 1 1)
     (BetaRule (Rule "SELL_FUEL_A" SELL A FUEL) 1 1)))

;; --------------------------------------
;; One simulation step
;; --------------------------------------

(: step-simulation (-> Expression Expression))
(= (step-simulation (SimState $step $state $rules $history))
   (let $applicable
        (filter-atom $rules
          (lambda $br
            (valid-rule (get-rule-from-beta $br) $state)))
     (if (empty? $applicable)
         (SimState (+ $step 1) $state $rules $history)
         (let* (
                ($best (select-best-rule $applicable))
                ($rule (get-rule-from-beta $best))
                ($new-state (execute-rule $rule $state))
                ($reward (compute-reward $new-state $state))
                ($new-rules (update-rule-params $rules $best $reward))
                ($new-history (append $history (list $rule $reward)))
               )
           (SimState (+ $step 1) $new-state $new-rules $new-history)))))

;; --------------------------------------
;; Simulation loop 
;; --------------------------------------

(: run-simulation (-> Number Expression))
(= (run-simulation $steps)
   (run-sim-steps $steps (init-simulation)))

;; Unrolled simulation: handle small N directly
(: run-sim-steps (-> Number Expression Expression))
(= (run-sim-steps 0 $sim) $sim)
(= (run-sim-steps 1 $sim) (step-simulation $sim))
(= (run-sim-steps 2 $sim)
   (step-simulation (step-simulation $sim)))
(= (run-sim-steps 3 $sim)
   (step-simulation (step-simulation (step-simulation $sim))))
(= (run-sim-steps 4 $sim)
   (step-simulation (step-simulation (step-simulation (step-simulation $sim)))))
(= (run-sim-steps 5 $sim)
   (step-simulation (step-simulation (step-simulation (step-simulation (step-simulation $sim))))))

;; For larger N, chunk into groups of 5
(= (run-sim-steps $n $sim)
   (if (> $n 5)
       (run-sim-steps (- $n 5) (run-sim-steps 5 $sim))
       (if (== $n 5)
           (run-sim-steps 5 $sim)
           (if (== $n 4)
               (run-sim-steps 4 $sim)
               (if (== $n 3)
                   (run-sim-steps 3 $sim)
                   (if (== $n 2)
                       (run-sim-steps 2 $sim)
                       (if (== $n 1)
                           (run-sim-steps 1 $sim)
                           $sim)))))))

;; --------------------------------------
;; Accessors
;; --------------------------------------

(: get-rule-from-beta (-> Expression Expression))
(= (get-rule-from-beta (BetaRule $rule $a $b)) $rule)

(: get-alpha (-> Expression Number))
(= (get-alpha (BetaRule $rule $a $b)) $a)

(: get-beta (-> Expression Number))
(= (get-beta (BetaRule $rule $a $b)) $b)

(: get-money-from-sim (-> Expression Number))
(= (get-money-from-sim (SimState $s (State $p $i $m) $r $h)) $m)

(: get-step-count (-> Expression Number))
(= (get-step-count (SimState $s $t $r $h)) $s)

(: get-history (-> Expression Expression))
(= (get-history (SimState $s $t $r $h)) $h)
