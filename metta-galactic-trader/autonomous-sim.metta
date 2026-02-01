;; Compact Autonomous Simulation demo (MeTTa)

!(import! &self world)
!(import! &self rules)
!(import! &self engine)
!(import! &self simulator)

;; Show initial state
!(print! "=== Galactic Trader Demo ===")
!(print! "Initial state:")
!(init-simulation)

;; Show a profitable trade sequence
!(print! "")
!(print! "Step 1: Travel from A to C (cost 1)")
!(execute-rule (Rule "TRAVEL_A_C" TRAVEL A C) (State A None 100))

!(print! "Step 2: Buy FUEL at C (cost 5)")
!(execute-rule (Rule "BUY_FUEL_C" BUY C FUEL) (State C None 99))

!(print! "Step 3: Travel from C to A (cost 1)")
!(execute-rule (Rule "TRAVEL_C_A" TRAVEL C A) (State C FUEL 94))

!(print! "Step 4: Sell FUEL at A (price 25)")
!(execute-rule (Rule "SELL_FUEL_A" SELL A FUEL) (State A FUEL 93))

!(print! "")
!(print! "Profit: 100 -> 118 (+18 credits from arbitrage)")
!(print! "FUEL: bought at C (5) -> sold at A (25) = +20 profit per unit")