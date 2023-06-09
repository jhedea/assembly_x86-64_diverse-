# File: sha256.s
# Run it as follows: $ nasm -f elf64 sha256.s -o sha256.o
# $ ld sha256.o -o sha256

.data
  # Constants for SHA-256
  K: .quad 0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc
     .quad 0x3956c25bf348b538, 0x59f111f1b605d019, 0x923f82a4af194f9b, 0xab1c5ed5da6d8118
     .quad 0xd807aa98a3030242, 0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2
     .quad 0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235, 0xc19bf174cf692694
     .quad 0xe49b69c19ef14ad2, 0xefbe4786384f25e3, 0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65
     .quad 0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5
     .quad 0x983e5152ee66dfab, 0xa831c66d2db43210, 0xb00327c898fb213f, 0xbf597fc7beef0ee4
     .quad 0xc6e00bf33da88fc2, 0xd5a79147930aa725, 0x06ca6351e003826f, 0x142929670a0e6e70
     .quad 0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df
     .quad 0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6, 0x92722c851482353b
     .quad 0xa2bfe8a14cf10364, 0xa81a664bbc423001, 0xc24b8b70d0f89791, 0xc76c51a30654be30
     .quad 0xd192e819d6ef5218, 0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8
     .quad 0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8
     .quad 0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3
     .quad 0x748f82ee5defb2fc, 0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec
     .quad 0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915, 0xc67178f2e372532b
     .quad 0xca273eceea26619c, 0xd186b8c721c0c207, 0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178

  # Initial hash values
  H: .quad 0x6a09e667f3bcc908, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1
     .quad 0x510e527fade682d1, 0x9b05688c2b3e6c1f, 0x1f83d9abfb41bd6b, 0x5be0cd19137e2179

.text
.global sha256

# Function to calculate SHA-256 hash
sha256:
  # Function prologue
  push %rbp
  mov %rsp, %rbp
  sub $8, %rsp

  # Save the input parameters
  mov %rdi, %rax      # input buffer
  mov %rsi, %rcx      # input length

  # Initialize local variables
  mov K(%rip), %r8    # Load constants
  mov H(%rip), %r9    # Load initial hash values
  xor %r10, %r10      # Loop counter

  # Main loop
  jmp .main_loop

.accum_loop:
  # Perform message schedule
  mov 0(%rax), %r11
  mov 8(%rax), %r12
  mov 16(%rax), %r13
  mov 24(%rax), %r14
  mov 32(%rax), %r15
  mov 40(%rax), %rbx
  mov 48(%rax), %rcx
  mov 56(%rax), %rdx

  # W[t] = Σ1(W[t-2]) + W[t-7] + Σ0(W[t-15]) + W[t-16]
  add %r11, %r12
  add %r12, %r13
  add %r13, %r14
  mov %r15, %r11
  mov %rbx, %r12
  mov %rcx, %r13
  mov %rdx, %r14
  shr $25, %r11
  shr $14, %r12
  shr $3, %r13
  xor %r14, %r11
  xor %r12, %r13
  add %r11, %r12
  add %r13, %r14
  add %r14, %r15

  # Perform the rounds
  mov %r9, %r11      # Load hash values
  xor %r15, %r11     # Ch
  mov %r15, %r12
  and %r13, %r12     # Maj
  xor %r14, %r12
  add %r8, %r15      # T1
  add %r14, %r15
  add %r15, %r11
  xor %r15, %r15     # T2
  mov %r14, %r13
  mov %r12, %r14
  mov %r11, %r12

  # Update hash values
  mov %r10, %r11
  add H(%rip), %r11
  mov %r11, %rax
  mov 8(%rax), %r11
  add %r15, %r11
  mov %r11, 8(%rax)
  mov 16(%rax), %r11
  add %r12, %r11
  mov %r11, 16(%rax)
  mov 24(%rax), %r11
  add %r14, %r11
  mov %r11, 24(%rax)
  mov 32(%rax), %r11
  add %r13, %r11
  mov %r11, 32(%rax)
  mov 40(%rax), %r11
  add %r10, %r11
  mov %r11, 40(%rax)
  mov 48(%rax), %r11
  add %r9, %r11
  mov %r11, 48(%rax)
  mov 56(%rax), %r11
  add %r8, %r11
  mov %r11, 56(%rax)

  # Increment the loop counter
  add $64, %rax
  add $1, %r10

.main_loop:
  cmp $64, %r10
  jne .accum_loop

  # Function epilogue
  add $8, %rsp
  mov %rbp, %rsp
  pop %rbp
  ret

