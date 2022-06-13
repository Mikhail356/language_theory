comment 
n - matrix size
Calculate solution linaer system Ax=b by Jordan's method
with search by column 
Checked on site:
https://www.jdoodle.com/execute-algol68-online/
;


PROC residual = (REF [] REAL a, REF [] REAL x, REF [] REAL b, INT n) REAL:
(
    REAL total_sum, sum;
    total_sum := 0;
    FOR i FROM 0 TO n-1 DO
    
        sum := 0;
        FOR j FROM 0 TO n-1 DO
            sum := sum + (a[(i*n)+j] * x[j])
        OD;
        total_sum := total_sum + sum - b[i]
    OD;
    total_sum
);

PROC print_vec = (REF [] REAL x, INT n, INT m) VOID:
(
    print(newline);
    FOR i FROM 0 TO n-1 DO
        FOR j FROM 0 TO m-1 DO
            print((fixed(x[i*n+j], 10, 6), "     "))
        OD;
        print(newline)
    OD;
    print(newline)
);

PROC jordan = (REF [] REAL a, REF [] REAL b, INT n) VOID:
(
    REAL max, tmp;
    INT ind_max;
    FOR i FROM 0 TO n-1 DO
        max := a[(i*n)+i];
        ind_max := i;
        
        #Search max in the column#
        FOR j FROM i TO n-1 DO
            IF (ABS a[(j*n)+i] > ABS max) THEN
                max := a[(j*n)+i];
                ind_max := j
            FI
        OD;
        print((ind_max, "   ", fixed(max,10,6), newline));
        
        #Infinity of solution#
        IF (ABS max < 1e-16) THEN
            print(("Infinity of solutions", newline));
            stop
        FI;
        
        #Swap#
        FOR j FROM i TO n-1 DO
            tmp := a[(ind_max*n)+j];
            a[(ind_max*n)+j] := a[(i*n)+j];
            a[(i*n)+j] := tmp
        OD;
        tmp := b[i];
        b[i] := b[ind_max];
        b[ind_max] := tmp;
        
        
        #Division line#
        b[i] := b[i]/max;
        FOR j FROM i TO n-1 DO
            a[(i*n)+j] := a[(i*n)+j]/max
        OD;
        
        
        #Substraction i line from another#
        FOR j FROM 0 TO n-1 DO
            IF (j /= i) THEN
                max := a[(j*n)+i];
                b[j] := b[j] - (max*b[i]);
                FOR t FROM i TO n-1 DO
                    a[(j*n)+t] := a[(j*n)+t] - (max*a[(i*n)+t])
                OD
            FI
        OD
    OD
);


test:
(
    REAL answer;
    REF INT n = LOC INT; read(n);
    IF (n < 1) THEN 
        print("size should be greater then 0");
        stop
    FI;
    
    REF [] REAL a := LOC [0:n*n] REAL;
    REF [] REAL s_a := LOC [0:n*n] REAL;
    REF [] REAL b := LOC [0:n] REAL;
    REF [] REAL s_b := LOC [0:n] REAL;
    
    FOR i FROM 0 TO n*n-1 DO
        a[i] := 20*random;
        s_a[i] := a[i]
    OD;
    FOR i FROM 0 TO n-1 DO
        b[i] := 20*random;
        s_b[i] := b[i]
    OD;
    
    print(("Matrix a", newline));
    print_vec(a, n, n);
    print(("Vector b^T", newline));
    print_vec(b, 1, n);
    
    jordan(a, b, n);
    
    print(("After solve", newline,"Matrix a", newline));
    print_vec(a, n, n);
    print(("Vector b^T", newline));
    print_vec(b, 1, n);
    
    answer := residual(s_a, b, s_b, n);
    print(("Residual: ", answer, newline))
)