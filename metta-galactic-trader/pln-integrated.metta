;; PLN integrated placeholder
;; This file previously contained a full PLN-driven pipeline.
;; To reduce surface complexity we keep a short adapter that
;; documents the intended PLN usage and exposes a minimal API
;; for inspection and audits.

!(import! &self world)
!(import! &self rules)

(: pln-enabled? (-> Bool))
(= (pln-enabled?) False)

(: pln-info (-> Expression))
(= (pln-info) "PLN integration is available but disabled by default. See starter_rules.metta for rule atoms.")
