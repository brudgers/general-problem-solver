
(defun find-all (item sequence &rest keyword-args
                               &key (test #'eql)
                               test-not
                               &allow-other-keys)
  "Find all those elements of sequence that match item.
   according to tthe keywords. Does not alter sequence"
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

(defun GPS (*state* goals *ops*)
  "General Problem Solver: acieve all goals using *ops*."
  (if (every #'achieve goals) 'solved))
