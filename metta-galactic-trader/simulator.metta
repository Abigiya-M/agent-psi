;; Main Simulation Loop for Galactic Trader
;; Orchestrates the trading simulation with rule learning

;; Simulation state: (SimState $step $trader-state $rules $history)
;; $step: current iteration
;; $trader-state: current (State $planet $item $money)
;; $rules: list of active rules with beta parameters
;; $history: list of (action, reward) pairs

(: SimState Type)

;; Initialize simulation with starting conditions
;; Start at planet A with no item and 100 money
(: init-simulation (-> Expression))
(= (init-simulation)
   (let* ((initial-state (State A None 100))
          (initial-rules (init-beta-rules))
          (empty-history ()))
      (SimState 0 initial-state initial-rules empty-history)))

;; Initialize all rules with neutral beta parameters (1, 1)
(: init-beta-rules (-> Expression))
(= (init-beta-rules)
   (let $rules (all-rules)
      (map-atom $rules
          (lambda $rule
              (BetaRule $rule 1 1)))))

;; Step function: execute one iteration of the simulation
;; Returns new SimState after one trading action
(: step-simulation (-> Expression Expression))
(= (step-simulation (SimState $step $trader-state $rules $history))
   (let ((applicable (filter-rules-by-validity $trader-state $rules)))
      (if (empty? applicable)
          ;; No applicable rules, increment step
          (SimState (+ $step 1) $trader-state $rules $history)
          ;; Pick first applicable rule (simplified Thompson sampling)
          (let* ((best-beta-rule (car-atom applicable))
                 (base-rule (get-rule-from-beta best-beta-rule))
                 (new-trader-state (execute-rule base-rule $trader-state))
                 (reward (compute-reward new-trader-state $trader-state))
                 (updated-rules (update-rule-params $rules best-beta-rule reward))
                 (new-history (append $history (list (base-rule reward)))))
             (SimState (+ $step 1) new-trader-state updated-rules new-history)))))

;; Filter applicable rules from the rule set
(: filter-rules-by-validity (-> Expression Expression Expression))
(= (filter-rules-by-validity $trader-state $rules)
   (filter-atom $rules
       (lambda $beta-rule
           (valid-rule (get-rule-from-beta $beta-rule) $trader-state))))

;; Extract the base rule from BetaRule wrapper
(: get-rule-from-beta (-> Expression Expression))
(= (get-rule-from-beta (BetaRule $rule $a $b)) $rule)

;; Update beta parameters for the chosen rule
;; Other rules remain unchanged
(: update-rule-params (-> Expression Expression Number Expression))
(= (update-rule-params $rules $chosen-beta-rule $reward)
   (map-atom $rules
       (lambda $beta-rule
           (if (== $beta-rule $chosen-beta-rule)
               (let* ((old-a (get-alpha $beta-rule))
                      (old-b (get-beta $beta-rule))
                      (updated (update-beta-params old-a old-b $reward)))
                  (BetaRule (get-rule-from-beta $beta-rule)
                      (get-alpha updated)
                      (get-beta updated)))
               $beta-rule))))

;; Accessor functions for beta parameters
(: get-alpha (-> Expression Number))
(= (get-alpha (BetaRule $rule $a $b)) $a)

(: get-beta (-> Expression Number))
(= (get-beta (BetaRule $rule $a $b)) $b)

;; Run simulation for N steps
;; Returns final simulation state
(: run-simulation (-> Number Expression))
(= (run-simulation $max-steps)
   (run-simulation-loop $max-steps (init-simulation)))

(: run-simulation-loop (-> Number Expression Expression))
(= (run-simulation-loop 0 $sim-state) $sim-state)
(= (run-simulation-loop $steps $sim-state)
   (if (<= $steps 0)
       $sim-state
       (let ((money (get-money-from-sim $sim-state)))
          (if (<= money 0)
              $sim-state
              (run-simulation-loop (- $steps 1) (step-simulation $sim-state))))))

;; Extract trader state money from SimState
(: get-money-from-sim (-> Expression Number))
(= (get-money-from-sim (SimState $step (State $p $i $m) $rules $hist))
   $m)

;; Extract step count
(: get-step-count (-> Expression Number))
(= (get-step-count (SimState $step $trader $rules $hist)) $step)

;; Get simulation history
(: get-history (-> Expression Expression))
(= (get-history (SimState $step $trader $rules $hist)) $hist)
