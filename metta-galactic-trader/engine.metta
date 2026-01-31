;; Rule Execution Engine
;; Executes rules and computes state transitions and rewards

;; Execute a rule on the current state
;; Modifies state based on rule action

(: execute-rule (-> Expression Expression Expression))

;; Travel: change planet, deduct travel cost
(= (execute-rule (Rule $id TRAVEL $from $to) (State $p $i $m))
   (State $to $i (- $m (travel-cost $from $to))))

;; Buy: acquire item, deduct price
(= (execute-rule (Rule $id BUY $planet $item) (State $p None $m))
   (State $p $item (- $m (price $planet $item))))

;; Sell: sell item, gain money
(= (execute-rule (Rule $id SELL $planet $item) (State $p $item $m))
   (State $p None (+ $m (price $planet $item))))

;; Compute reward as change in state value
;; Reward = new_state_value - old_state_value
(: compute-reward (-> Expression Expression Number))
(= (compute-reward $new-state $old-state)
   (- (state-value $new-state) (state-value $old-state)))

;; Beta distribution Thompson sampling
;; Rule: (BetaRule $id $action $params $alpha $beta)
;; Alpha/Beta updated via Bayesian learning

(: BetaRule Type)

;; Sample from Beta distribution for action selection
;; In Metta, we use a simple heuristic: alpha / (alpha + beta)
;; This gives the expected value of Beta(alpha, beta)
(: beta-expected-value (-> Number Number Number))
(= (beta-expected-value $a $b) (/ $a (+ $a $b)))

;; Update beta parameters based on reward
;; Positive reward: increase alpha (good action)
;; Negative reward: increase beta (bad action)
;; Zero reward: slight increase to both
(: update-beta-params (-> Number Number Number Expression))
(= (update-beta-params $a $b $reward)
   (if (> $reward 0)
       (BetaRule (+ $a $reward) $b)
       (if (< $reward 0)
           (BetaRule $a (+ $b (abs $reward)))
           (BetaRule (+ $a 1) (+ $b 1)))))

;; Get applicable rules for a given state
;; Returns list of (rule, sample-value) pairs
(: applicable-rules (-> Expression Expression))
(= (applicable-rules $state)
   (let $all-rules (all-rules)
      (filter-map-atom $all-rules
          (lambda $rule
              (if (valid-rule $rule $state)
                  (list $rule)
                  ())))))

;; Select best rule using Thompson sampling
;; Assumes rules have beta parameters (alpha/beta values)
;; Returns rule with highest sampled value
(: select-best-rule (-> Expression Expression))
(= (select-best-rule $applicable)
   (if (empty? $applicable)
       None
       (car-atom
           (sort-atom $applicable
               (lambda $r1 $r2
                   (> (get-sample-value $r1) (get-sample-value $r2)))))))

;; Helper: get sample value from a rule
;; For now, use simple heuristic (beta expected value)
(: get-sample-value (-> Expression Number))
(= (get-sample-value (BetaRule $a $b))
   (beta-expected-value $a $b))
