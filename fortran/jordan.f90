! Calculate solution linaer system Ax=b by Jordan's method
! with search by column

# define precision 4

program Jordan
   implicit none
   integer :: num_args, n, i, j, ind_max
   real(precision), allocatable :: a(:), b(:), tmp(:), check_solution(:), check_answer(:)
   real(precision) :: max
   character(len=3), dimension(:), allocatable :: args

   num_args = command_argument_count()
   if(num_args > 1 .or. num_args == 0) then
      print*, './jordan.out matrix_size'
      stop
   end if

   allocate(args(num_args))
   call get_command_argument(1,args(1))
   read(args(1:4), *) n

   allocate(a(n*n))
   allocate(check_solution(n*n))
   allocate(check_answer(n))
   allocate(b(n))
   allocate(tmp(n))

   call RANDOM_NUMBER(a)
   call RANDOM_NUMBER(b)

   check_solution(1:n*n+1) = a(1:n*n+1)
   check_answer(1:n+1) = b(1:n+1)

   print*, 'Matrix A'
   call printvec(a, n, n)
   print*, 'Vector b'
   call printvec(b, n, 1)

   do i = 0, n-1, 1
      max = a((i*n)+i+1)
      ind_max = i
      do j = i+1, n-1, 1 ! search max in the column
         if (abs(a((j*n)+i+1)) > abs(max)) then
            max = a((j*n)+i+1)
            ind_max = j
         end if
      end do

      if (abs(max) < 1e-16) then
         print*, 'Infinity of solutions'
         stop
      end if

      ! swap
      tmp(1:n) = a((ind_max*n)+1:((ind_max+1)*n))
      a((ind_max*n)+1:((ind_max+1)*n)) = a((i*n)+1:((i+1)*n))
      a((i*n)+1:((i+1)*n)) = tmp(1:n)

      tmp(1) = b(i+1)
      b(i+1) = b(ind_max+1)
      b(ind_max+1) = tmp(1)

      !   division line
      b(i+1) = b(i+1)/max
      a((i*n)+i+1:((i+1)*n)) = a((i*n)+i+1:((i+1)*n))/max

      ! substraction i line from another
      do j = 0, n-1
         if (j /= i) then
            max = a((j*n)+i+1)
            a((j*n)+i+1:((j+1)*n)) = a((j*n)+i+1:((j+1)*n)) &
               - max*a((i*n)+i+1:((i+1)*n))
            b(j+1) = b(j+1) - max*b(i+1)
         endif
      end do
   end do

   print*, 'A * method_solution'
   call residual(check_solution,b,check_answer,n)

   deallocate(a)
   deallocate(check_solution)
   deallocate(check_answer)
   deallocate(b)
   deallocate(tmp)


end program jordan

subroutine printvec(vec, n, m)
   use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
   integer, intent(in) :: n
   real(precision), intent(in) :: vec(n)

   do i = 0, n-1, 1
      do j = 0, m-1, 1
         write(stdout,"(f10.6)", advance='no') vec(i*m+j+1)
      end do
      print*
   end do
   print*

   return
end subroutine

subroutine residual(a, x, b, n)
   use, intrinsic :: iso_fortran_env, only : stdout=>output_unit
   integer, intent(in) :: n
   real(precision), intent(in) :: a(n*n), b(n), x(n)
   real(precision) :: sum, total_sum

   total_sum = 0
   do i = 0, n-1, 1
      sum = 0
      do j = 0, n-1
         sum = sum + a(i*n+j+1)*x(j+1)
      end do
      write(stdout,"(f10.6)", advance='yes') sum
      total_sum = total_sum + sum-b(i+1)
   end do
   print*
   print*, 'Residual: ', total_sum

   return
end subroutine
