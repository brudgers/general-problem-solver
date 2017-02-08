;; This file was auto generated from
;; general-problem-solver.org






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







(defun achieve-all (goals)
  "Try to achieve each goal and make sure each still holds."
  (and (every #'achieve goals)
       (subsetp goals *state*)))
