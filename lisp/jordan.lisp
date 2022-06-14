#|
    n - matrix size
    Calculate solution linaer system Ax=b by Jordan's method
    with search by column 
    Checked on site:
    https://www.jdoodle.com/execute-clisp-online/
|#

; For check on random matrix
(defun randlist (n)
  (let ((lst ()))
    (dotimes (i n)
       (setf lst (cons (random 101) lst)))
   lst))

; For check algo
(defun indlist (n)
  (let ((lst ()))
    (dotimes (i n)
       (setf lst (cons (+ 1 i) lst)))
   (reverse lst)))
   

(defun print-matrix (matrix dimension-x dimension-y n)
    (dotimes (x dimension-x)
        (if
            (< x 10)
            (block
                limitation_x
                (dotimes (y dimension-y)
                    (if
                        (< y 10)
                        (block
                            limitation_y
                            (princ (nth (+ (* x n) y) matrix ))
                            (princ #\Space))
                        )
                    )
                (princ #\Newline))                
            )
        )

    (princ #\Newline)
)



(defun jordan (a b n)
    (dotimes (i n)
        (setf val_max (nth (+(* i n)i) a) )
        (setf ind_max i)

        ; Search max in the column
        (dotimes (j n)
            (if
                (and (> (nth (+(* j n)i) a) val_max) (<= i j) )
                (block
                    assignments
                    (setf val_max (nth (+(* j n)i) a))
                    (setf ind_max j)
                )
            )
        )

        ; Infinity of solution
        (if
            (< (abs val_max) 1e-16)
            (error "Infinity of solutions. ~%")
        )
        
        ; Swap
        (dotimes (j n)
            (if
                (<= i j)
                (rotatef (nth (+ (* ind_max n) j) a) (nth (+ (* i n) j) a))
            )
        )
        (rotatef (nth ind_max b) (nth i b))
        
        ; Division line
        (setf (nth i b) (/(nth i b) val_max))
        (dotimes (j n)
            (if
                (<= i j)
                (setf (nth (+(* i n)j) a) (/ (nth (+(* i n)j) a) val_max))
            )
        )
        
        ; Substraction i line from another
        (dotimes (j n)
            (if
                (/= i j)
                (block
                    substraction
                    (setf val_max (nth (+(* j n)i) a))
                    (setf (nth j b)  ( - (nth j b) (*(nth i b) val_max) )  )
                    (dotimes (k n)
                        (setf (nth (+(* j n)k) a)  ( - (nth (+(* j n)k) a) (*(nth (+(* i n)k) a) val_max) )  )
                    )
                )
            )
        )
    )
)

(defun residual (a x b n)
    (setf total_sum 0)
    (dotimes (i n)
        (setf sum 0)
        (dotimes (j n)
            (setf sum (+ sum (* (nth (+(* i n)j) a) (nth j x)) ) )
        )
        (setf total_sum (-(+ total_sum sum)(nth i b)) )
    )
    total_sum
)

; Check matrix size
(format t "Write matrix size that greater then 0~%")
(setf n (read))
(if
     (< n 0)
     (error "Matrix size should be greather then 0. Your input: ~A~%" n)
)

(setf a (randlist (* n n)))
(setf b (randlist n))
(setf s_a (copy-list a))
(setf s_b (copy-list b))
(setf indexes (indlist n))


(format t "Matrix a ~%")
(print-matrix a n n n)
(format t "Vector b^T ~%")
(print-matrix b 1 n n)

(jordan a b n)

(format t "Result vector x^T ~%")
(print-matrix b 1 n n)

(setf total_sum (residual s_a b s_b n))
(format t "Residual: ~A~%" total_sum)