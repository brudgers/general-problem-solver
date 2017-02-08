;; This file was auto generated from
;; general-problem-solver.org


(defvar *ops* nil "A list of available operators.")

(defstruct op
  "An operation."
  (action nil)
  (preconds nil)
  (add-list nil)
  (del-list nil))

;;; Major Functions

(defun achieve-all (state goals goal-stack)
  "Try to achieve each goal and make sure each still holds at the end."
  (let ((current-state state))
    (if (and (every #'(lambda (g)
                        (setf current-state
                              (achieve current-state g goal-stack)))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))

(defun achieve (state goal goal-stack)
  "A goal is achieved if:\n  It already holds\n  Or\n There is an applicable appropriate op."
  (dbg-indent :gps (length goal-stack) "Goal: ~a" goal)
  (cond ((member-equal goal state) state)
        ((member-equal goal goal-stack) nil)
        (t (some #'(lambda (op)
                     (apply-op state goal op goal-stack))
                 (find-all goal *ops* :test appropriate-p)))))









(defun executing-p (x)
  "Is the form: (executing...)?"
  (starts-with x 'executing))

(defun starts-with (list x)
  "Is this a list whose first element is x?"
  (and (consp list)
       (eql (first list) s)))

(defun convert-op (op)
  "Make op conform to the (EXECUTING op) convention."
  (unless (some #'executing-p (op-add-list op))
    (push (list 'executing (op-action op))
          (op-add-list op)))
  op)

(defun op (action &key preconds add-list del-list)
  "Make a new operator that obeys the (EXECUTING op) convention."
  (make-op :action action
           :preconds preconds
           :add-list add-list
           :del-list del-list))

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
(setf (symbol-function 'find-all-if) #'remove-if-not)
