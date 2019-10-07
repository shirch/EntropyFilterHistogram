.data 
one: .word 1


.text
# Before running this code make sure that
# Settings -> Memory Configuration -> Compact, Data at Address 0
    add  $t0, $zero,$zero        
    add  $t1, $zero,$zero 
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
   sw $t1,0x2000
   break
