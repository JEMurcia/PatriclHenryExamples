;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Patrick Henry ZooKeeper
;; Domain : Computers that won't boot 
;; Author : Sebastian Moreno, Jossie Murcia
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEMPLATES

(deftemplate animal
    (slot name)
    (slot hasHair)
    (slot isMammal)
    (slot givesMilk)
    (slot hasFeathers)
    (slot isBird)
    (slot flies)
    (slot laysEggs)
    (slot eatsMeat)
    (slot isCarnivore)
    (slot hasPointedTeeth)
    (slot hasClaws)
    (slot hasFPEyes)
    (slot hasHoofs)
    (slot isUngulate)
    (slot chewsCud)
    (slot hasTawnyColor)
    (slot hasDarkSpots)
    (slot isCheetah)
    (slot hasBlackStrips)
    (slot isTiger)
    (slot hasLongLegs)
    (slot hasLongNeck)
    (slot isGiraffe)
    (slot hasWhiteColor)
    (slot isZebra)
    (slot noFlies)
    (slot hasBWColor)
    (slot isOstrich)
    (slot swims)
    (slot isPenguin)
    (slot goodFlies)
    (slot isAlbatross))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RULES

(defrule Z1
    ?x <- (animal (hasHair TRUE))
    =>
    (modify ?x(isMammal TRUE)))

(defrule Z2
    ?x <- (animal (givesMilk TRUE))
    =>
    (modify ?x(isMammal TRUE)))

(defrule Z3
    ?x <- (animal (hasFeathers TRUE))
    =>
    (modify ?x(isBird TRUE)))

(defrule Z4
    ?x <- (animal (flies TRUE)
        (laysEggs TRUE))
    =>
    (modify ?x(isBird TRUE)))

(defrule Z5
    ?x <- (animal (isMammal TRUE)
        (eatsMeat TRUE))
    =>
    (modify ?x(isCarnivore TRUE)))

(defrule Z6
    ?x <- (animal (isMammal TRUE)
        (hasPointedTeeth TRUE)
        (hasClaws TRUE)
        (hasFPEyes TRUE))
    =>
    (modify ?x(isBird TRUE)))

(defrule Z7
    ?x <- (animal (isMammal TRUE)
        (hasHoofs TRUE))
    =>
    (modify ?x(isUngulate TRUE)))

(defrule Z8
    ?x <- (animal (isMammal TRUE)
        (chewsCud TRUE))
    =>
    (modify ?x(isUngulate TRUE)))

(defrule Z9
    "?x is a Cheetah"
    ?x <- (animal (name ?name)
        (isCarnivore TRUE)
        (hasTawnyColor TRUE)
        (hasDarkSpots TRUE))
    =>
    (modify ?x(isCheetah TRUE))
    (printout t ?name " is a Cheetah" crlf))

(defrule Z10
    "?x is a Tiger"
    ?x <- (animal (name ?name)
        (isCarnivore TRUE)
        (hasTawnyColor TRUE)
        (hasBlackStrips TRUE))
    =>
    (modify ?x(isTiger TRUE))
    (printout t ?name " is a Tiger" crlf))

(defrule Z11
    "?x is a Giraffe"
    ?x <- (animal (name ?name)
        (isUngulate TRUE)
        (hasLongLegs TRUE)
        (hasLongNeck TRUE)
        (hasTawnyColor TRUE)
        (hasDarkSpots TRUE))
    =>
    (modify ?x(isGiraffe TRUE))
    (printout t ?name " is a Giraffe" crlf))

(defrule Z12
    "?x is a Zebra"
    ?x <- (animal (name ?name)
        (isUngulate TRUE)
        (hasWhiteColor TRUE)
        (hasBlackStrips TRUE))
    =>
    (modify ?x(isZebra TRUE))
    (printout t ?name " is a Zebra" crlf))

(defrule Z13
    "?x is a Ostrich"
    ?x <- (animal (name ?name)
        (isBird TRUE)
        (noFlies TRUE)
        (hasLongLegs TRUE)
        (hasLongNeck TRUE)
        (hasBWColor TRUE))
    =>
    (modify ?x(isOstrich TRUE))
    (printout t ?name " is a Ostrich" crlf))

(defrule Z14
    "?x is a Penguin"
    ?x <- (animal (name ?name)
        (isBird TRUE)
        (noFlies TRUE)
        (swims TRUE)
        (hasBWColor TRUE))
    =>
    (modify ?x(isPenguin TRUE))
    (printout t ?name " is a Penguin" crlf))

(defrule Z15
    "?x is a Albatross"
    ?x <- (animal (name ?name)
        (isBird TRUE)
        (goodFlies TRUE))
    =>
    (modify ?x(isAlbatross TRUE))
    (printout t ?name " is a Albatross" crlf))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GETTING FACTS

(deffacts initial-facts
    (animal
        (name Stretch)
        (hasHair TRUE)
        (chewsCud TRUE)
        (hasLongLegs TRUE)
        (hasLongNeck TRUE)
        (hasTawnyColor TRUE)
        (hasDarkSpots TRUE)))
