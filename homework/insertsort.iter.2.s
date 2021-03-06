#------------------------------------------
#   Chunwei Yan     2012/10/19
#------------------------------------------
    .data
array:.space 1024
address:.space 512
datas_1:.asciiz "3745809621"
datas_2:.asciiz "0123456789"
datas_3:.asciiz "9876543210"
trying_to_sort_message:.asciiz "\ntrying to sort: "
split_message:.asciiz "\n"
begin_assign_data_message:.asciiz "\n>begin to trans ascii string to int array\n"
begin_sort_message:.asciiz "\n>begin to sort\n"
end_message:.asciiz "\n>end....\n"

    .text
main:
#   used registers:
#   $s4     1

    #---- parse ascii string to int array ----
    #---- three circles
    la      $t6, array           # $t6 <- array
    li      $s7, 1               #$s7   pointer

sort_each:
    li      $t3, 1
    beq     $s7, $t3, sort1
    li      $t3, 2
    beq     $s7, $t3, sort2
    li      $t3, 3
    beq     $s7, $t3, sort3
    jal     $ra

sort1:
    la      $s1, datas_1         #address of datas
    addi    $s7, $s7, 1
    j       input_data
sort2:
    la      $s1, datas_2         #address of datas
    addi    $s7, $s7, 1
    j       input_data
sort3:
    la      $s1, datas_3         #address of datas
    addi    $s7, $s7, 1
    j       input_data
    jal     $ra

input_data: #<<<<<< begin input data to array <<<<<<<<
#   used registers
#   $s1     address of ascii string
#   $t0     i
#   $t1     N
#   $t2     tem address
    li      $t1, 10              # N
    li      $t0, 0               # i
    li      $t2, 0               #tem address
    #show   trying_to_sort_message
    la      $a0, trying_to_sort_message
    jal     output_string
    move    $a0, $s1            #show datas to sort
    jal     output_string
    la      $a0, split_message
    jal     output_string

    # output message
    la      $a0, begin_assign_data_message
    jal     output_string

loop:
    bne     $t0, $t1, data_trans#i<N loop
    # output message
    la      $a0, begin_sort_message
    jal     output_string
    j       insert_sort#else insert_sort

data_trans:
    addu    $t2, $s1, $t0       #get tem index of datas
    lb      $a0, 0($t2)
    addi    $a0, $a0, -48       #trans ascii to int
                                #a0, the data
    addu    $t2, $t6, $t0       #get arr element address
    sb      $a0, 0($t2)         #save int to array
    addi    $t0, $t0, 1         #i++
    j       loop
#------------------ end insert data ----------------

insert_sort: #<<<<<< begin insert_sort <<<<<<<<<<<
#used registers
#   *$s1  array address
#   $t0   i
#   $t1   j
#   $t2   N
#   $t3   tem
    la      $s1, array          # $s1 <- array
    li      $t0, 0
    li      $t2, 10

outer_loop: #<<<<<<<<<  start of outer_loop <<<<<<<<<
    #addi    $t3, $t2, -1        #tem = N-1
    beq     $t0, $t2, output    #if i==N goto output
    addi    $t1, $t0, -1         #j=i-1

    addu    $s2, $s1, $t0       #tem = arr[i]
    lb      $t4, 0($s2)         

    j       inner_loop

loopi:                          #loop for i++
    addi    $t3, $t1, 1        
    addu    $t3, $s1, $t3
    sb      $t4, 0($t3)         #arr[j+1]=arr[i] 
    addi    $t0, $t0, 1         #i++
    j       outer_loop
    
inner_loop: #<<<<<<<< start of inner_loop <<<<<<<<
#   $s2     address of arr[i]
#   $s3     address of arr[j]
#   $t4     arr[i]
#   $t5     arr[j]
#   *$s6     1
    li      $t3, -1
    beq     $t1, $t3, loopi     #if j==-1 goto outer_loop
    addu    $s3, $s1, $t1       #b = array[j]
    lb      $t5, 0($s3)
    #if a>b
    slt     $s6, $t4, $t5       #if tem<b then $s2=1
    li      $s4, 1              #$s4 = True = 1 
    beq     $s4, $s6, swap      #if a>b then swap
    j       loopi


swap:
    addi    $t3, $t1, 1         #tem = j+1
    addu    $t3, $s1, $t3 
    sb      $t5, 0($t3)         #$arr[j+1] = arr[j]
    j       loopj
    
loopj:
    addi    $t1, $t1, -1
    j       inner_loop

#------------- end of inner_loop -----------------
#------------- end of outer_loop -----------------
output:                         #output array
    li      $t0, 0              #i

output_loop:
    beq     $t0, $t2, end       #if i==N end 
    addu    $s2, $s1, $t0       #tem index address
    #output
    lb      $a0, 0($s2)
    li      $v0, 1
    syscall

    addi    $t0, $t0, 1
    j       output_loop

end:
    la      $a0, end_message
    jal     output_string
    j       sort_each

output_string:  #<<<<<<< function <<<<<<<<
    li      $v0, 4
    syscall
    jr      $ra





