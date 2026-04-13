[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)

# Some Commands Used

docker start -i riscv-dev

riscv64-linux-gnu-gcc .s -o . -static 

qemu-riscv64 -g 1234 ./t

docker exec -it 9480212daf9f /bin/bash

gdb-multiarch ./t

target remote :1234