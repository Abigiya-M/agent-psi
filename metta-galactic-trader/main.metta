;; Main Entry Point for Galactic Trader Simulation
;; Loads all modules and demonstrates key functionality

;; Import all modules
!(import! &self world)
!(import! &self rules)
!(import! &self engine)
!(import! &self simulator)

;; ===== DEMONSTRATION QUERIES =====

;; 1. Test initial simulation state
!(get-money-from-sim (init-simulation))

;; 2. Test state creation and accessors
!(get-planet (State A FOOD 100))

;; 3. Test price lookup
!(price B METAL)

;; 4. Test travel cost
!(travel-cost A B)

;; 5. Test rule validation - Travel rule should be valid
!(valid-rule (Rule "TRAVEL_A_B" TRAVEL A B) (State A None 50))

;; 6. Test rule validation - Buy rule should be valid
!(valid-rule (Rule "BUY_FOOD_A" BUY A FOOD) (State A None 50))

;; 7. Test rule execution - Travel
!(execute-rule (Rule "TRAVEL_A_B" TRAVEL A B) (State A FOOD 100))

;; 8. Test rule execution - Buy
!(execute-rule (Rule "BUY_FOOD_A" BUY A FOOD) (State A None 100))

;; 9. Test reward computation
!(compute-reward (State A None 120) (State A None 100))

;; 10. Test beta sampling
!(beta-expected-value 2 2)
