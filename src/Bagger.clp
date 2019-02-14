;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Patrick Henry Bagger
;; Domain : Pack grocery bags at supermarket checkouts.
;; Author : Sebastian Moreno, Jossie Murcia
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEMPLATES

(deftemplate purchase
    (slot step)
    (multislot items)
    (multislot bags))

(deftemplate item
    (slot name)
    (slot size)
    (slot type)
    (slot isFrozen)
    (slot bagged)
    (slot onFreezerBag (default no)))

(deftemplate bag
    (slot state (default empty))
    (multislot items)
    (slot n-large-items (default 0))
    (slot n-medium-items (default 0))
    (slot n-small-items (default 0))
    (slot containBottles (default no))) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RULES

(defrule B1
    "add one bottle of Pepsi to order"
    (declare (no-loop TRUE))
    ?x <- (purchase (step check-order) (items $?items))
    (item (name potato-chips) (type bag))
    (not (item (name soft-drink) (type bottle)))
    =>
    (printout t "B1 triggered" crlf)
    (bind ?pepsi (assert (item (name Pepsi) (size large) (type bottle) (isFrozen no) (bagged no))))
    (modify ?x(items $?items ?pepsi)))

(defrule B2
    "discontinue check-order-step and start bag-large-items step"
    ?x <- (purchase (step check-order))
    =>
    (printout t "B2 triggered" crlf)
    (modify ?x(step bag-large-items)))

(defrule B3
    "put large bottle item in bag"
    (purchase (step bag-large-items))
    ?item <- (item (size large) (bagged no) (type bottle))
    ?bag <- (bag (state ?s) (n-large-items ?i) (items $?items))
    ;(test (and (< ?i 6)(not(= ?s full))))
    (test (and (< ?i 6)
              (not(eq ?s full))))
    =>
    (printout t "B3 triggered" crlf)
    (modify ?item(bagged yes))
    (modify ?bag(n-large-items (++ ?i))(items $?items ?item)(containBottles yes)))

(defrule B4
    "put large item in bag"
    (purchase (step bag-large-items))
    ?item <- (item (size large) (bagged no))
    ?bag <- (bag (state ?s) (n-large-items ?i) (items $?items))
    (test (and (< ?i 6)
              (not(eq ?s full))))
    =>
    (printout t "B4 triggered" crlf)
    (modify ?item(bagged yes))
    (modify ?bag(n-large-items (++ ?i))(items $?items ?item)))

(defrule B5
    "start fresh bag"
    ?x <- (purchase (step bag-large-items) (bags $?bags))
    ?item <- (item (size large) (bagged no))
    =>
    (printout t "B5 triggered" crlf)
	(bind ?bag (assert (bag)))
    (modify ?x(bags $?bags ?bag)))

(defrule B6
    "discontinue bag-large-items and start bag-medium-items step"
    ?x <- (purchase (step bag-large-items))
    =>
    (printout t "B6 triggered" crlf)
    (modify ?x(step bag-medium-items)))

(defrule B7
    "put medium item in freezer bag"
    (purchase (step bag-medium-items))
    ?item <- (item (size medium) (bagged no) (isFrozen yes) (onFreezerBag no))
    ?bag <- (bag (state ?s) (n-medium-items ?i))
    (test (or (> ?i 0)
              (eq ?s empty)))
    (test (not(eq ?s full)))
    =>
    (printout t "B7 triggered" crlf)
    (modify ?item(onFreezerBag yes)))

(defrule B8
    "put medium item in bag"
    (purchase (step bag-medium-items))
    ?item <- (item (size medium) (bagged no))
    ?bag <- (bag (state ?s) (n-medium-items ?i) (items $?items))
    (test (or (> ?i 0)
              (eq ?s empty)))
    (test (not(eq ?s full)))
    =>
    (printout t "B8 triggered" crlf)
    (modify ?item(bagged yes))
    (modify ?bag(n-medium-items (++ ?i))(items $?items ?item)))

(defrule B9
    "start fresh bag"
    ?x <- (purchase (step bag-medium-items) (bags $?bags))
    ?item <- (item (size medium) (bagged no))
    =>
    (printout t "B9 triggered" crlf)
	(bind ?bag (assert (bag)))
    (modify ?x(bags $?bags ?bag)))

(defrule B10
    "discontinue bag-medium-items and start bag-small-items step"
    ?x <- (purchase (step bag-medium-items))
    =>
    (printout t "B10 triggered" crlf)
    (modify ?x(step bag-small-items)))

(defrule B11
    "put small item in bag"
    (purchase (step bag-small-items))
    ?item <- (item (size small) (bagged no))
    ?bag <- (bag (state ?s) (n-small-items ?i) (containBottles no) (items $?items))
    (test (not(eq ?s full)))
    =>
    (printout t "B11 triggered" crlf)
    (modify ?item(bagged yes))
    (modify ?bag(n-small-items (++ ?i))(items $?items ?item)))

(defrule B12
    "put small item in bag"
    (purchase (step bag-small-items))
    ?item <- (item (size small) (bagged no))
    ?bag <- (bag (state ?s) (n-small-items ?i)(items $?items))
    (test (not(eq ?s full)))
    =>
    (printout t "B12 triggered" crlf)
    (modify ?item(bagged yes))
    (modify ?bag(n-small-items (++ ?i))(items $?items ?item)))

(defrule B13
    "start fresh bag"
    ?x <- (purchase (step bag-small-items) (bags $?bags))
    ?item <- (item (size small) (bagged no))
    =>
    (printout t "B13 triggered" crlf)
    (bind ?bag (assert (bag)))
    (modify ?x(bags $?bags ?bag)))

(defrule B14
    "discontinue bag-small-items and stop"
    ?x <- (purchase (step bag-small-items))
    =>
    (printout t "B14 triggered" crlf)
    (modify ?x(step all-items-bagged))
    (printout t "All items were bagged" crlf))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GETTING FACTS

(deffacts initial-facts
    (item (name potato-chips) (size small) (type bag) (isFrozen no) (bagged no))
    (item (name ice-cream) (size medium) (type bag) (isFrozen yes) (bagged no))
    (purchase
        (step check-order)
        (items (fact-id 1) (fact-id 2))))