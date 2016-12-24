;;;--------------------------------------------------
;;; define global variables
;;;--------------------------------------------------

(defparameter *max-label-length* 30)

;;lists

;;lists
(defparameter *wizard-nodes* '((living-room (you are in the living-room.
					     a wizard is snoring loudly on the couch.))
			       (garden (you are in a beautiful garden.
					there is a well in front of you.))
			       (attic (you are in the attic.
				       there is a giant welding torch in the corner.))))

(defparameter *wizard-edges* '((living-room (garden west door)
				            (attic upstairs ladder))
			       (garden (living-room east door))
			       (attic (living-room downstairs ladder))))

;;;--------------------------------------------------
;;; define functions
;;;--------------------------------------------------

;; DOTフォーマットはファイル名に
;; アルファベット、数字、アンダースコアしか使えない
;; 条件を満たすように変換する関数
(defun dot-name (exp)
  (substitute-if #\_ (complement #'alphanumericp) (prin1-to-string exp)))

(defun dot-label (exp)
  (if exp
      (let ((s (write-to-string exp :pretty nil)))
	(if (> (length s) *max-label-length*)
	    (concatenate 'string (subseq s 0 (- *max-label-length* 3)) "...")
	    s))
      ""))

(defun nodes->dot (nodes)
  (mapc (lambda (node)
	  (fresh-line)
	  (princ (dot-name (car node)))
	  (princ "[label=\"")
	  (princ (dot-label node))
	  (princ "\"];"))
	nodes))


(defun edges->dot (edges)
  (mapc (lambda (node)          ;[node: e.g] (living-room (garden west door) (bla bla bla))
	  (mapc (lambda (edge)  ;[edge: e.g] ((garden west door) (bla bla bla))
		  (fresh-line)
		  (princ (dot-name (car node)))
		  (princ "->")
		  (princ (dot-name (car edge)))
		  (princ "[label=\"")
		  (princ (dot-label (cdr edge)))
		  (princ "\"];"))
		(cdr node)))
	edges))

;;==========================
;; ****NOTE****
;; (mapc (lambda (var)
;; 	(do-some-thing)
;; 	lst))
;;
;; [VAR = each item of LST]
;;==========================

(defun graph->dot (nodes edges)
  (princ "digraph{")
  (nodes->dot nodes)
  (edges->dot edges)
  (princ "}"))


(defun dot->png (fname thunk)
  (with-open-file (*standard-output*
		   fname
		   :direction :output
		   :if-exists :supersede)
    (funcall thunk))
  (ext:shell (concatenate 'string "dot -Tpng -O " fname))) ;there is a BUG!!
      

(defun graph->png (fname nodes edges)
  (dot->png fname
	    (lambda ()
	      (graph->dot nodes edges))))
