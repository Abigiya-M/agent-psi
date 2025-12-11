; Example
;; Context: (RIGHT_SQUARE ALIVE)
;; Goal: (LEFT_SQUARE ATTACKED)
(= (psiPlanner $contexts $goals $ruleSpace) (
    let* (
        ($_ (println! (Current Values: Contexts: $contexts Goals: $goals)))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($matchingGoals (matchGoals $goals $rules))
        ($_ (println! (Matched Goals:  $matchingGoals)))
        ($matchingContexts (matchContexts $matchingGoals $contexts))
        ($_ (println! (Matched Contexts:  $matchingContexts)))
        ($applicableRules $matchingContexts)
        ($_ (println! (Applicable Rules:  (size-atom $applicableRules))))
        (($sampledRule $sampledValue) (thompsonSample $applicableRules))
        ($_ (println! (Sampled Rule ID:  $sampledRule)))
        ($actions (extractRule Action $sampledRule))
        ($_ (println! (Performing Actions:  $actions)))
        ($result (performActions $actions))
        ($_ (println! (Resulting State:  $result)))
        ($updatedRule (updateRule $sampledRule $result $ruleSpace))
    ) ()
))

