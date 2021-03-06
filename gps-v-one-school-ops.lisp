;;; THIS FILE AUTOGENERATED
;;;
;;; This file combines GPS version 1 with school ops to allow testing.
;;; Example use:
;;; (gps '(son-at-home car-needs-battery have-money have-phone-book) '(son-at-school) *school-ops*)
;;; (gps '(son-at-home have-money) '(son-at-school) *school-ops*)
;;; (gps '(son-at-school) '(son-at-school) *school-ops*)
;;;

(defparameter *school-ops*
  (mapcar #'convert-op
          (list
           (make-op
            :action 'drive-son-to-school
            :preconds '(son-at-home car-works)
            :add-list '(son-at-school)
            :del-list '(son-at-home))
           (make-op
            :action 'shop-installs-battery
            :preconds '(car-needs-battery shop-knows-problem shop-has-money)
            :add-list '(car-works)
            :del-list nil)
           (make-op
            :action 'tell-shop-problem
            :preconds '(in-communication-with-shop)
            :add-list '(shop-knows-problem)
            :del-list 'nil)
           (make-op
            :action 'telephone-shop
            :preconds '(know-phone-number)
            :add-list '(in-communication-with-shop)
            :del-list nil)
           (make-op
            :action 'look-up-number
            :preconds '(have-phone-book)
            :add-list '(know-phone-number)
            :del-list nil)
           (make-op
            :action 'give-shop-money
            :preconds '(have-money)
            :add-list '(shop-has-money)
            :del-list '(have-money)))))

;;; THIS FILE AUTOGENERATATED

;;; Helper Function
(defun find-all (item sequence &rest keyword-args
                               &key (test #'eql)
                               test-not
                               &allow-other-keys)
  "Find all those elements of sequence that match item.
   according to the keywords. Does not alter sequence"
  (if test-not
      (apply #'remove item sequence
             :test-not (complement test-not) keyword-args)
      (apply #'remove item sequence
             :test (complement test) keyword-args)))

;;; Special Variables
(defvar *state* nil "The current state: a list of all conditions.")
(defvar *ops* nil "A list of available operations.")

;;; Operations
(defstruct op
  "An operation."
  (action nil)
  (preconds nil)
  (add-list nil)
  (del-list nil))

;;; Main
  (defun gps (*state* goals *ops*)
    "General Problem Solver: achieve all goals using *ops*."
    (if (every #'achieve goals) 'solved))

;;; Functions
(defun achieve (goal)
  "A goal is achieved if it already holds. Or if there
   is an appropriate op for it that is applicable."
  (or (member goal *state*)
      (some #'apply-op
            (find-all goal *ops* :test #'appropriate-p))))

(defun appropriate-p (goal op)
  "An op is appropriate to a goal if the goal is on the op's add-list."
  (member goal (op-add-list op)))

(defun apply-op (op)
  "Print a message and update *state* when op is applicable."
  (when (every #'achieve (op-preconds op))
    (print (list 'executing (op-action op)))
    (setf *state* (set-difference *state* (op-del-list op)))
    (setf *state* (union *state* (op-add-list op)))))
