;; PLN trader bridge


;; demonstration helpers while keeping the PLN rule base
;; files intact under `py-galactic_trader/starter_rules.metta`.

!(import! &self world)
!(import! &self rules)


(: pln-summary (-> Expression))
(= (pln-summary) "PLN integration is available as an optional module; see starter_rules.metta for atom definitions.")
