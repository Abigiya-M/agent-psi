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
;; NOTE: Metta runtime here does not call an external RNG for a true
;; Thompson-sample. To keep the engine simple and deterministic we
;; expose an expected-value heuristic which is alpha/(alpha+beta).
;; If true stochastic Thompson sampling is required, bind a host
;; random-beta primitive and replace `beta-sample` implementation.
(: beta-expected-value (-> Number Number Number))
(= (beta-expected-value $a $b) (/ $a (+ $a $b)))

;; Alias representing the sampling interface. Currently returns the
;; deterministic expected value; named `beta-sample` to make it clear
;; where to swap in a stochastic implementation later.
(: beta-sample (-> Number Number Number))
(= (beta-sample $a $b) (beta-expected-value $a $b))

;; Update beta parameters based on reward
;; Positive reward: increase alpha (good action)
;; Negative reward: increase beta (bad action)
;; Zero reward: slight increase to both
(: update-beta-params (-> Number Number Number Expression))
(= (update-beta-params $a $b $reward)
   (if (> $reward 0)
      (list (+ $a $reward) $b)
      (if (< $reward 0)
         (list $a (+ $b (abs $reward)))
         (list (+ $a 1) (+ $b 1)))))

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
;; Accepts a BetaRule wrapper. Returns a numeric score used for
;; selection. Currently uses `beta-sample` (deterministic expected
;; value). If BetaRule shape changes, update this matcher.
(= (get-sample-value (BetaRule $rule $a $b))
   (beta-sample $a $b))

;; Fallback: if a bare Rule is passed (no beta parameters), return
;; 0.5 as a neutral score so bare rules can be compared safely.
(= (get-sample-value (Rule $id $action $from $to))
   0.5)
