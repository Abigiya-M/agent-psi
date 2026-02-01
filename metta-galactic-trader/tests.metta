;; Test Suite for Galactic Trader
;; Validates core functionality

;; Test 1: State creation and accessors
;; =====================================
!(test-eq
    (get-planet (State A FOOD 100))
    A)

!(test-eq
    (get-item (State A FOOD 100))
    FOOD)

!(test-eq
    (get-money (State A FOOD 100))
    100)

;; Test 2: State updates
;; ====================
!(test-eq
    (get-planet (set-planet (State A FOOD 100) B))
    B)

!(test-eq
    (get-item (set-item (State A FOOD 100) METAL))
    METAL)

!(test-eq
    (get-money (set-money (State A FOOD 100) 50))
    50)

;; Test 3: Price lookups
;; ====================
!(test-eq
    (price A FOOD)
    8)

!(test-eq
    (price B METAL)
    8)

!(test-eq
    (price C FUEL)
    5)

;; Test 4: Travel costs
;; ====================
!(test-eq
    (travel-cost A B)
    1)

!(test-eq
    (travel-cost B C)
    1)

;; Test 5: State valuation
;; ======================
!(test-eq
    (state-value (State A None 100))
    100)

!(test-eq
    (state-value (State A FOOD 100))
    115.33)

;; Test 6: Travel rule validation
;; ==============================
!(test-eq
    (valid-rule (Rule "T1" TRAVEL A B) (State A None 50))
    True)

!(test-eq
    (valid-rule (Rule "T1" TRAVEL A B) (State B None 50))
    False)

!(test-eq
    (valid-rule (Rule "T1" TRAVEL A B) (State A None 0))
    False)

;; Test 7: Buy rule validation
;; ===========================
!(test-eq
    (valid-rule (Rule "B1" BUY A FOOD) (State A None 50))
    True)

!(test-eq
    (valid-rule (Rule "B1" BUY A FOOD) (State B None 50))
    False)

!(test-eq
    (valid-rule (Rule "B1" BUY A FOOD) (State A METAL 50))
    False)

!(test-eq
    (valid-rule (Rule "B1" BUY A FOOD) (State A None 5))
    False)

;; Test 8: Sell rule validation
;; ============================
!(test-eq
    (valid-rule (Rule "S1" SELL A FOOD) (State A FOOD 50))
    True)

!(test-eq
    (valid-rule (Rule "S1" SELL A FOOD) (State A METAL 50))
    False)

!(test-eq
    (valid-rule (Rule "S1" SELL A FOOD) (State B FOOD 50))
    False)

;; Test 9: Travel execution
;; =======================
!(test-eq
    (execute-rule (Rule "T1" TRAVEL A B) (State A FOOD 100))
    (State B FOOD 99))

;; Test 10: Buy execution
;; =====================
!(test-eq
    (execute-rule (Rule "B1" BUY A FOOD) (State A None 100))
    (State A FOOD 92))

;; Test 11: Sell execution
;; =======================
!(test-eq
    (execute-rule (Rule "S1" SELL A FOOD) (State A FOOD 50))
    (State A None 58))

;; Test 12: Reward computation
;; ===========================
!(test-eq
    (compute-reward (State A None 120) (State A None 100))
    20)

!(test-eq
    (compute-reward (State A FOOD 120) (State A None 100))
    20)

;; Test 13: Beta expected value
;; ============================
!(test-eq
    (beta-expected-value 1 1)
    0.5)

!(test-eq
    (beta-expected-value 2 2)
    0.5)

!(test-eq
    (beta-expected-value 3 1)
    0.75)

;; Test 14: Beta parameter updates
;; ===============================
;; Positive reward increases alpha
!(test-eq
    (update-beta-params 1 1 10)
    (BetaRule 11 1))

;; Negative reward increases beta
!(test-eq
    (update-beta-params 1 1 -5)
    (BetaRule 1 6))

;; Test 15: Simulation initialization
;; ==================================
!(test-eq
    (get-step-count (init-simulation))
    0)

!(test-eq
    (get-money-from-sim (init-simulation))
    100)


