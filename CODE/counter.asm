.data 
one: .word 1
counter: .word 0
.text
# Before running this code make sure that
# Settings -> Memory Configuration -> Compact, Data at Address 0
    add  $t0, $zero,$zero        
    lw  $t1, counter 
    lw  $t2, one        

Loop:
   add $t0,$t0,$t2
   nop
   nop
   beq $zero,$zero,Loop
   nop
   nop
   nop
   nop
   nop
   nop
ISR_Count:
   add $t1,$t1,$t2
   sw $t1,counter
   break


