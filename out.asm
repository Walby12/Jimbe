segment .text
global _start
_start:
; Dump function for printing entire stack
dump_stack:
  ; Save registers
  push rbp
  mov rbp, rsp
  add rbp, 16   ; skip saved rbp and return address

  ; Get current stack top
  mov r12, rsp      ; save current stack top
  add r12, 8        ; skip return address

.stack_loop:
  cmp r12, rbp
  jge .stack_done

  ; Print current value
  mov rdi, [r12]
  call dump_int

  ; Move to next stack item
  add r12, 8
  jmp .stack_loop

.stack_done:
  ; Print newline
  mov rax, 1
  mov rdi, 1
  lea rsi, [newline]
  mov rdx, 1
  syscall

  ; Restore registers and return
  pop rbp
  ret

; Helper function to print a single integer
dump_int:
  ; Create space on stack for local variables
  sub rsp, 32

  ; Store the number to print
  mov [rsp+24], rdi

  ; Convert number to ASCII
  lea rsi, [rsp+16] ; buffer
  mov rax, [rsp+24]  ; number to print
  mov rbx, 10        ; base 10
  mov rcx, 0         ; digit counter

  ; Handle zero case
  test rax, rax
  jnz .convert_loop
  mov byte [rsi], '0'
  inc rsi
  inc rcx
  jmp .print

.convert_loop:
  xor rdx, rdx
  div rbx            ; rax = quotient, rdx = digit
  add dl, '0'        ; convert to ASCII
  dec rsi
  mov [rsi], dl
  inc rcx
  test rax, rax
  jnz .convert_loop

.print:
  ; Write number to stdout
  mov rax, 1         ; sys_write
  mov rdi, 1         ; stdout
  mov rdx, rcx       ; length
  syscall

  ; Print space separator
  mov rax, 1
  mov rdi, 1
  lea rsi, [space]
  mov rdx, 1
  syscall

  ; Clean up stack
  add rsp, 32
  ret

; Data section
segment .data
space: db ' ', 0
newline: db 10, 0
  ;; Dump entire stack
  call dump_stack
  ;; push
  push 70
  ;; push
  push 1
  ;; minus
  pop rax
  pop rbx
  sub rax, rbx
  push rax
  ;; push
  push 420
  ;; Dump entire stack
  call dump_stack

  mov rax, 60
  mov rdi, 0
  syscall