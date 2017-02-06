;; This file was auto generated from
;; general-problem-solver.org
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

(defvar *state* nil "The current state: a list of all conditions.")
(defvar *ops* nil "A list of available operations.")

(defstruct op
  "An operation."
  (action nil)
  (preconds nil)
  (add-list nil)
  (del-list nil))

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

(defun achieve-all (goals)
  "Try to achieve each goal and make sure each still holds."
  (and (every #'achieve goals)
       (subsetp goals *state*)))
