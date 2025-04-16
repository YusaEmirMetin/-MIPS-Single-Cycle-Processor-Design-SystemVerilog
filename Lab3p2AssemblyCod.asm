addi $v0, $zero, 5      # $v0 = 5
addi $v1, $zero, 12     # $v1 = 12
addi $a3, $v1, -9       # $a3 = $v1 - 9
or   $a0, $a3, $v0      # $a0 = $a3 | $v0
and  $a1, $v1, $a0      # $a1 = $v1 & $a0
add  $a1, $a1, $a0      # $a1 = $a1 + $a0
beq  $a1, $a3, label1   # if $a1 == $a3, jump to label1
slt  $a0, $v1, $a0      # $a0 = ($v1 < $a0) ? 1 : 0
beq  $a0, $zero, label2 # if $a0 == 0, jump to label2
addi $a1, $zero, 0      # $a1 = 0
slt  $a0, $a3, $v0      # $a0 = ($a3 < $v0) ? 1 : 0
add  $a3, $a0, $a1      # $a3 = $a0 + $a1
sub  $a3, $a3, $v1      # $a3 = $a3 - $v1
sw   $a3, 68($v1)       # Memory[$v1 + 68] = $a3
lw   $v0, 80($v1)       # $v0 = Memory[$v1 + 80]
j    label3             # Jump to label3
addi $v0, $zero, 1      # $v0 = 1
sw   $v0, 84($v1)       # Memory[$v1 + 84] = $v0

label1:
# Corresponds to the branch target for beq $a1, $a3, label1

label2:
# Corresponds to the branch target for beq $a0, $zero, label2

label3:
# Corresponds to the jump target for j label3
