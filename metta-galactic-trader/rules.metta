;; Rule Definitions and Validation
;; Implements the rule space for trading actions

(: RuleId Atom)
(: Action Atom)

;; Rule structure: (Rule $id $action $source $destination-or-item)
;; Actions:
;; - (Rule $id TRAVEL $from $to)
;; - (Rule $id BUY $planet $item)
;; - (Rule $id SELL $planet $item)

;; Validation checks if a rule can be applied to current state

;; Travel rule validation: must be at source planet and have travel cost
;; (valid-rule (Rule $id TRAVEL $from $to) (State $planet $item $money))
(: valid-rule (-> Expression Expression Bool))
(= (valid-rule (Rule $id TRAVEL $from $to) (State $p $i $m))
   (if (== $p $from)
       (>= $m (travel-cost $from $to))
       False))

;; Buy rule validation: must be at planet with sufficient money and no item held
(= (valid-rule (Rule $id BUY $planet $item) (State $p $i $m))
   (if (== $p $planet)
       (if (== $i None)
           (>= $m (price $planet $item))
           False)
       False))

;; Sell rule validation: must be at planet and have the matching item
(= (valid-rule (Rule $id SELL $planet $item) (State $p $i $m))
   (if (== $p $planet)
       (== $i $item)
       False))

;; Helper: Check if item matches in state
(: item-matches (-> Atom Atom Bool))
(= (item-matches $expected $actual) (== $expected $actual))

;; Generate all possible rules for the trading environment
;; Travel rules: between each pair of distinct planets
(: all-travel-rules (-> Expression))
(= (all-travel-rules)
   (let* ((ps (planets)))
      (append
          (map-atom ps (lambda $p1
              (map-atom ps (lambda $p2
                  (if (== $p1 $p2)
                      ()
                      (Rule (str-concat "TRAVEL_" $p1 "_TO_" $p2) TRAVEL $p1 $p2)))))))))

;; Buy rules: all planets × all goods
(: all-buy-rules (-> Expression))
(= (all-buy-rules)
   (let* ((ps (planets)) (gs (goods)))
      (append
          (map-atom ps (lambda $p
              (map-atom gs (lambda $g
                  (Rule (str-concat "BUY_" $g "_AT_" $p) BUY $p $g))))))))

;; Sell rules: all planets × all goods
(: all-sell-rules (-> Expression))
(= (all-sell-rules)
   (let* ((ps (planets)) (gs (goods)))
      (append
          (map-atom ps (lambda $p
              (map-atom gs (lambda $g
                  (Rule (str-concat "SELL_" $g "_AT_" $p) SELL $p $g))))))))

;; Combine all rules
(: all-rules (-> Expression))
(= (all-rules)
   (append (all-travel-rules) (all-buy-rules) (all-sell-rules)))
