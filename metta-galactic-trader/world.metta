;; Galactic Trader World Configuration
;; Defines planets, goods, prices, and travel costs

;; Planets in the galaxy
(: Planet Type)
(= (planets) (A B C))

;; Tradeable goods
(: Good Type)
(= (goods) (FOOD METAL FUEL))

;; Price table: (price $planet $good $cost)
(= (price A FOOD) 8)
(= (price A METAL) 15)
(= (price A FUEL) 25)

(= (price B FOOD) 20)
(= (price B METAL) 8)
(= (price B FUEL) 18)

(= (price C FOOD) 18)
(= (price C METAL) 22)
(= (price C FUEL) 5)

;; Average cost for valuation
(= (average-cost FOOD) 15.33)
(= (average-cost METAL) 15)
(= (average-cost FUEL) 16)

;; Travel costs between planets (symmetric)
(= (travel-cost A B) 1)
(= (travel-cost A C) 1)
(= (travel-cost B A) 1)
(= (travel-cost B C) 1)
(= (travel-cost C A) 1)
(= (travel-cost C B) 1)

;; State representation: (State $planet $item $money)
;; $planet: current location (A, B, or C)
;; $item: held item (FOOD, METAL, FUEL, or None)
;; $money: current funds

;; Get planet from state
(: get-planet (-> Expression Atom))
(= (get-planet (State $p $i $m)) $p)

;; Get item from state
(: get-item (-> Expression Atom))
(= (get-item (State $p $i $m)) $i)

;; Get money from state
(: get-money (-> Expression Number))
(= (get-money (State $p $i $m)) $m)

;; Update state functions
(: set-planet (-> Expression Atom Expression))
(= (set-planet (State $p $i $m) $new-p) (State $new-p $i $m))

(: set-item (-> Expression Atom Expression))
(= (set-item (State $p $i $m) $new-i) (State $p $new-i $m))

(: set-money (-> Expression Number Expression))
(= (set-money (State $p $i $m) $new-m) (State $p $i $new-m))

;; State valuation function for reward calculation
;; Value = Money + average cost of held item (single deterministic clause)
(: state-value (-> Expression Number))
(= (state-value (State $p $i $m))
   (if (== $i None)
       $m
       (+ $m (average-cost $i))))
