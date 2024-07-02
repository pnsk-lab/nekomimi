incbin "boot.bin"
db 1
dw (end_nekomimi - start_nekomimi) / 512
db "nekomimi"
db "bin"
times (512 - 2 - 8 - 3 - 1) db 0
start_nekomimi:
incbin "main.bin"
end_nekomimi:
db 0
dw 0
times 8 db 0
times 3 db 0
times (512 - 2 - 8 - 3 - 1) db 0
times (KB * 1024 - ($ - $$)) db 0
