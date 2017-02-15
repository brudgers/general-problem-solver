;; This file was auto generated from
;; general-problem-solver.org

(load "gps-debugger.lisp")

(defun action-p (x)
  "Is x something that is (start) or (executing...)?"
  (or (equal x '(start))
      (executing-p x)))

(defun gps (state goals &optional (*ops* *ops))
  "General Problem Solver: from state, achieve goals using *ops*."
  (find-all-if #'action-p
               (achieve-all (cons '(start) state) goals nil)))

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
                 (find-all goal *ops* :test #'appropriate-p)))))

(defun appropriate-p (goal op)
  "An op is approriate to a goal if the goal is in the op's add list."
  (member-equal goal (op-add-list op)))

(defun apply-op (state goal op goal-stack)
  "Return a new state that is a transformation of the input state when op is applicable."
  (dbg-indent :gps (length goal-stack) "Consider: ~a" (op-action op))
  (let ((state2 (achieve-all state
                             (op-preconds op)
                             (cons goal goal-stack))))
    (unless (null state2)
      ;; return an updated state
      (dbg-indent :gps (length goal-stack) "Action: ~a" (op-action op))
      (append (remove-if #'(lambda (x)
                             (member-equal x (op-del-list op)))
                         state2)
              (op-add-list op)))))


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

(defun member-equal (item list)
  "Test for membership in a list as set using equal."
  (member item list :test #'equal))

(defun use (oplist)
  "Use oplist as the default set of operators by setting the dynamic variable *ops* to its value."
  ;; Return something useful
  ;; but not verbose
  (length (setf *ops* oplist)))

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
