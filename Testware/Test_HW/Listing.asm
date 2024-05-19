                    di                                      ;[0000] f3
                    ld        sp,$4ff0                      ;[0001] 31 f0 4f
                    call      $0085                         ;[0004] cd 85 00
                    jp        $0068                         ;[0007] c3 68 00
                    nop                                     ;[000a] 00
                    nop                                     ;[000b] 00
                    nop                                     ;[000c] 00
                    nop                                     ;[000d] 00
                    nop                                     ;[000e] 00
                    nop                                     ;[000f] 00
                    nop                                     ;[0010] 00
                    nop                                     ;[0011] 00
                    nop                                     ;[0012] 00
                    nop                                     ;[0013] 00
                    nop                                     ;[0014] 00
                    nop                                     ;[0015] 00
                    nop                                     ;[0016] 00
                    nop                                     ;[0017] 00
                    nop                                     ;[0018] 00
                    nop                                     ;[0019] 00
                    nop                                     ;[001a] 00
                    nop                                     ;[001b] 00
                    nop                                     ;[001c] 00
                    nop                                     ;[001d] 00
                    nop                                     ;[001e] 00
                    nop                                     ;[001f] 00
                    nop                                     ;[0020] 00
                    nop                                     ;[0021] 00
                    nop                                     ;[0022] 00
                    nop                                     ;[0023] 00
                    nop                                     ;[0024] 00
                    nop                                     ;[0025] 00
                    nop                                     ;[0026] 00
                    nop                                     ;[0027] 00
                    nop                                     ;[0028] 00
                    nop                                     ;[0029] 00
                    nop                                     ;[002a] 00
                    nop                                     ;[002b] 00
                    nop                                     ;[002c] 00
                    nop                                     ;[002d] 00
                    nop                                     ;[002e] 00
                    nop                                     ;[002f] 00
                    nop                                     ;[0030] 00
                    nop                                     ;[0031] 00
                    nop                                     ;[0032] 00
                    nop                                     ;[0033] 00
                    nop                                     ;[0034] 00
                    nop                                     ;[0035] 00
                    nop                                     ;[0036] 00
                    nop                                     ;[0037] 00
                    di                                      ;[0038] f3
                    push      af                            ;[0039] f5
                    push      bc                            ;[003a] c5
                    push      de                            ;[003b] d5
                    push      hl                            ;[003c] e5
                    ld        hl,($4c69)                    ;[003d] 2a 69 4c
                    inc       hl                            ;[0040] 23
                    ld        ($4c69),hl                    ;[0041] 22 69 4c
                    ld        a,h                           ;[0044] 7c
                    or        l                             ;[0045] b5
                    jr        nz,$004f                      ;[0046] 20 07
                    ld        hl,($4c6b)                    ;[0048] 2a 6b 4c
                    inc       hl                            ;[004b] 23
                    ld        ($4c6b),hl                    ;[004c] 22 6b 4c
                    call      $0218                         ;[004f] cd 18 02
                    xor       a                             ;[0052] af
                    ld        hl,$50c0                      ;[0053] 21 c0 50
                    ld        (hl),a                        ;[0056] 77
                    pop       hl                            ;[0057] e1
                    pop       de                            ;[0058] d1
                    pop       bc                            ;[0059] c1
                    pop       af                            ;[005a] f1
                    ei                                      ;[005b] fb
                    reti                                    ;[005c] ed 4d

                    nop                                     ;[005e] 00
                    nop                                     ;[005f] 00
                    nop                                     ;[0060] 00
                    nop                                     ;[0061] 00
                    nop                                     ;[0062] 00
                    nop                                     ;[0063] 00
                    nop                                     ;[0064] 00
                    nop                                     ;[0065] 00
                    retn                                    ;[0066] ed 45

                    ld        a,$ff                         ;[0068] 3e ff
                    out       ($00),a                       ;[006a] d3 00
                    ld        a,$01                         ;[006c] 3e 01
                    ld        ($5000),a                     ;[006e] 32 00 50
                    xor       a                             ;[0071] af
                    ld        hl,$50c0                      ;[0072] 21 c0 50
                    ld        (hl),a                        ;[0075] 77
                    im        1                             ;[0076] ed 56
                    ei                                      ;[0078] fb
                    call      $036f                         ;[0079] cd 6f 03
                    call      $00b4                         ;[007c] cd b4 00
                    halt                                    ;[007f] 76
                    jr        $007f                         ;[0080] 18 fd
                    jr        $0082                         ;[0082] 18 fe
                    jp        (hl)                          ;[0084] e9
                    xor       a                             ;[0085] af
                    ld        hl,$4c00                      ;[0086] 21 00 4c
                    ld        bc,$01dc                      ;[0089] 01 dc 01
                    ld        de,$4c01                      ;[008c] 11 01 4c
                    ld        (hl),a                        ;[008f] 77
                    ldir                                    ;[0090] ed b0
                    ld        hl,$4c05                      ;[0092] 21 05 4c
                    ld        (hl),$13                      ;[0095] 36 13
                    ld        hl,$4c0f                      ;[0097] 21 0f 4c
                    ld        (hl),$15                      ;[009a] 36 15
                    ld        hl,$4c19                      ;[009c] 21 19 4c
                    ld        (hl),$15                      ;[009f] 36 15
                    ld        hl,$0e75                      ;[00a1] 21 75 0e
                    ld        de,$4ddc                      ;[00a4] 11 dc 4d
                    ld        bc,$0001                      ;[00a7] 01 01 00
                    call      $0c65                         ;[00aa] cd 65 0c
                    ld        hl,$4000                      ;[00ad] 21 00 40
                    ld        ($4c67),hl                    ;[00b0] 22 67 4c
                    ret                                     ;[00b3] c9

                    ret                                     ;[00b4] c9

                    inc       l                             ;[00b5] 2c
                    ret       nz                            ;[00b6] c0
                    inc       h                             ;[00b7] 24
                    ret       nz                            ;[00b8] c0
                    inc       de                            ;[00b9] 13
                    ret                                     ;[00ba] c9

                    ld        a,l                           ;[00bb] 7d
                    cpl                                     ;[00bc] 2f
                    ld        l,a                           ;[00bd] 6f
                    ld        a,h                           ;[00be] 7c
                    cpl                                     ;[00bf] 2f
                    ld        h,a                           ;[00c0] 67
                    ld        a,e                           ;[00c1] 7b
                    cpl                                     ;[00c2] 2f
                    ld        e,a                           ;[00c3] 5f
                    ld        a,d                           ;[00c4] 7a
                    cpl                                     ;[00c5] 2f
                    ld        d,a                           ;[00c6] 57
                    inc       l                             ;[00c7] 2c
                    ret       nz                            ;[00c8] c0
                    inc       h                             ;[00c9] 24
                    ret       nz                            ;[00ca] c0
                    inc       de                            ;[00cb] 13
                    ret                                     ;[00cc] c9

                    call      $00d0                         ;[00cd] cd d0 00
                    ld        a,(bc)                        ;[00d0] 0a
                    inc       bc                            ;[00d1] 03
                    ld        l,a                           ;[00d2] 6f
                    ld        a,(bc)                        ;[00d3] 0a
                    inc       bc                            ;[00d4] 03
                    ld        h,a                           ;[00d5] 67
                    ld        a,(bc)                        ;[00d6] 0a
                    inc       bc                            ;[00d7] 03
                    ld        e,a                           ;[00d8] 5f
                    ld        a,(bc)                        ;[00d9] 0a
                    inc       bc                            ;[00da] 03
                    ld        d,a                           ;[00db] 57
                    push      bc                            ;[00dc] c5
                    exx                                     ;[00dd] d9
                    pop       bc                            ;[00de] c1
                    ret                                     ;[00df] c9

                    push      hl                            ;[00e0] e5
                    call      $00fc                         ;[00e1] cd fc 00
                    pop       hl                            ;[00e4] e1
                    inc       (hl)                          ;[00e5] 34
                    ret       nz                            ;[00e6] c0
                    inc       hl                            ;[00e7] 23
                    inc       (hl)                          ;[00e8] 34
                    ret       nz                            ;[00e9] c0
                    inc       hl                            ;[00ea] 23
                    inc       (hl)                          ;[00eb] 34
                    ret       nz                            ;[00ec] c0
                    inc       hl                            ;[00ed] 23
                    inc       (hl)                          ;[00ee] 34
                    ret       nz                            ;[00ef] c0
                    inc       hl                            ;[00f0] 23
                    inc       (hl)                          ;[00f1] 34
                    ret       nz                            ;[00f2] c0
                    inc       hl                            ;[00f3] 23
                    inc       (hl)                          ;[00f4] 34
                    ret       nz                            ;[00f5] c0
                    inc       hl                            ;[00f6] 23
                    inc       (hl)                          ;[00f7] 34
                    ret       nz                            ;[00f8] c0
                    inc       hl                            ;[00f9] 23
                    inc       (hl)                          ;[00fa] 34
                    ret                                     ;[00fb] c9

                    call      $00ff                         ;[00fc] cd ff 00
                    ld        a,(hl)                        ;[00ff] 7e
                    cpl                                     ;[0100] 2f
                    ld        (hl),a                        ;[0101] 77
                    inc       hl                            ;[0102] 23
                    ld        a,(hl)                        ;[0103] 7e
                    cpl                                     ;[0104] 2f
                    ld        (hl),a                        ;[0105] 77
                    inc       hl                            ;[0106] 23
                    ld        a,(hl)                        ;[0107] 7e
                    cpl                                     ;[0108] 2f
                    ld        (hl),a                        ;[0109] 77
                    inc       hl                            ;[010a] 23
                    ld        a,(hl)                        ;[010b] 7e
                    cpl                                     ;[010c] 2f
                    ld        (hl),a                        ;[010d] 77
                    inc       hl                            ;[010e] 23
                    ret                                     ;[010f] c9

                    exx                                     ;[0110] d9
                    ld        a,d                           ;[0111] 7a
                    or        e                             ;[0112] b3
                    or        h                             ;[0113] b4
                    or        l                             ;[0114] b5
                    exx                                     ;[0115] d9
                    or        d                             ;[0116] b2
                    or        e                             ;[0117] b3
                    or        h                             ;[0118] b4
                    or        l                             ;[0119] b5
                    ret                                     ;[011a] c9

                    ld        a,(hl)                        ;[011b] 7e
                    inc       hl                            ;[011c] 23
                    cp        $2b                           ;[011d] fe 2b
                    ret       z                             ;[011f] c8
                    cp        $2d                           ;[0120] fe 2d
                    scf                                     ;[0122] 37
                    ret       z                             ;[0123] c8
                    dec       hl                            ;[0124] 2b
                    or        a                             ;[0125] b7
                    ret                                     ;[0126] c9

                    ld        a,(hl)                        ;[0127] 7e
                    call      $0b67                         ;[0128] cd 67 0b
                    ret       c                             ;[012b] d8
                    inc       hl                            ;[012c] 23
                    jr        $0127                         ;[012d] 18 f8
                    cp        $0a                           ;[012f] fe 0a
                    jr        nc,$0136                      ;[0131] 30 03
                    add       $30                           ;[0133] c6 30
                    ret                                     ;[0135] c9

                    add       $37                           ;[0136] c6 37
                    ret                                     ;[0138] c9

                    ld        a,b                           ;[0139] 78
                    or        a                             ;[013a] b7
                    ret       nz                            ;[013b] c0
                    or        c                             ;[013c] b1
                    ret       z                             ;[013d] c8
                    ld        a,c                           ;[013e] 79
                    cp        $25                           ;[013f] fe 25
                    ret       nc                            ;[0141] d0
                    cp        $02                           ;[0142] fe 02
                    ccf                                     ;[0144] 3f
                    ret                                     ;[0145] c9

                    ld        hl,$0000                      ;[0146] 21 00 00
                    dec       de                            ;[0149] 1b
                    push      hl                            ;[014a] e5
                    pop       af                            ;[014b] f1
                    inc       de                            ;[014c] 13
                    ld        a,(de)                        ;[014d] 1a
                    sub       $30                           ;[014e] d6 30
                    ccf                                     ;[0150] 3f
                    ret       nc                            ;[0151] d0
                    cp        $0a                           ;[0152] fe 0a
                    ret       nc                            ;[0154] d0
                    push      hl                            ;[0155] e5
                    add       hl,hl                         ;[0156] 29
                    jr        c,$016b                       ;[0157] 38 12
                    ld        c,l                           ;[0159] 4d
                    ld        b,h                           ;[015a] 44
                    add       hl,hl                         ;[015b] 29
                    jr        c,$016b                       ;[015c] 38 0d
                    add       hl,hl                         ;[015e] 29
                    jr        c,$016b                       ;[015f] 38 0a
                    add       hl,bc                         ;[0161] 09
                    jr        c,$016b                       ;[0162] 38 07
                    add       l                             ;[0164] 85
                    ld        l,a                           ;[0165] 6f
                    jr        nc,$014b                      ;[0166] 30 e3
                    inc       h                             ;[0168] 24
                    jr        nz,$014b                      ;[0169] 20 e0
                    pop       hl                            ;[016b] e1
                    scf                                     ;[016c] 37
                    ret                                     ;[016d] c9

                    ld        a,l                           ;[016e] 7d
                    cpl                                     ;[016f] 2f
                    ld        l,a                           ;[0170] 6f
                    ld        a,h                           ;[0171] 7c
                    cpl                                     ;[0172] 2f
                    ld        h,a                           ;[0173] 67
                    inc       hl                            ;[0174] 23
                    ret                                     ;[0175] c9

                    and       a                             ;[0176] a7
                    jr        $017a                         ;[0177] 18 01
                    scf                                     ;[0179] 37
                    exx                                     ;[017a] d9
                    pop       bc                            ;[017b] c1
                    pop       hl                            ;[017c] e1
                    pop       de                            ;[017d] d1
                    push      bc                            ;[017e] c5
                    jp        c,$0b71                       ;[017f] da 71 0b
                    call      $0b71                         ;[0182] cd 71 0b
                    exx                                     ;[0185] d9
                    ret                                     ;[0186] c9

                    ld        de,$0000                      ;[0187] 11 00 00
                    bit       7,h                           ;[018a] cb 7c
                    ret       z                             ;[018c] c8
                    dec       de                            ;[018d] 1b
                    ret                                     ;[018e] c9

                    add       hl,sp                         ;[018f] 39
                    inc       hl                            ;[0190] 23
                    inc       hl                            ;[0191] 23
                    ld        a,(hl)                        ;[0192] 7e
                    inc       hl                            ;[0193] 23
                    ld        h,(hl)                        ;[0194] 66
                    ld        l,a                           ;[0195] 6f
                    ex        (sp),hl                       ;[0196] e3
                    jp        (hl)                          ;[0197] e9
                    ld        a,h                           ;[0198] 7c
                    add       $80                           ;[0199] c6 80
                    ld        b,a                           ;[019b] 47
                    ld        a,d                           ;[019c] 7a
                    add       $80                           ;[019d] c6 80
                    cp        b                             ;[019f] b8
                    ccf                                     ;[01a0] 3f
                    jp        nz,$01aa                      ;[01a1] c2 aa 01
                    ld        a,e                           ;[01a4] 7b
                    cp        l                             ;[01a5] bd
                    ccf                                     ;[01a6] 3f
                    jp        $01aa                         ;[01a7] c3 aa 01
                    ld        hl,$0000                      ;[01aa] 21 00 00
                    ret       nc                            ;[01ad] d0
                    inc       hl                            ;[01ae] 23
                    ret                                     ;[01af] c9

                    inc       hl                            ;[01b0] 23
                    inc       hl                            ;[01b1] 23
                    inc       hl                            ;[01b2] 23
                    ld        a,(hl)                        ;[01b3] 7e
                    inc       hl                            ;[01b4] 23
                    ld        h,(hl)                        ;[01b5] 66
                    ld        l,a                           ;[01b6] 6f
                    ret                                     ;[01b7] c9

                    ld        hl,$0003                      ;[01b8] 21 03 00
                    add       hl,sp                         ;[01bb] 39
                    ld        a,(hl)                        ;[01bc] 7e
                    inc       hl                            ;[01bd] 23
                    ld        h,(hl)                        ;[01be] 66
                    ld        l,a                           ;[01bf] 6f
                    ret                                     ;[01c0] c9

                    ld        hl,$0005                      ;[01c1] 21 05 00
                    add       hl,sp                         ;[01c4] 39
                    ld        a,(hl)                        ;[01c5] 7e
                    inc       hl                            ;[01c6] 23
                    ld        h,(hl)                        ;[01c7] 66
                    ld        l,a                           ;[01c8] 6f
                    ret                                     ;[01c9] c9

                    ld        hl,$0006                      ;[01ca] 21 06 00
                    add       hl,sp                         ;[01cd] 39
                    ld        a,(hl)                        ;[01ce] 7e
                    inc       hl                            ;[01cf] 23
                    ld        h,(hl)                        ;[01d0] 66
                    ld        l,a                           ;[01d1] 6f
                    ret                                     ;[01d2] c9

                    ld        hl,$0007                      ;[01d3] 21 07 00
                    add       hl,sp                         ;[01d6] 39
                    ld        a,(hl)                        ;[01d7] 7e
                    inc       hl                            ;[01d8] 23
                    ld        h,(hl)                        ;[01d9] 66
                    ld        l,a                           ;[01da] 6f
                    ret                                     ;[01db] c9

                    ld        hl,$0008                      ;[01dc] 21 08 00
                    add       hl,sp                         ;[01df] 39
                    ld        a,(hl)                        ;[01e0] 7e
                    inc       hl                            ;[01e1] 23
                    ld        h,(hl)                        ;[01e2] 66
                    ld        l,a                           ;[01e3] 6f
                    ret                                     ;[01e4] c9

                    ld        hl,$0009                      ;[01e5] 21 09 00
                    add       hl,sp                         ;[01e8] 39
                    ld        a,(hl)                        ;[01e9] 7e
                    inc       hl                            ;[01ea] 23
                    ld        h,(hl)                        ;[01eb] 66
                    ld        l,a                           ;[01ec] 6f
                    ret                                     ;[01ed] c9

                    ld        hl,$000a                      ;[01ee] 21 0a 00
                    add       hl,sp                         ;[01f1] 39
                    ld        a,(hl)                        ;[01f2] 7e
                    inc       hl                            ;[01f3] 23
                    ld        h,(hl)                        ;[01f4] 66
                    ld        l,a                           ;[01f5] 6f
                    ret                                     ;[01f6] c9

                    pop       bc                            ;[01f7] c1
                    pop       de                            ;[01f8] d1
                    push      bc                            ;[01f9] c5
                    ld        a,l                           ;[01fa] 7d
                    ld        (de),a                        ;[01fb] 12
                    inc       de                            ;[01fc] 13
                    ld        a,h                           ;[01fd] 7c
                    ld        (de),a                        ;[01fe] 12
                    ret                                     ;[01ff] c9

                    ld        a,l                           ;[0200] 7d
                    ld        (bc),a                        ;[0201] 02
                    inc       bc                            ;[0202] 03
                    ld        a,h                           ;[0203] 7c
                    ld        (bc),a                        ;[0204] 02
                    inc       bc                            ;[0205] 03
                    ld        a,e                           ;[0206] 7b
                    ld        (bc),a                        ;[0207] 02
                    inc       bc                            ;[0208] 03
                    ld        a,d                           ;[0209] 7a
                    ld        (bc),a                        ;[020a] 02
                    ret                                     ;[020b] c9

                    ld        a,d                           ;[020c] 7a
                    cp        h                             ;[020d] bc
                    ccf                                     ;[020e] 3f
                    jp        nz,$01aa                      ;[020f] c2 aa 01
                    ld        a,e                           ;[0212] 7b
                    cp        l                             ;[0213] bd
                    ccf                                     ;[0214] 3f
                    jp        $01aa                         ;[0215] c3 aa 01
                    ld        hl,$5000                      ;[0218] 21 00 50
                    ld        (hl),$00                      ;[021b] 36 00
                    ld        hl,($4dbf)                    ;[021d] 2a bf 4d
                    ld        de,($4dc1)                    ;[0220] ed 5b c1 4d
                    call      $00b5                         ;[0224] cd b5 00
                    ld        ($4dbf),hl                    ;[0227] 22 bf 4d
                    ld        ($4dc1),de                    ;[022a] ed 53 c1 4d
                    ld        hl,$5000                      ;[022e] 21 00 50
                    ld        (hl),$01                      ;[0231] 36 01
                    ld        l,(hl)                        ;[0233] 6e
                    ld        h,$00                         ;[0234] 26 00
                    ret                                     ;[0236] c9

                    ld        hl,$0000                      ;[0237] 21 00 00
                    push      hl                            ;[023a] e5
                    ld        hl,$0000                      ;[023b] 21 00 00
                    call      $018f                         ;[023e] cd 8f 01
                    call      $01dc                         ;[0241] cd dc 01
                    pop       de                            ;[0244] d1
                    ex        de,hl                         ;[0245] eb
                    and       a                             ;[0246] a7
                    sbc       hl,de                         ;[0247] ed 52
                    jp        nc,$0297                      ;[0249] d2 97 02
                    ld        hl,$0000                      ;[024c] 21 00 00
                    call      $018f                         ;[024f] cd 8f 01
                    ld        hl,$0008                      ;[0252] 21 08 00
                    call      $018f                         ;[0255] cd 8f 01
                    call      $01ca                         ;[0258] cd ca 01
                    pop       de                            ;[025b] d1
                    add       hl,de                         ;[025c] 19
                    push      hl                            ;[025d] e5
                    ld        hl,$0008                      ;[025e] 21 08 00
                    call      $018f                         ;[0261] cd 8f 01
                    call      $01dc                         ;[0264] cd dc 01
                    pop       de                            ;[0267] d1
                    ex        de,hl                         ;[0268] eb
                    and       a                             ;[0269] a7
                    sbc       hl,de                         ;[026a] ed 52
                    ld        de,$0010                      ;[026c] 11 10 00
                    ex        de,hl                         ;[026f] eb
                    and       a                             ;[0270] a7
                    sbc       hl,de                         ;[0271] ed 52
                    jp        nc,$027c                      ;[0273] d2 7c 02
                    ld        hl,$0010                      ;[0276] 21 10 00
                    jp        $028a                         ;[0279] c3 8a 02
                    ld        hl,$0008                      ;[027c] 21 08 00
                    call      $018f                         ;[027f] cd 8f 01
                    call      $01dc                         ;[0282] cd dc 01
                    pop       de                            ;[0285] d1
                    ex        de,hl                         ;[0286] eb
                    and       a                             ;[0287] a7
                    sbc       hl,de                         ;[0288] ed 52
                    push      hl                            ;[028a] e5
                    call      $03ae                         ;[028b] cd ae 03
                    pop       bc                            ;[028e] c1
                    pop       bc                            ;[028f] c1
                    pop       de                            ;[0290] d1
                    add       hl,de                         ;[0291] 19
                    pop       bc                            ;[0292] c1
                    push      hl                            ;[0293] e5
                    jp        $023b                         ;[0294] c3 3b 02
                    pop       bc                            ;[0297] c1
                    ret                                     ;[0298] c9

                    ld        hl,$0000                      ;[0299] 21 00 00
                    push      hl                            ;[029c] e5
                    ld        hl,$fff3                      ;[029d] 21 f3 ff
                    add       hl,sp                         ;[02a0] 39
                    ld        sp,hl                         ;[02a1] f9
                    ld        hl,$000a                      ;[02a2] 21 0a 00
                    add       hl,sp                         ;[02a5] 39
                    ld        (hl),$00                      ;[02a6] 36 00
                    jp        $02b0                         ;[02a8] c3 b0 02
                    ld        hl,$000a                      ;[02ab] 21 0a 00
                    add       hl,sp                         ;[02ae] 39
                    inc       (hl)                          ;[02af] 34
                    ld        hl,$000a                      ;[02b0] 21 0a 00
                    add       hl,sp                         ;[02b3] 39
                    ld        a,(hl)                        ;[02b4] 7e
                    sub       $10                           ;[02b5] d6 10
                    jp        nc,$02cc                      ;[02b7] d2 cc 02
                    ld        de,$4c6f                      ;[02ba] 11 6f 4c
                    ld        hl,$000a                      ;[02bd] 21 0a 00
                    add       hl,sp                         ;[02c0] 39
                    ld        l,(hl)                        ;[02c1] 6e
                    ld        h,$00                         ;[02c2] 26 00
                    add       hl,de                         ;[02c4] 19
                    ex        de,hl                         ;[02c5] eb
                    ld        a,$ff                         ;[02c6] 3e ff
                    ld        (de),a                        ;[02c8] 12
                    jp        $02ab                         ;[02c9] c3 ab 02
                    ld        hl,$0001                      ;[02cc] 21 01 00
                    add       hl,sp                         ;[02cf] 39
                    push      hl                            ;[02d0] e5
                    ld        hl,($4dc3)                    ;[02d1] 2a c3 4d
                    ld        bc,$0005                      ;[02d4] 01 05 00
                    add       hl,bc                         ;[02d7] 09
                    ld        a,(hl)                        ;[02d8] 7e
                    pop       de                            ;[02d9] d1
                    ld        (de),a                        ;[02da] 12
                    pop       hl                            ;[02db] e1
                    push      hl                            ;[02dc] e5
                    ld        l,h                           ;[02dd] 6c
                    ld        h,$00                         ;[02de] 26 00
                    ld        a,l                           ;[02e0] 7d
                    and       $01                           ;[02e1] e6 01
                    jp        z,$02cc                       ;[02e3] ca cc 02
                    ld        hl,$0000                      ;[02e6] 21 00 00
                    add       hl,sp                         ;[02e9] 39
                    push      hl                            ;[02ea] e5
                    ld        hl,($4dc3)                    ;[02eb] 2a c3 4d
                    ld        a,(hl)                        ;[02ee] 7e
                    pop       de                            ;[02ef] d1
                    ld        (de),a                        ;[02f0] 12
                    ld        hl,$4c7f                      ;[02f1] 21 7f 4c
                    push      hl                            ;[02f4] e5
                    ld        hl,$0def                      ;[02f5] 21 ef 0d
                    push      hl                            ;[02f8] e5
                    ld        hl,$0004                      ;[02f9] 21 04 00
                    add       hl,sp                         ;[02fc] 39
                    ld        l,(hl)                        ;[02fd] 6e
                    ld        h,$00                         ;[02fe] 26 00
                    push      hl                            ;[0300] e5
                    ld        a,$03                         ;[0301] 3e 03
                    call      $06fa                         ;[0303] cd fa 06
                    pop       bc                            ;[0306] c1
                    pop       bc                            ;[0307] c1
                    pop       bc                            ;[0308] c1
                    ld        hl,$4c7f                      ;[0309] 21 7f 4c
                    push      hl                            ;[030c] e5
                    call      $0c72                         ;[030d] cd 72 0c
                    push      hl                            ;[0310] e5
                    call      $0237                         ;[0311] cd 37 02
                    pop       bc                            ;[0314] c1
                    pop       bc                            ;[0315] c1
                    ld        hl,$4c7f                      ;[0316] 21 7f 4c
                    push      hl                            ;[0319] e5
                    ld        hl,$0e09                      ;[031a] 21 09 0e
                    push      hl                            ;[031d] e5
                    ld        hl,$0005                      ;[031e] 21 05 00
                    add       hl,sp                         ;[0321] 39
                    ld        l,(hl)                        ;[0322] 6e
                    ld        h,$00                         ;[0323] 26 00
                    push      hl                            ;[0325] e5
                    ld        a,$03                         ;[0326] 3e 03
                    call      $06fa                         ;[0328] cd fa 06
                    pop       bc                            ;[032b] c1
                    pop       bc                            ;[032c] c1
                    pop       bc                            ;[032d] c1
                    ld        hl,$4c7f                      ;[032e] 21 7f 4c
                    push      hl                            ;[0331] e5
                    call      $0c72                         ;[0332] cd 72 0c
                    push      hl                            ;[0335] e5
                    call      $0237                         ;[0336] cd 37 02
                    pop       bc                            ;[0339] c1
                    pop       bc                            ;[033a] c1
                    jp        $02cc                         ;[033b] c3 cc 02
                    ld        hl,$000f                      ;[033e] 21 0f 00
                    add       hl,sp                         ;[0341] 39
                    ld        sp,hl                         ;[0342] f9
                    ld        hl,$4c6f                      ;[0343] 21 6f 4c
                    ret                                     ;[0346] c9

                    ld        hl,$4c7f                      ;[0347] 21 7f 4c
                    push      hl                            ;[034a] e5
                    ld        hl,$0e21                      ;[034b] 21 21 0e
                    push      hl                            ;[034e] e5
                    ld        hl,($4dbf)                    ;[034f] 2a bf 4d
                    ld        de,($4dc1)                    ;[0352] ed 5b c1 4d
                    push      de                            ;[0356] d5
                    push      hl                            ;[0357] e5
                    ld        a,$04                         ;[0358] 3e 04
                    call      $06fa                         ;[035a] cd fa 06
                    pop       bc                            ;[035d] c1
                    pop       bc                            ;[035e] c1
                    pop       bc                            ;[035f] c1
                    pop       bc                            ;[0360] c1
                    ld        hl,$4c7f                      ;[0361] 21 7f 4c
                    push      hl                            ;[0364] e5
                    call      $0c72                         ;[0365] cd 72 0c
                    push      hl                            ;[0368] e5
                    call      $0237                         ;[0369] cd 37 02
                    pop       bc                            ;[036c] c1
                    pop       bc                            ;[036d] c1
                    ret                                     ;[036e] c9

                    ld        hl,$fff5                      ;[036f] 21 f5 ff
                    add       hl,sp                         ;[0372] 39
                    ld        sp,hl                         ;[0373] f9
                    ld        hl,$0000                      ;[0374] 21 00 00
                    ld        d,h                           ;[0377] 54
                    ld        e,l                           ;[0378] 5d
                    ld        ($4dbf),hl                    ;[0379] 22 bf 4d
                    ld        ($4dc1),de                    ;[037c] ed 53 c1 4d
                    ld        hl,$0004                      ;[0380] 21 04 00
                    add       hl,sp                         ;[0383] 39
                    push      hl                            ;[0384] e5
                    call      $0617                         ;[0385] cd 17 06
                    pop       de                            ;[0388] d1
                    call      $01fa                         ;[0389] cd fa 01
                    ld        hl,$0c7d                      ;[038c] 21 7d 0c
                    push      hl                            ;[038f] e5
                    call      $0c72                         ;[0390] cd 72 0c
                    push      hl                            ;[0393] e5
                    call      $0237                         ;[0394] cd 37 02
                    pop       bc                            ;[0397] c1
                    pop       bc                            ;[0398] c1
                    ld        hl,$0009                      ;[0399] 21 09 00
                    add       hl,sp                         ;[039c] 39
                    push      hl                            ;[039d] e5
                    call      $0299                         ;[039e] cd 99 02
                    pop       de                            ;[03a1] d1
                    call      $01fa                         ;[03a2] cd fa 01
                    jp        $038c                         ;[03a5] c3 8c 03
                    ld        hl,$000b                      ;[03a8] 21 0b 00
                    add       hl,sp                         ;[03ab] 39
                    ld        sp,hl                         ;[03ac] f9
                    ret                                     ;[03ad] c9

                    push      bc                            ;[03ae] c5
                    dec       sp                            ;[03af] 3b
                    ld        hl,$4dd2                      ;[03b0] 21 d2 4d
                    push      hl                            ;[03b3] e5
                    call      $01e5                         ;[03b4] cd e5 01
                    pop       de                            ;[03b7] d1
                    call      $01fa                         ;[03b8] cd fa 01
                    ld        hl,$4dd4                      ;[03bb] 21 d4 4d
                    push      hl                            ;[03be] e5
                    call      $01e5                         ;[03bf] cd e5 01
                    pop       de                            ;[03c2] d1
                    call      $01fa                         ;[03c3] cd fa 01
                    ld        de,$4dd0                      ;[03c6] 11 d0 4d
                    call      $01e5                         ;[03c9] cd e5 01
                    call      $01fa                         ;[03cc] cd fa 01
                    ld        hl,$0001                      ;[03cf] 21 01 00
                    add       hl,sp                         ;[03d2] 39
                    push      hl                            ;[03d3] e5
                    call      $0414                         ;[03d4] cd 14 04
                    pop       de                            ;[03d7] d1
                    call      $01fa                         ;[03d8] cd fa 01
                    call      $01b8                         ;[03db] cd b8 01
                    inc       sp                            ;[03de] 33
                    pop       bc                            ;[03df] c1
                    ret                                     ;[03e0] c9

                    push      bc                            ;[03e1] c5
                    dec       sp                            ;[03e2] 3b
                    ld        hl,$4dd8                      ;[03e3] 21 d8 4d
                    push      hl                            ;[03e6] e5
                    call      $01e5                         ;[03e7] cd e5 01
                    pop       de                            ;[03ea] d1
                    call      $01fa                         ;[03eb] cd fa 01
                    ld        hl,$4dda                      ;[03ee] 21 da 4d
                    push      hl                            ;[03f1] e5
                    call      $01e5                         ;[03f2] cd e5 01
                    pop       de                            ;[03f5] d1
                    call      $01fa                         ;[03f6] cd fa 01
                    ld        de,$4dd6                      ;[03f9] 11 d6 4d
                    call      $01e5                         ;[03fc] cd e5 01
                    call      $01fa                         ;[03ff] cd fa 01
                    ld        hl,$0001                      ;[0402] 21 01 00
                    add       hl,sp                         ;[0405] 39
                    push      hl                            ;[0406] e5
                    call      $04e9                         ;[0407] cd e9 04
                    pop       de                            ;[040a] d1
                    call      $01fa                         ;[040b] cd fa 01
                    call      $01b8                         ;[040e] cd b8 01
                    inc       sp                            ;[0411] 33
                    pop       bc                            ;[0412] c1
                    ret                                     ;[0413] c9

                    ld        hl,$0000                      ;[0414] 21 00 00
                    push      hl                            ;[0417] e5
                    push      hl                            ;[0418] e5
                    push      bc                            ;[0419] c5
                    dec       sp                            ;[041a] 3b
                    ld        hl,$0000                      ;[041b] 21 00 00
                    add       hl,sp                         ;[041e] 39
                    push      hl                            ;[041f] e5
                    ld        hl,($4dc3)                    ;[0420] 2a c3 4d
                    ld        bc,$0005                      ;[0423] 01 05 00
                    add       hl,bc                         ;[0426] 09
                    ld        a,(hl)                        ;[0427] 7e
                    pop       de                            ;[0428] d1
                    ld        (de),a                        ;[0429] 12
                    pop       hl                            ;[042a] e1
                    push      hl                            ;[042b] e5
                    ld        h,$00                         ;[042c] 26 00
                    ld        a,l                           ;[042e] 7d
                    and       $20                           ;[042f] e6 20
                    jp        z,$04b8                       ;[0431] ca b8 04
                    pop       hl                            ;[0434] e1
                    push      hl                            ;[0435] e5
                    ld        h,$00                         ;[0436] 26 00
                    ld        a,l                           ;[0438] 7d
                    and       $40                           ;[0439] e6 40
                    jp        z,$044a                       ;[043b] ca 4a 04
                    ld        hl,$0001                      ;[043e] 21 01 00
                    add       hl,sp                         ;[0441] 39
                    ld        (hl),$10                      ;[0442] 36 10
                    inc       hl                            ;[0444] 23
                    ld        (hl),$00                      ;[0445] 36 00
                    jp        $0455                         ;[0447] c3 55 04
                    ld        hl,$0001                      ;[044a] 21 01 00
                    add       hl,sp                         ;[044d] 39
                    ld        de,$000f                      ;[044e] 11 0f 00
                    ld        (hl),e                        ;[0451] 73
                    inc       hl                            ;[0452] 23
                    ld        (hl),d                        ;[0453] 72
                    ex        de,hl                         ;[0454] eb
                    ld        hl,($4dd4)                    ;[0455] 2a d4 4d
                    push      hl                            ;[0458] e5
                    call      $01c1                         ;[0459] cd c1 01
                    pop       de                            ;[045c] d1
                    ex        de,hl                         ;[045d] eb
                    and       a                             ;[045e] a7
                    sbc       hl,de                         ;[045f] ed 52
                    jp        nc,$0472                      ;[0461] d2 72 04
                    ld        hl,$0003                      ;[0464] 21 03 00
                    add       hl,sp                         ;[0467] 39
                    ex        de,hl                         ;[0468] eb
                    ld        hl,($4dd4)                    ;[0469] 2a d4 4d
                    call      $01fa                         ;[046c] cd fa 01
                    jp        $0480                         ;[046f] c3 80 04
                    ld        hl,$0003                      ;[0472] 21 03 00
                    add       hl,sp                         ;[0475] 39
                    push      hl                            ;[0476] e5
                    dec       hl                            ;[0477] 2b
                    dec       hl                            ;[0478] 2b
                    call      $01b3                         ;[0479] cd b3 01
                    pop       de                            ;[047c] d1
                    call      $01fa                         ;[047d] cd fa 01
                    ld        hl,$0005                      ;[0480] 21 05 00
                    add       hl,sp                         ;[0483] 39
                    xor       a                             ;[0484] af
                    ld        (hl),a                        ;[0485] 77
                    inc       hl                            ;[0486] 23
                    ld        (hl),a                        ;[0487] 77
                    jp        $0495                         ;[0488] c3 95 04
                    ld        hl,$0005                      ;[048b] 21 05 00
                    add       hl,sp                         ;[048e] 39
                    inc       (hl)                          ;[048f] 34
                    ld        a,(hl)                        ;[0490] 7e
                    inc       hl                            ;[0491] 23
                    jr        nz,$0495                      ;[0492] 20 01
                    inc       (hl)                          ;[0494] 34
                    ld        hl,$0005                      ;[0495] 21 05 00
                    call      $018f                         ;[0498] cd 8f 01
                    call      $01d3                         ;[049b] cd d3 01
                    pop       de                            ;[049e] d1
                    ex        de,hl                         ;[049f] eb
                    and       a                             ;[04a0] a7
                    sbc       hl,de                         ;[04a1] ed 52
                    jp        nc,$04b8                      ;[04a3] d2 b8 04
                    ld        hl,($4dc3)                    ;[04a6] 2a c3 4d
                    push      hl                            ;[04a9] e5
                    ld        de,($4dd0)                    ;[04aa] ed 5b d0 4d
                    call      $01e5                         ;[04ae] cd e5 01
                    add       hl,de                         ;[04b1] 19
                    ld        a,(hl)                        ;[04b2] 7e
                    pop       de                            ;[04b3] d1
                    ld        (de),a                        ;[04b4] 12
                    jp        $048b                         ;[04b5] c3 8b 04
                    ld        hl,$4dd0                      ;[04b8] 21 d0 4d
                    push      hl                            ;[04bb] e5
                    ld        e,(hl)                        ;[04bc] 5e
                    inc       hl                            ;[04bd] 23
                    ld        d,(hl)                        ;[04be] 56
                    ld        hl,$0007                      ;[04bf] 21 07 00
                    add       hl,sp                         ;[04c2] 39
                    call      $01b3                         ;[04c3] cd b3 01
                    add       hl,de                         ;[04c6] 19
                    pop       de                            ;[04c7] d1
                    call      $01fa                         ;[04c8] cd fa 01
                    ld        hl,$4dd4                      ;[04cb] 21 d4 4d
                    push      hl                            ;[04ce] e5
                    ld        e,(hl)                        ;[04cf] 5e
                    inc       hl                            ;[04d0] 23
                    ld        d,(hl)                        ;[04d1] 56
                    ld        hl,$0007                      ;[04d2] 21 07 00
                    add       hl,sp                         ;[04d5] 39
                    call      $01b3                         ;[04d6] cd b3 01
                    ex        de,hl                         ;[04d9] eb
                    and       a                             ;[04da] a7
                    sbc       hl,de                         ;[04db] ed 52
                    pop       de                            ;[04dd] d1
                    call      $01fa                         ;[04de] cd fa 01
                    call      $01d3                         ;[04e1] cd d3 01
                    inc       sp                            ;[04e4] 33
                    pop       bc                            ;[04e5] c1
                    pop       bc                            ;[04e6] c1
                    pop       bc                            ;[04e7] c1
                    ret                                     ;[04e8] c9

                    dec       sp                            ;[04e9] 3b
                    ld        hl,$0000                      ;[04ea] 21 00 00
                    push      hl                            ;[04ed] e5
                    pop       de                            ;[04ee] d1
                    push      de                            ;[04ef] d5
                    ld        hl,($4dda)                    ;[04f0] 2a da 4d
                    ex        de,hl                         ;[04f3] eb
                    and       a                             ;[04f4] a7
                    sbc       hl,de                         ;[04f5] ed 52
                    jp        nc,$0529                      ;[04f7] d2 29 05
                    ld        hl,$0002                      ;[04fa] 21 02 00
                    add       hl,sp                         ;[04fd] 39
                    push      hl                            ;[04fe] e5
                    ld        hl,($4dc3)                    ;[04ff] 2a c3 4d
                    ld        bc,$0005                      ;[0502] 01 05 00
                    add       hl,bc                         ;[0505] 09
                    ld        a,(hl)                        ;[0506] 7e
                    pop       de                            ;[0507] d1
                    ld        (de),a                        ;[0508] 12
                    ld        hl,$0002                      ;[0509] 21 02 00
                    add       hl,sp                         ;[050c] 39
                    ld        a,$01                         ;[050d] 3e 01
                    and       (hl)                          ;[050f] a6
                    jp        z,$0529                       ;[0510] ca 29 05
                    ld        hl,($4dd6)                    ;[0513] 2a d6 4d
                    ld        d,h                           ;[0516] 54
                    ld        e,l                           ;[0517] 5d
                    pop       hl                            ;[0518] e1
                    inc       hl                            ;[0519] 23
                    push      hl                            ;[051a] e5
                    push      de                            ;[051b] d5
                    dec       hl                            ;[051c] 2b
                    pop       de                            ;[051d] d1
                    add       hl,de                         ;[051e] 19
                    push      hl                            ;[051f] e5
                    ld        hl,($4dc3)                    ;[0520] 2a c3 4d
                    ld        a,(hl)                        ;[0523] 7e
                    pop       de                            ;[0524] d1
                    ld        (de),a                        ;[0525] 12
                    jp        $04ee                         ;[0526] c3 ee 04
                    ld        hl,$4dd6                      ;[0529] 21 d6 4d
                    push      hl                            ;[052c] e5
                    ld        e,(hl)                        ;[052d] 5e
                    inc       hl                            ;[052e] 23
                    ld        d,(hl)                        ;[052f] 56
                    push      de                            ;[0530] d5
                    call      $01ca                         ;[0531] cd ca 01
                    pop       de                            ;[0534] d1
                    add       hl,de                         ;[0535] 19
                    pop       de                            ;[0536] d1
                    call      $01fa                         ;[0537] cd fa 01
                    ld        hl,$4dda                      ;[053a] 21 da 4d
                    push      hl                            ;[053d] e5
                    ld        e,(hl)                        ;[053e] 5e
                    inc       hl                            ;[053f] 23
                    ld        d,(hl)                        ;[0540] 56
                    push      de                            ;[0541] d5
                    call      $01ca                         ;[0542] cd ca 01
                    pop       de                            ;[0545] d1
                    ex        de,hl                         ;[0546] eb
                    and       a                             ;[0547] a7
                    sbc       hl,de                         ;[0548] ed 52
                    pop       de                            ;[054a] d1
                    call      $01fa                         ;[054b] cd fa 01
                    pop       hl                            ;[054e] e1
                    push      hl                            ;[054f] e5
                    inc       sp                            ;[0550] 33
                    pop       bc                            ;[0551] c1
                    ret                                     ;[0552] c9

                    ld        hl,$fff3                      ;[0553] 21 f3 ff
                    add       hl,sp                         ;[0556] 39
                    ld        sp,hl                         ;[0557] f9
                    ld        hl,$4dcb                      ;[0558] 21 cb 4d
                    push      hl                            ;[055b] e5
                    ld        hl,$0011                      ;[055c] 21 11 00
                    add       hl,sp                         ;[055f] 39
                    call      $01b3                         ;[0560] cd b3 01
                    ld        de,$0000                      ;[0563] 11 00 00
                    pop       bc                            ;[0566] c1
                    call      $0200                         ;[0567] cd 00 02
                    ld        hl,$0008                      ;[056a] 21 08 00
                    add       hl,sp                         ;[056d] 39
                    push      hl                            ;[056e] e5
                    ld        de,($4dc7)                    ;[056f] ed 5b c7 4d
                    ld        hl,($4dc5)                    ;[0573] 2a c5 4d
                    push      de                            ;[0576] d5
                    push      hl                            ;[0577] e5
                    ld        de,($4dcd)                    ;[0578] ed 5b cd 4d
                    ld        hl,($4dcb)                    ;[057c] 2a cb 4d
                    add       hl,hl                         ;[057f] 29
                    rl        e                             ;[0580] cb 13
                    rl        d                             ;[0582] cb 12
                    add       hl,hl                         ;[0584] 29
                    rl        e                             ;[0585] cb 13
                    rl        d                             ;[0587] cb 12
                    add       hl,hl                         ;[0589] 29
                    rl        e                             ;[058a] cb 13
                    rl        d                             ;[058c] cb 12
                    add       hl,hl                         ;[058e] 29
                    rl        e                             ;[058f] cb 13
                    rl        d                             ;[0591] cb 12
                    call      $0179                         ;[0593] cd 79 01
                    pop       de                            ;[0596] d1
                    call      $01fa                         ;[0597] cd fa 01
                    ld        hl,$000c                      ;[059a] 21 0c 00
                    add       hl,sp                         ;[059d] 39
                    ex        de,hl                         ;[059e] eb
                    call      $01ee                         ;[059f] cd ee 01
                    ld        a,l                           ;[05a2] 7d
                    ld        (de),a                        ;[05a3] 12
                    ld        hl,$000b                      ;[05a4] 21 0b 00
                    add       hl,sp                         ;[05a7] 39
                    push      hl                            ;[05a8] e5
                    ld        hl,$000a                      ;[05a9] 21 0a 00
                    add       hl,sp                         ;[05ac] 39
                    call      $01b3                         ;[05ad] cd b3 01
                    ld        l,h                           ;[05b0] 6c
                    pop       de                            ;[05b1] d1
                    ld        a,l                           ;[05b2] 7d
                    ld        (de),a                        ;[05b3] 12
                    ld        hl,$4dcb                      ;[05b4] 21 cb 4d
                    push      hl                            ;[05b7] e5
                    ld        hl,$0011                      ;[05b8] 21 11 00
                    add       hl,sp                         ;[05bb] 39
                    call      $01b3                         ;[05bc] cd b3 01
                    ld        de,$0000                      ;[05bf] 11 00 00
                    pop       bc                            ;[05c2] c1
                    call      $0200                         ;[05c3] cd 00 02
                    ld        hl,$000a                      ;[05c6] 21 0a 00
                    add       hl,sp                         ;[05c9] 39
                    push      hl                            ;[05ca] e5
                    ld        hl,($4dc3)                    ;[05cb] 2a c3 4d
                    inc       hl                            ;[05ce] 23
                    inc       hl                            ;[05cf] 23
                    inc       hl                            ;[05d0] 23
                    ld        a,(hl)                        ;[05d1] 7e
                    pop       de                            ;[05d2] d1
                    ld        (de),a                        ;[05d3] 12
                    ld        hl,($4dc3)                    ;[05d4] 2a c3 4d
                    inc       hl                            ;[05d7] 23
                    inc       hl                            ;[05d8] 23
                    inc       hl                            ;[05d9] 23
                    push      hl                            ;[05da] e5
                    ld        hl,$000c                      ;[05db] 21 0c 00
                    add       hl,sp                         ;[05de] 39
                    ld        l,(hl)                        ;[05df] 6e
                    ld        h,$00                         ;[05e0] 26 00
                    set       7,l                           ;[05e2] cb fd
                    pop       de                            ;[05e4] d1
                    ld        a,l                           ;[05e5] 7d
                    ld        (de),a                        ;[05e6] 12
                    ld        hl,($4dc3)                    ;[05e7] 2a c3 4d
                    ld        (hl),$ff                      ;[05ea] 36 ff
                    ld        hl,($4dc3)                    ;[05ec] 2a c3 4d
                    inc       hl                            ;[05ef] 23
                    ex        de,hl                         ;[05f0] eb
                    ld        hl,$000b                      ;[05f1] 21 0b 00
                    add       hl,sp                         ;[05f4] 39
                    ld        a,(hl)                        ;[05f5] 7e
                    ld        (de),a                        ;[05f6] 12
                    ld        de,($4dc3)                    ;[05f7] ed 5b c3 4d
                    ld        hl,$000c                      ;[05fb] 21 0c 00
                    add       hl,sp                         ;[05fe] 39
                    ld        a,(hl)                        ;[05ff] 7e
                    ld        (de),a                        ;[0600] 12
                    ld        hl,($4dc3)                    ;[0601] 2a c3 4d
                    inc       hl                            ;[0604] 23
                    inc       hl                            ;[0605] 23
                    inc       hl                            ;[0606] 23
                    ex        de,hl                         ;[0607] eb
                    ld        hl,$000a                      ;[0608] 21 0a 00
                    add       hl,sp                         ;[060b] 39
                    ld        a,(hl)                        ;[060c] 7e
                    ld        (de),a                        ;[060d] 12
                    ld        hl,$000d                      ;[060e] 21 0d 00
                    add       hl,sp                         ;[0611] 39
                    ld        sp,hl                         ;[0612] f9
                    ld        hl,$0000                      ;[0613] 21 00 00
                    ret                                     ;[0616] c9

                    push      bc                            ;[0617] c5
                    ld        hl,$6000                      ;[0618] 21 00 60
                    ld        ($4dc3),hl                    ;[061b] 22 c3 4d
                    ld        bc,$4dc5                      ;[061e] 01 c5 4d
                    ld        hl,$8d80                      ;[0621] 21 80 8d
                    ld        de,$005b                      ;[0624] 11 5b 00
                    call      $0200                         ;[0627] cd 00 02
                    ld        hl,$0000                      ;[062a] 21 00 00
                    ld        ($4dd0),hl                    ;[062d] 22 d0 4d
                    ld        ($4dd4),hl                    ;[0630] 22 d4 4d
                    ld        hl,$0000                      ;[0633] 21 00 00
                    ld        ($4dd2),hl                    ;[0636] 22 d2 4d
                    ld        ($4dd6),hl                    ;[0639] 22 d6 4d
                    ld        hl,$0000                      ;[063c] 21 00 00
                    ld        ($4dda),hl                    ;[063f] 22 da 4d
                    ld        ($4dd8),hl                    ;[0642] 22 d8 4d
                    ld        hl,$0001                      ;[0645] 21 01 00
                    ld        ($4dc9),hl                    ;[0648] 22 c9 4d
                    ld        hl,$2580                      ;[064b] 21 80 25
                    push      hl                            ;[064e] e5
                    call      $0553                         ;[064f] cd 53 05
                    pop       bc                            ;[0652] c1
                    pop       bc                            ;[0653] c1
                    push      hl                            ;[0654] e5
                    ld        hl,($4dc3)                    ;[0655] 2a c3 4d
                    inc       hl                            ;[0658] 23
                    inc       hl                            ;[0659] 23
                    inc       hl                            ;[065a] 23
                    ld        (hl),$03                      ;[065b] 36 03
                    ld        hl,($4dc3)                    ;[065d] 2a c3 4d
                    inc       hl                            ;[0660] 23
                    inc       hl                            ;[0661] 23
                    ld        (hl),$87                      ;[0662] 36 87
                    ld        hl,$0000                      ;[0664] 21 00 00
                    pop       bc                            ;[0667] c1
                    ret                                     ;[0668] c9

                    ld        hl,$0002                      ;[0669] 21 02 00
                    add       hl,sp                         ;[066c] 39
                    ld        a,(hl)                        ;[066d] 7e
                    cp        $0c                           ;[066e] fe 0c
                    jr        nz,$067b                      ;[0670] 20 09
                    ld        hl,$0000                      ;[0672] 21 00 00
                    ld        ($4c6d),hl                    ;[0675] 22 6d 4c
                    jp        $0b1e                         ;[0678] c3 1e 0b
                    cp        $0d                           ;[067b] fe 0d
                    jr        z,$0683                       ;[067d] 28 04
                    cp        $0a                           ;[067f] fe 0a
                    jr        nz,$0696                      ;[0681] 20 13
                    xor       a                             ;[0683] af
                    ld        ($4c6e),a                     ;[0684] 32 6e 4c
                    ld        a,($4c6d)                     ;[0687] 3a 6d 4c
                    inc       a                             ;[068a] 3c
                    ld        ($4c6d),a                     ;[068b] 32 6d 4c
                    cp        $24                           ;[068e] fe 24
                    ret       nz                            ;[0690] c0
                    dec       a                             ;[0691] 3d
                    ld        ($4c6d),a                     ;[0692] 32 6d 4c
                    ret                                     ;[0695] c9

                    push      af                            ;[0696] f5
                    ld        bc,($4c6d)                    ;[0697] ed 4b 6d 4c
                    call      $0b32                         ;[069b] cd 32 0b
                    pop       af                            ;[069e] f1
                    ld        c,$1f                         ;[069f] 0e 1f
                    ld        b,a                           ;[06a1] 47
                    ld        de,$06d1                      ;[06a2] 11 d1 06
                    ld        a,(de)                        ;[06a5] 1a
                    and       a                             ;[06a6] a7
                    jr        nz,$06ac                      ;[06a7] 20 03
                    ld        a,b                           ;[06a9] 78
                    jr        $06b5                         ;[06aa] 18 09
                    inc       de                            ;[06ac] 13
                    inc       de                            ;[06ad] 13
                    cp        b                             ;[06ae] b8
                    jr        nz,$06a5                      ;[06af] 20 f4
                    dec       de                            ;[06b1] 1b
                    ld        a,(de)                        ;[06b2] 1a
                    jr        $06bd                         ;[06b3] 18 08
                    cp        $60                           ;[06b5] fe 60
                    jr        c,$06bd                       ;[06b7] 38 04
                    ld        c,$07                         ;[06b9] 0e 07
                    sub       $20                           ;[06bb] d6 20
                    ld        (hl),a                        ;[06bd] 77
                    ld        de,$0400                      ;[06be] 11 00 04
                    add       hl,de                         ;[06c1] 19
                    ld        a,c                           ;[06c2] 79
                    ld        (hl),a                        ;[06c3] 77
                    ld        a,($4c6e)                     ;[06c4] 3a 6e 4c
                    inc       a                             ;[06c7] 3c
                    ld        ($4c6e),a                     ;[06c8] 32 6e 4c
                    cp        $1c                           ;[06cb] fe 1c
                    ret       nz                            ;[06cd] c0
                    jp        $0683                         ;[06ce] c3 83 06
                    jr        nz,$0713                      ;[06d1] 20 40
                    ld        hl,$2e5b                      ;[06d3] 21 5b 2e
                    dec       h                             ;[06d6] 25
                    ld        ($2f26),hl                    ;[06d7] 22 26 2f
                    ld        a,($3b2d)                     ;[06da] 3a 2d 3b
                    dec       hl                            ;[06dd] 2b
                    ld        (de),a                        ;[06de] 12
                    ld        hl,($3e10)                    ;[06df] 2a 10 3e
                    inc       a                             ;[06e2] 3c
                    inc       a                             ;[06e3] 3c
                    ld        a,$5f                         ;[06e4] 3e 5f
                    adc       $7f                           ;[06e6] ce 7f
                    ld        e,h                           ;[06e8] 5c
                    daa                                     ;[06e9] 27
                    xor       d                             ;[06ea] aa
                    dec       a                             ;[06eb] 3d
                    call      c,$e928                       ;[06ec] dc 28 e9
                    add       hl,hl                         ;[06ef] 29
                    ret       pe                            ;[06f0] e8
                    ld        e,e                           ;[06f1] 5b
                    jp        nc,$d35d                      ;[06f2] d2 5d d3
                    ld        a,($2cae)                     ;[06f5] 3a ae 2c
                    or        $00                           ;[06f8] f6 00
                    ld        l,a                           ;[06fa] 6f
                    ld        h,$00                         ;[06fb] 26 00
                    add       hl,hl                         ;[06fd] 29
                    add       hl,sp                         ;[06fe] 39
                    push      ix                            ;[06ff] dd e5
                    ld        c,(hl)                        ;[0701] 4e
                    inc       hl                            ;[0702] 23
                    ld        b,(hl)                        ;[0703] 46
                    dec       hl                            ;[0704] 2b
                    dec       hl                            ;[0705] 2b
                    ld        de,$ffff                      ;[0706] 11 ff ff
                    push      de                            ;[0709] d5
                    push      bc                            ;[070a] c5
                    ex        de,hl                         ;[070b] eb
                    ld        hl,$0000                      ;[070c] 21 00 00
                    add       hl,sp                         ;[070f] 39
                    push      hl                            ;[0710] e5
                    ld        bc,$0aed                      ;[0711] 01 ed 0a
                    push      bc                            ;[0714] c5
                    ld        bc,$0001                      ;[0715] 01 01 00
                    push      bc                            ;[0718] c5
                    ex        de,hl                         ;[0719] eb
                    ld        b,(hl)                        ;[071a] 46
                    dec       hl                            ;[071b] 2b
                    ld        c,(hl)                        ;[071c] 4e
                    push      bc                            ;[071d] c5
                    dec       hl                            ;[071e] 2b
                    dec       hl                            ;[071f] 2b
                    push      hl                            ;[0720] e5
                    call      $072e                         ;[0721] cd 2e 07
                    ex        de,hl                         ;[0724] eb
                    ld        hl,$000e                      ;[0725] 21 0e 00
                    add       hl,sp                         ;[0728] 39
                    ld        sp,hl                         ;[0729] f9
                    ex        de,hl                         ;[072a] eb
                    pop       ix                            ;[072b] dd e1
                    ret                                     ;[072d] c9

                    ld        ix,$0000                      ;[072e] dd 21 00 00
                    add       ix,sp                         ;[0732] dd 39
                    ld        hl,$ffb0                      ;[0734] 21 b0 ff
                    add       hl,sp                         ;[0737] 39
                    ld        sp,hl                         ;[0738] f9
                    ld        e,(ix+$02)                    ;[0739] dd 5e 02
                    ld        d,(ix+$03)                    ;[073c] dd 56 03
                    ld        l,(ix+$04)                    ;[073f] dd 6e 04
                    ld        h,(ix+$05)                    ;[0742] dd 66 05
                    xor       a                             ;[0745] af
                    ld        (ix-$01),a                    ;[0746] dd 77 ff
                    ld        (ix-$02),a                    ;[0749] dd 77 fe
                    dec       a                             ;[074c] 3d
                    ld        (ix-$05),a                    ;[074d] dd 77 fb
                    ld        (ix-$06),a                    ;[0750] dd 77 fa
                    ld        (ix-$07),a                    ;[0753] dd 77 f9
                    ld        (ix-$08),a                    ;[0756] dd 77 f8
                    ld        (ix-$09),$0a                  ;[0759] dd 36 f7 0a
                    xor       a                             ;[075d] af
                    ld        (ix-$03),a                    ;[075e] dd 77 fd
                    ld        (ix-$04),a                    ;[0761] dd 77 fc
                    ld        (ix-$0a),a                    ;[0764] dd 77 f6
                    ld        a,(hl)                        ;[0767] 7e
                    inc       hl                            ;[0768] 23
                    and       a                             ;[0769] a7
                    jr        nz,$0773                      ;[076a] 20 07
                    ld        hl,$004e                      ;[076c] 21 4e 00
                    add       hl,sp                         ;[076f] 39
                    ld        sp,hl                         ;[0770] f9
                    pop       hl                            ;[0771] e1
                    ret                                     ;[0772] c9

                    cp        $25                           ;[0773] fe 25
                    jr        z,$077c                       ;[0775] 28 05
                    call      $07bf                         ;[0777] cd bf 07
                    jr        $0759                         ;[077a] 18 dd
                    ld        a,(hl)                        ;[077c] 7e
                    inc       hl                            ;[077d] 23
                    cp        $25                           ;[077e] fe 25
                    jr        z,$0777                       ;[0780] 28 f5
                    call      $07e8                         ;[0782] cd e8 07
                    res       6,(ix-$04)                    ;[0785] dd cb fc b6
                    cp        $7a                           ;[0789] fe 7a
                    jr        z,$07a1                       ;[078b] 28 14
                    cp        $68                           ;[078d] fe 68
                    jr        nz,$0799                      ;[078f] 20 08
                    ld        a,(hl)                        ;[0791] 7e
                    inc       hl                            ;[0792] 23
                    cp        $68                           ;[0793] fe 68
                    jr        nz,$07a3                      ;[0795] 20 0c
                    jr        $07a1                         ;[0797] 18 08
                    cp        $6c                           ;[0799] fe 6c
                    jr        nz,$07a3                      ;[079b] 20 06
                    set       6,(ix-$04)                    ;[079d] dd cb fc f6
                    ld        a,(hl)                        ;[07a1] 7e
                    inc       hl                            ;[07a2] 23
                    push      hl                            ;[07a3] e5
                    ld        hl,$0e39                      ;[07a4] 21 39 0e
                    ld        c,a                           ;[07a7] 4f
                    ld        a,(hl)                        ;[07a8] 7e
                    and       a                             ;[07a9] a7
                    jr        z,$07bb                       ;[07aa] 28 0f
                    cp        c                             ;[07ac] b9
                    jr        nz,$07b6                      ;[07ad] 20 07
                    inc       hl                            ;[07af] 23
                    ld        c,(hl)                        ;[07b0] 4e
                    inc       hl                            ;[07b1] 23
                    ld        b,(hl)                        ;[07b2] 46
                    pop       hl                            ;[07b3] e1
                    push      bc                            ;[07b4] c5
                    ret                                     ;[07b5] c9

                    inc       hl                            ;[07b6] 23
                    inc       hl                            ;[07b7] 23
                    inc       hl                            ;[07b8] 23
                    jr        $07a8                         ;[07b9] 18 ed
                    pop       hl                            ;[07bb] e1
                    ld        a,c                           ;[07bc] 79
                    jr        $0777                         ;[07bd] 18 b8
                    push      hl                            ;[07bf] e5
                    push      de                            ;[07c0] d5
                    push      bc                            ;[07c1] c5
                    push      ix                            ;[07c2] dd e5
                    inc       (ix-$02)                      ;[07c4] dd 34 fe
                    jr        nz,$07cc                      ;[07c7] 20 03
                    inc       (ix-$01)                      ;[07c9] dd 34 ff
                    ld        c,a                           ;[07cc] 4f
                    ld        b,$00                         ;[07cd] 06 00
                    push      bc                            ;[07cf] c5
                    ld        c,(ix+$0a)                    ;[07d0] dd 4e 0a
                    ld        b,(ix+$0b)                    ;[07d3] dd 46 0b
                    push      bc                            ;[07d6] c5
                    ld        bc,$07e2                      ;[07d7] 01 e2 07
                    push      bc                            ;[07da] c5
                    ld        l,(ix+$08)                    ;[07db] dd 6e 08
                    ld        h,(ix+$09)                    ;[07de] dd 66 09
                    jp        (hl)                          ;[07e1] e9
                    pop       ix                            ;[07e2] dd e1
                    pop       bc                            ;[07e4] c1
                    pop       de                            ;[07e5] d1
                    pop       hl                            ;[07e6] e1
                    ret                                     ;[07e7] c9

                    ld        c,$00                         ;[07e8] 0e 00
                    push      hl                            ;[07ea] e5
                    ld        b,$05                         ;[07eb] 06 05
                    ld        hl,$07fc                      ;[07ed] 21 fc 07
                    cp        (hl)                          ;[07f0] be
                    inc       hl                            ;[07f1] 23
                    jr        nz,$0806                      ;[07f2] 20 12
                    ld        a,(hl)                        ;[07f4] 7e
                    or        c                             ;[07f5] b1
                    ld        c,a                           ;[07f6] 4f
                    pop       hl                            ;[07f7] e1
                    ld        a,(hl)                        ;[07f8] 7e
                    inc       hl                            ;[07f9] 23
                    jr        $07ea                         ;[07fa] 18 ee
                    dec       l                             ;[07fc] 2d
                    ld        bc,$022b                      ;[07fd] 01 2b 02
                    jr        nz,$080a                      ;[0800] 20 08
                    inc       hl                            ;[0802] 23
                    djnz      $0835                         ;[0803] 10 30
                    inc       b                             ;[0805] 04
                    inc       hl                            ;[0806] 23
                    djnz      $07f0                         ;[0807] 10 e7
                    pop       hl                            ;[0809] e1
                    ld        (ix-$04),c                    ;[080a] dd 71 fc
                    ld        (ix-$05),$00                  ;[080d] dd 36 fb 00
                    ld        (ix-$06),$00                  ;[0811] dd 36 fa 00
                    cp        $2a                           ;[0815] fe 2a
                    jr        nz,$0821                      ;[0817] 20 08
                    push      hl                            ;[0819] e5
                    call      $0adc                         ;[081a] cd dc 0a
                    ex        de,hl                         ;[081d] eb
                    ex        (sp),hl                       ;[081e] e3
                    jr        $082f                         ;[081f] 18 0e
                    cp        $30                           ;[0821] fe 30
                    jr        c,$0838                       ;[0823] 38 13
                    cp        $3a                           ;[0825] fe 3a
                    jr        nc,$0838                      ;[0827] 30 0f
                    push      de                            ;[0829] d5
                    dec       hl                            ;[082a] 2b
                    call      $0c1f                         ;[082b] cd 1f 0c
                    ex        de,hl                         ;[082e] eb
                    ld        (ix-$05),d                    ;[082f] dd 72 fb
                    ld        (ix-$06),e                    ;[0832] dd 73 fa
                    pop       de                            ;[0835] d1
                    ld        a,(hl)                        ;[0836] 7e
                    inc       hl                            ;[0837] 23
                    ld        (ix-$07),$ff                  ;[0838] dd 36 f9 ff
                    ld        (ix-$08),$ff                  ;[083c] dd 36 f8 ff
                    cp        $2e                           ;[0840] fe 2e
                    jr        nz,$0860                      ;[0842] 20 1c
                    ld        a,(hl)                        ;[0844] 7e
                    cp        $2a                           ;[0845] fe 2a
                    jr        nz,$0852                      ;[0847] 20 09
                    inc       hl                            ;[0849] 23
                    push      hl                            ;[084a] e5
                    call      $0adc                         ;[084b] cd dc 0a
                    ex        de,hl                         ;[084e] eb
                    ex        (sp),hl                       ;[084f] e3
                    jr        $0857                         ;[0850] 18 05
                    push      de                            ;[0852] d5
                    call      $0c1f                         ;[0853] cd 1f 0c
                    ex        de,hl                         ;[0856] eb
                    ld        (ix-$07),d                    ;[0857] dd 72 f9
                    ld        (ix-$08),e                    ;[085a] dd 73 f8
                    ld        a,(hl)                        ;[085d] 7e
                    inc       hl                            ;[085e] 23
                    pop       de                            ;[085f] d1
                    ret                                     ;[0860] c9

                    ld        (ix-$09),$02                  ;[0861] dd 36 f7 02
                    res       1,(ix-$04)                    ;[0865] dd cb fc 8e
                    ld        c,$00                         ;[0869] 0e 00
                    jp        $092b                         ;[086b] c3 2b 09
                    ld        (ix-$09),$10                  ;[086e] dd 36 f7 10
                    ld        (ix-$03),$e0                  ;[0872] dd 36 fd e0
                    res       1,(ix-$04)                    ;[0876] dd cb fc 8e
                    ld        c,$00                         ;[087a] 0e 00
                    jp        $092b                         ;[087c] c3 2b 09
                    push      hl                            ;[087f] e5
                    call      $0adc                         ;[0880] cd dc 0a
                    push      de                            ;[0883] d5
                    ld        a,l                           ;[0884] 7d
                    call      $0aca                         ;[0885] cd ca 0a
                    jp        $0ab8                         ;[0888] c3 b8 0a
                    ld        c,$01                         ;[088b] 0e 01
                    jp        $092b                         ;[088d] c3 2b 09
                    ld        c,(hl)                        ;[0890] 4e
                    inc       hl                            ;[0891] 23
                    push      hl                            ;[0892] e5
                    ld        hl,$0e5b                      ;[0893] 21 5b 0e
                    jp        $07a8                         ;[0896] c3 a8 07
                    ld        c,$00                         ;[0899] 0e 00
                    ld        (ix-$09),$02                  ;[089b] dd 36 f7 02
                    res       1,(ix-$04)                    ;[089f] dd cb fc 8e
                    jp        $09e6                         ;[08a3] c3 e6 09
                    ld        c,$00                         ;[08a6] 0e 00
                    ld        (ix-$09),$10                  ;[08a8] dd 36 f7 10
                    ld        (ix-$03),$e0                  ;[08ac] dd 36 fd e0
                    res       1,(ix-$04)                    ;[08b0] dd cb fc 8e
                    jp        $09e6                         ;[08b4] c3 e6 09
                    ld        c,$01                         ;[08b7] 0e 01
                    jp        $09e6                         ;[08b9] c3 e6 09
                    ld        c,$00                         ;[08bc] 0e 00
                    ld        (ix-$09),$08                  ;[08be] dd 36 f7 08
                    jp        $09e6                         ;[08c2] c3 e6 09
                    ld        c,$00                         ;[08c5] 0e 00
                    jp        $09e6                         ;[08c7] c3 e6 09
                    ld        c,$00                         ;[08ca] 0e 00
                    ld        (ix-$09),$10                  ;[08cc] dd 36 f7 10
                    res       1,(ix-$04)                    ;[08d0] dd cb fc 8e
                    jp        $09e6                         ;[08d4] c3 e6 09
                    push      hl                            ;[08d7] e5
                    call      $0adc                         ;[08d8] cd dc 0a
                    ld        a,(ix-$02)                    ;[08db] dd 7e fe
                    ld        (hl),a                        ;[08de] 77
                    ld        a,(ix-$01)                    ;[08df] dd 7e ff
                    inc       hl                            ;[08e2] 23
                    ld        (hl),a                        ;[08e3] 77
                    pop       hl                            ;[08e4] e1
                    jp        $0759                         ;[08e5] c3 59 07
                    ld        (ix-$09),$08                  ;[08e8] dd 36 f7 08
                    ld        c,$00                         ;[08ec] 0e 00
                    jp        $092b                         ;[08ee] c3 2b 09
                    push      hl                            ;[08f1] e5
                    call      $0adc                         ;[08f2] cd dc 0a
                    push      de                            ;[08f5] d5
                    ld        a,h                           ;[08f6] 7c
                    or        l                             ;[08f7] b5
                    jr        nz,$08fd                      ;[08f8] 20 03
                    ld        hl,$0e6e                      ;[08fa] 21 6e 0e
                    push      hl                            ;[08fd] e5
                    call      $0c72                         ;[08fe] cd 72 0c
                    ex        de,hl                         ;[0901] eb
                    ld        l,(ix-$08)                    ;[0902] dd 6e f8
                    ld        h,(ix-$07)                    ;[0905] dd 66 f9
                    push      hl                            ;[0908] e5
                    call      $020c                         ;[0909] cd 0c 02
                    pop       hl                            ;[090c] e1
                    jr        nc,$0910                      ;[090d] 30 01
                    ex        de,hl                         ;[090f] eb
                    pop       bc                            ;[0910] c1
                    call      $0a6e                         ;[0911] cd 6e 0a
                    pop       de                            ;[0914] d1
                    pop       hl                            ;[0915] e1
                    jp        $0759                         ;[0916] c3 59 07
                    ld        c,$00                         ;[0919] 0e 00
                    jp        $092b                         ;[091b] c3 2b 09
                    ld        (ix-$09),$10                  ;[091e] dd 36 f7 10
                    res       1,(ix-$04)                    ;[0922] dd cb fc 8e
                    ld        c,$00                         ;[0926] 0e 00
                    jp        $092b                         ;[0928] c3 2b 09
                    push      hl                            ;[092b] e5
                    bit       6,(ix-$04)                    ;[092c] dd cb fc 76
                    jr        z,$0959                       ;[0930] 28 27
                    bit       0,(ix+$06)                    ;[0932] dd cb 06 46
                    jr        nz,$0949                      ;[0936] 20 11
                    ex        de,hl                         ;[0938] eb
                    ld        e,(hl)                        ;[0939] 5e
                    inc       hl                            ;[093a] 23
                    ld        d,(hl)                        ;[093b] 56
                    inc       hl                            ;[093c] 23
                    ld        a,(hl)                        ;[093d] 7e
                    inc       hl                            ;[093e] 23
                    ld        b,(hl)                        ;[093f] 46
                    inc       hl                            ;[0940] 23
                    push      hl                            ;[0941] e5
                    ld        h,b                           ;[0942] 60
                    ld        l,a                           ;[0943] 6f
                    ex        de,hl                         ;[0944] eb
                    ld        a,c                           ;[0945] 79
                    jp        $0967                         ;[0946] c3 67 09
                    ex        de,hl                         ;[0949] eb
                    ld        e,(hl)                        ;[094a] 5e
                    inc       hl                            ;[094b] 23
                    ld        d,(hl)                        ;[094c] 56
                    dec       hl                            ;[094d] 2b
                    dec       hl                            ;[094e] 2b
                    ld        b,(hl)                        ;[094f] 46
                    dec       hl                            ;[0950] 2b
                    ld        a,(hl)                        ;[0951] 7e
                    dec       hl                            ;[0952] 2b
                    dec       hl                            ;[0953] 2b
                    push      hl                            ;[0954] e5
                    ld        h,b                           ;[0955] 60
                    ld        l,a                           ;[0956] 6f
                    jr        $0945                         ;[0957] 18 ec
                    call      $0adc                         ;[0959] cd dc 0a
                    push      de                            ;[095c] d5
                    ld        de,$0000                      ;[095d] 11 00 00
                    ld        a,c                           ;[0960] 79
                    and       a                             ;[0961] a7
                    call      nz,$0187                      ;[0962] c4 87 01
                    jr        $0945                         ;[0965] 18 de
                    ld        b,a                           ;[0967] 47
                    ld        a,d                           ;[0968] 7a
                    rlca                                    ;[0969] 07
                    and       $01                           ;[096a] e6 01
                    and       b                             ;[096c] a0
                    jr        z,$0979                       ;[096d] 28 0a
                    call      $00bb                         ;[096f] cd bb 00
                    ld        a,$2d                         ;[0972] 3e 2d
                    call      $0aca                         ;[0974] cd ca 0a
                    jr        $09a9                         ;[0977] 18 30
                    ld        a,$20                         ;[0979] 3e 20
                    bit       3,(ix-$04)                    ;[097b] dd cb fc 5e
                    jr        nz,$0974                      ;[097f] 20 f3
                    ld        a,$2b                         ;[0981] 3e 2b
                    bit       1,(ix-$04)                    ;[0983] dd cb fc 4e
                    jr        nz,$0974                      ;[0987] 20 eb
                    bit       4,(ix-$04)                    ;[0989] dd cb fc 66
                    jr        z,$09a9                       ;[098d] 28 1a
                    ld        a,(ix-$09)                    ;[098f] dd 7e f7
                    cp        $0a                           ;[0992] fe 0a
                    jr        z,$09a9                       ;[0994] 28 13
                    push      af                            ;[0996] f5
                    ld        a,$30                         ;[0997] 3e 30
                    call      $0aca                         ;[0999] cd ca 0a
                    pop       af                            ;[099c] f1
                    cp        $10                           ;[099d] fe 10
                    jr        nz,$09a9                      ;[099f] 20 08
                    ld        a,$78                         ;[09a1] 3e 78
                    add       (ix-$03)                      ;[09a3] dd 86 fd
                    call      $0aca                         ;[09a6] cd ca 0a
                    xor       a                             ;[09a9] af
                    push      af                            ;[09aa] f5
                    push      de                            ;[09ab] d5
                    push      hl                            ;[09ac] e5
                    ld        l,(ix-$09)                    ;[09ad] dd 6e f7
                    ld        h,$00                         ;[09b0] 26 00
                    ld        d,h                           ;[09b2] 54
                    ld        e,h                           ;[09b3] 5c
                    call      $0179                         ;[09b4] cd 79 01
                    exx                                     ;[09b7] d9
                    ld        a,l                           ;[09b8] 7d
                    cp        $ff                           ;[09b9] fe ff
                    push      af                            ;[09bb] f5
                    exx                                     ;[09bc] d9
                    ld        a,h                           ;[09bd] 7c
                    or        d                             ;[09be] b2
                    or        e                             ;[09bf] b3
                    or        l                             ;[09c0] b5
                    jr        nz,$09ab                      ;[09c1] 20 e8
                    pop       af                            ;[09c3] f1
                    jp        z,$0ab8                       ;[09c4] ca b8 0a
                    add       $30                           ;[09c7] c6 30
                    cp        $3a                           ;[09c9] fe 3a
                    jr        c,$09d2                       ;[09cb] 38 05
                    add       $27                           ;[09cd] c6 27
                    add       (ix-$03)                      ;[09cf] dd 86 fd
                    call      $0aca                         ;[09d2] cd ca 0a
                    jr        $09c3                         ;[09d5] 18 ec
                    dec       de                            ;[09d7] 1b
                    dec       de                            ;[09d8] 1b
                    dec       de                            ;[09d9] 1b
                    dec       de                            ;[09da] 1b
                    dec       de                            ;[09db] 1b
                    dec       de                            ;[09dc] 1b
                    dec       de                            ;[09dd] 1b
                    dec       de                            ;[09de] 1b
                    push      de                            ;[09df] d5
                    inc       de                            ;[09e0] 13
                    inc       de                            ;[09e1] 13
                    ld        l,e                           ;[09e2] 6b
                    ld        h,d                           ;[09e3] 62
                    jr        $09f9                         ;[09e4] 18 13
                    push      hl                            ;[09e6] e5
                    bit       0,(ix+$06)                    ;[09e7] dd cb 06 46
                    jr        nz,$09d7                      ;[09eb] 20 ea
                    ld        l,e                           ;[09ed] 6b
                    ld        h,d                           ;[09ee] 62
                    inc       hl                            ;[09ef] 23
                    inc       hl                            ;[09f0] 23
                    inc       hl                            ;[09f1] 23
                    inc       hl                            ;[09f2] 23
                    inc       hl                            ;[09f3] 23
                    inc       hl                            ;[09f4] 23
                    inc       hl                            ;[09f5] 23
                    inc       hl                            ;[09f6] 23
                    push      hl                            ;[09f7] e5
                    ex        de,hl                         ;[09f8] eb
                    push      hl                            ;[09f9] e5
                    ld        a,c                           ;[09fa] 79
                    and       a                             ;[09fb] a7
                    jr        z,$0a0c                       ;[09fc] 28 0e
                    bit       7,(hl)                        ;[09fe] cb 7e
                    jr        z,$0a0c                       ;[0a00] 28 0a
                    call      $00e0                         ;[0a02] cd e0 00
                    ld        a,$2d                         ;[0a05] 3e 2d
                    call      $0aca                         ;[0a07] cd ca 0a
                    jr        $0a3c                         ;[0a0a] 18 30
                    ld        a,$20                         ;[0a0c] 3e 20
                    bit       3,(ix-$04)                    ;[0a0e] dd cb fc 5e
                    jr        nz,$0a07                      ;[0a12] 20 f3
                    ld        a,$2b                         ;[0a14] 3e 2b
                    bit       1,(ix-$04)                    ;[0a16] dd cb fc 4e
                    jr        nz,$0a07                      ;[0a1a] 20 eb
                    bit       4,(ix-$04)                    ;[0a1c] dd cb fc 66
                    jr        z,$0a3c                       ;[0a20] 28 1a
                    ld        a,(ix-$09)                    ;[0a22] dd 7e f7
                    cp        $0a                           ;[0a25] fe 0a
                    jr        z,$0a3c                       ;[0a27] 28 13
                    push      af                            ;[0a29] f5
                    ld        a,$30                         ;[0a2a] 3e 30
                    call      $0aca                         ;[0a2c] cd ca 0a
                    pop       af                            ;[0a2f] f1
                    cp        $10                           ;[0a30] fe 10
                    jr        nz,$0a3c                      ;[0a32] 20 08
                    ld        a,$78                         ;[0a34] 3e 78
                    add       (ix-$03)                      ;[0a36] dd 86 fd
                    call      $0aca                         ;[0a39] cd ca 0a
                    call      $0a66                         ;[0a3c] cd 66 0a
                    ld        c,(ix-$0a)                    ;[0a3f] dd 4e f6
                    ld        b,$00                         ;[0a42] 06 00
                    add       hl,bc                         ;[0a44] 09
                    ld        e,(ix-$09)                    ;[0a45] dd 5e f7
                    ld        d,$00                         ;[0a48] 16 00
                    pop       bc                            ;[0a4a] c1
                    push      ix                            ;[0a4b] dd e5
                    push      de                            ;[0a4d] d5
                    push      hl                            ;[0a4e] e5
                    call      $00cd                         ;[0a4f] cd cd 00
                    pop       ix                            ;[0a52] dd e1
                    pop       bc                            ;[0a54] c1
                    call      $0c4a                         ;[0a55] cd 4a 0c
                    pop       ix                            ;[0a58] dd e1
                    call      $0a66                         ;[0a5a] cd 66 0a
                    call      $0c72                         ;[0a5d] cd 72 0c
                    ld        (ix-$0a),l                    ;[0a60] dd 75 f6
                    jp        $0ab8                         ;[0a63] c3 b8 0a
                    push      ix                            ;[0a66] dd e5
                    pop       hl                            ;[0a68] e1
                    ld        bc,$ffb0                      ;[0a69] 01 b0 ff
                    add       hl,bc                         ;[0a6c] 09
                    ret                                     ;[0a6d] c9

                    ld        l,(ix-$06)                    ;[0a6e] dd 6e fa
                    ld        h,(ix-$05)                    ;[0a71] dd 66 fb
                    ld        a,h                           ;[0a74] 7c
                    or        l                             ;[0a75] b5
                    jr        z,$0a89                       ;[0a76] 28 11
                    push      hl                            ;[0a78] e5
                    push      bc                            ;[0a79] c5
                    call      $0198                         ;[0a7a] cd 98 01
                    pop       bc                            ;[0a7d] c1
                    pop       hl                            ;[0a7e] e1
                    jr        nc,$0a86                      ;[0a7f] 30 05
                    ld        hl,$0000                      ;[0a81] 21 00 00
                    jr        $0a89                         ;[0a84] 18 03
                    and       a                             ;[0a86] a7
                    sbc       hl,de                         ;[0a87] ed 52
                    bit       0,(ix-$04)                    ;[0a89] dd cb fc 46
                    push      bc                            ;[0a8d] c5
                    call      z,$0aac                       ;[0a8e] cc ac 0a
                    pop       bc                            ;[0a91] c1
                    ld        a,d                           ;[0a92] 7a
                    or        e                             ;[0a93] b3
                    jr        z,$0a9e                       ;[0a94] 28 08
                    ld        a,(bc)                        ;[0a96] 0a
                    call      $07bf                         ;[0a97] cd bf 07
                    inc       bc                            ;[0a9a] 03
                    dec       de                            ;[0a9b] 1b
                    jr        $0a92                         ;[0a9c] 18 f4
                    ld        c,$20                         ;[0a9e] 0e 20
                    ld        a,h                           ;[0aa0] 7c
                    or        l                             ;[0aa1] b5
                    ret       z                             ;[0aa2] c8
                    push      bc                            ;[0aa3] c5
                    ld        a,c                           ;[0aa4] 79
                    call      $07bf                         ;[0aa5] cd bf 07
                    pop       bc                            ;[0aa8] c1
                    dec       hl                            ;[0aa9] 2b
                    jr        $0aac                         ;[0aaa] 18 00
                    ld        c,$20                         ;[0aac] 0e 20
                    bit       2,(ix-$04)                    ;[0aae] dd cb fc 56
                    jr        z,$0aa0                       ;[0ab2] 28 ec
                    ld        c,$30                         ;[0ab4] 0e 30
                    jr        $0aa0                         ;[0ab6] 18 e8
                    ld        d,$00                         ;[0ab8] 16 00
                    ld        e,(ix-$0a)                    ;[0aba] dd 5e f6
                    call      $0a66                         ;[0abd] cd 66 0a
                    ld        c,l                           ;[0ac0] 4d
                    ld        b,h                           ;[0ac1] 44
                    call      $0a6e                         ;[0ac2] cd 6e 0a
                    pop       de                            ;[0ac5] d1
                    pop       hl                            ;[0ac6] e1
                    jp        $0759                         ;[0ac7] c3 59 07
                    push      hl                            ;[0aca] e5
                    push      bc                            ;[0acb] c5
                    call      $0a66                         ;[0acc] cd 66 0a
                    ld        c,(ix-$0a)                    ;[0acf] dd 4e f6
                    ld        b,$00                         ;[0ad2] 06 00
                    add       hl,bc                         ;[0ad4] 09
                    inc       (ix-$0a)                      ;[0ad5] dd 34 f6
                    ld        (hl),a                        ;[0ad8] 77
                    pop       bc                            ;[0ad9] c1
                    pop       hl                            ;[0ada] e1
                    ret                                     ;[0adb] c9

                    ex        de,hl                         ;[0adc] eb
                    ld        e,(hl)                        ;[0add] 5e
                    inc       hl                            ;[0ade] 23
                    ld        d,(hl)                        ;[0adf] 56
                    ex        de,hl                         ;[0ae0] eb
                    bit       0,(ix+$06)                    ;[0ae1] dd cb 06 46
                    jr        nz,$0ae9                      ;[0ae5] 20 02
                    inc       de                            ;[0ae7] 13
                    ret                                     ;[0ae8] c9

                    dec       de                            ;[0ae9] 1b
                    dec       de                            ;[0aea] 1b
                    dec       de                            ;[0aeb] 1b
                    ret                                     ;[0aec] c9

                    pop       bc                            ;[0aed] c1
                    pop       hl                            ;[0aee] e1
                    pop       de                            ;[0aef] d1
                    push      bc                            ;[0af0] c5
                    push      ix                            ;[0af1] dd e5
                    push      hl                            ;[0af3] e5
                    pop       ix                            ;[0af4] dd e1
                    ld        c,(ix+$02)                    ;[0af6] dd 4e 02
                    ld        b,(ix+$03)                    ;[0af9] dd 46 03
                    ld        a,c                           ;[0afc] 79
                    or        b                             ;[0afd] b0
                    jr        z,$0b1b                       ;[0afe] 28 1b
                    dec       bc                            ;[0b00] 0b
                    ld        (ix+$02),c                    ;[0b01] dd 71 02
                    ld        (ix+$03),b                    ;[0b04] dd 70 03
                    ld        l,(ix+$00)                    ;[0b07] dd 6e 00
                    ld        h,(ix+$01)                    ;[0b0a] dd 66 01
                    ld        a,b                           ;[0b0d] 78
                    or        c                             ;[0b0e] b1
                    jr        z,$0b13                       ;[0b0f] 28 02
                    ld        (hl),e                        ;[0b11] 73
                    inc       hl                            ;[0b12] 23
                    ld        (hl),$00                      ;[0b13] 36 00
                    ld        (ix+$00),l                    ;[0b15] dd 75 00
                    ld        (ix+$01),h                    ;[0b18] dd 74 01
                    pop       ix                            ;[0b1b] dd e1
                    ret                                     ;[0b1d] c9

                    ld        hl,($4c67)                    ;[0b1e] 2a 67 4c
                    ld        d,h                           ;[0b21] 54
                    ld        e,l                           ;[0b22] 5d
                    inc       de                            ;[0b23] 13
                    ld        bc,$0400                      ;[0b24] 01 00 04
                    ld        (hl),$c0                      ;[0b27] 36 c0
                    ldir                                    ;[0b29] ed b0
                    ld        b,$04                         ;[0b2b] 06 04
                    ld        (hl),$14                      ;[0b2d] 36 14
                    ldir                                    ;[0b2f] ed b0
                    ret                                     ;[0b31] c9

                    ld        a,c                           ;[0b32] 79
                    ld        hl,$401d                      ;[0b33] 21 1d 40
                    cp        $22                           ;[0b36] fe 22
                    jr        z,$0b5f                       ;[0b38] 28 25
                    ld        l,$3d                         ;[0b3a] 2e 3d
                    cp        $23                           ;[0b3c] fe 23
                    jr        z,$0b5f                       ;[0b3e] 28 1f
                    ld        hl,$43dd                      ;[0b40] 21 dd 43
                    xor       a                             ;[0b43] af
                    cp        c                             ;[0b44] b9
                    jr        z,$0b5f                       ;[0b45] 28 18
                    ld        l,$fd                         ;[0b47] 2e fd
                    dec       c                             ;[0b49] 0d
                    jr        z,$0b5f                       ;[0b4a] 28 13
                    dec       c                             ;[0b4c] 0d
                    ld        hl,$43a0                      ;[0b4d] 21 a0 43
                    ld        d,$00                         ;[0b50] 16 00
                    ld        e,c                           ;[0b52] 59
                    add       hl,de                         ;[0b53] 19
                    inc       b                             ;[0b54] 04
                    ld        de,$0020                      ;[0b55] 11 20 00
                    sbc       hl,de                         ;[0b58] ed 52
                    djnz      $0b58                         ;[0b5a] 10 fc
                    add       hl,de                         ;[0b5c] 19
                    jr        $0b66                         ;[0b5d] 18 07
                    xor       a                             ;[0b5f] af
                    add       b                             ;[0b60] 80
                    jr        z,$0b66                       ;[0b61] 28 03
                    dec       hl                            ;[0b63] 2b
                    djnz      $0b63                         ;[0b64] 10 fd
                    ret                                     ;[0b66] c9

                    cp        $20                           ;[0b67] fe 20
                    ret       z                             ;[0b69] c8
                    cp        $09                           ;[0b6a] fe 09
                    ret       c                             ;[0b6c] d8
                    cp        $0e                           ;[0b6d] fe 0e
                    ccf                                     ;[0b6f] 3f
                    ret                                     ;[0b70] c9

                    exx                                     ;[0b71] d9
                    ld        a,d                           ;[0b72] 7a
                    or        e                             ;[0b73] b3
                    or        h                             ;[0b74] b4
                    or        l                             ;[0b75] b5
                    jr        z,$0bba                       ;[0b76] 28 42
                    xor       a                             ;[0b78] af
                    push      hl                            ;[0b79] e5
                    exx                                     ;[0b7a] d9
                    ld        b,h                           ;[0b7b] 44
                    ld        c,l                           ;[0b7c] 4d
                    pop       hl                            ;[0b7d] e1
                    push      de                            ;[0b7e] d5
                    ex        de,hl                         ;[0b7f] eb
                    ld        l,a                           ;[0b80] 6f
                    ld        h,a                           ;[0b81] 67
                    exx                                     ;[0b82] d9
                    pop       bc                            ;[0b83] c1
                    ld        l,a                           ;[0b84] 6f
                    ld        h,a                           ;[0b85] 67
                    ld        a,b                           ;[0b86] 78
                    ld        b,$20                         ;[0b87] 06 20
                    exx                                     ;[0b89] d9
                    rl        c                             ;[0b8a] cb 11
                    rl        b                             ;[0b8c] cb 10
                    exx                                     ;[0b8e] d9
                    rl        c                             ;[0b8f] cb 11
                    rla                                     ;[0b91] 17
                    exx                                     ;[0b92] d9
                    adc       hl,hl                         ;[0b93] ed 6a
                    exx                                     ;[0b95] d9
                    adc       hl,hl                         ;[0b96] ed 6a
                    exx                                     ;[0b98] d9
                    sbc       hl,de                         ;[0b99] ed 52
                    exx                                     ;[0b9b] d9
                    sbc       hl,de                         ;[0b9c] ed 52
                    jr        nc,$0ba5                      ;[0b9e] 30 05
                    exx                                     ;[0ba0] d9
                    add       hl,de                         ;[0ba1] 19
                    exx                                     ;[0ba2] d9
                    adc       hl,de                         ;[0ba3] ed 5a
                    ccf                                     ;[0ba5] 3f
                    djnz      $0b89                         ;[0ba6] 10 e1
                    exx                                     ;[0ba8] d9
                    rl        c                             ;[0ba9] cb 11
                    rl        b                             ;[0bab] cb 10
                    exx                                     ;[0bad] d9
                    rl        c                             ;[0bae] cb 11
                    rla                                     ;[0bb0] 17
                    push      hl                            ;[0bb1] e5
                    exx                                     ;[0bb2] d9
                    pop       de                            ;[0bb3] d1
                    push      bc                            ;[0bb4] c5
                    exx                                     ;[0bb5] d9
                    pop       hl                            ;[0bb6] e1
                    ld        e,c                           ;[0bb7] 59
                    ld        d,a                           ;[0bb8] 57
                    ret                                     ;[0bb9] c9

                    dec       de                            ;[0bba] 1b
                    jp        $0bfd                         ;[0bbb] c3 fd 0b
                    ld        a,c                           ;[0bbe] 79
                    or        a                             ;[0bbf] b7
                    jr        z,$0bde                       ;[0bc0] 28 1c
                    xor       a                             ;[0bc2] af
                    ld        b,$40                         ;[0bc3] 06 40
                    add       hl,hl                         ;[0bc5] 29
                    rl        e                             ;[0bc6] cb 13
                    rl        d                             ;[0bc8] cb 12
                    exx                                     ;[0bca] d9
                    adc       hl,hl                         ;[0bcb] ed 6a
                    rl        e                             ;[0bcd] cb 13
                    rl        d                             ;[0bcf] cb 12
                    exx                                     ;[0bd1] d9
                    rla                                     ;[0bd2] 17
                    jr        c,$0bd8                       ;[0bd3] 38 03
                    cp        c                             ;[0bd5] b9
                    jr        c,$0bda                       ;[0bd6] 38 02
                    sub       c                             ;[0bd8] 91
                    inc       l                             ;[0bd9] 2c
                    djnz      $0bc5                         ;[0bda] 10 e9
                    or        a                             ;[0bdc] b7
                    ret                                     ;[0bdd] c9

                    call      $0c10                         ;[0bde] cd 10 0c
                    jp        $0bfd                         ;[0be1] c3 fd 0b
                    pop       hl                            ;[0be4] e1
                    pop       hl                            ;[0be5] e1
                    pop       hl                            ;[0be6] e1
                    ld        l,$ff                         ;[0be7] 2e ff
                    ld        h,$00                         ;[0be9] 26 00
                    ld        ($4c01),hl                    ;[0beb] 22 01 4c
                    jp        $0bf5                         ;[0bee] c3 f5 0b
                    pop       hl                            ;[0bf1] e1
                    pop       hl                            ;[0bf2] e1
                    pop       hl                            ;[0bf3] e1
                    pop       hl                            ;[0bf4] e1
                    ld        hl,$0000                      ;[0bf5] 21 00 00
                    scf                                     ;[0bf8] 37
                    ret                                     ;[0bf9] c9

                    pop       hl                            ;[0bfa] e1
                    pop       hl                            ;[0bfb] e1
                    pop       hl                            ;[0bfc] e1
                    ld        l,$ff                         ;[0bfd] 2e ff
                    ld        h,$00                         ;[0bff] 26 00
                    ld        ($4c01),hl                    ;[0c01] 22 01 4c
                    jp        $0c0a                         ;[0c04] c3 0a 0c
                    pop       hl                            ;[0c07] e1
                    pop       hl                            ;[0c08] e1
                    pop       hl                            ;[0c09] e1
                    ld        hl,$ffff                      ;[0c0a] 21 ff ff
                    scf                                     ;[0c0d] 37
                    ret                                     ;[0c0e] c9

                    pop       hl                            ;[0c0f] e1
                    exx                                     ;[0c10] d9
                    call      $0c19                         ;[0c11] cd 19 0c
                    exx                                     ;[0c14] d9
                    jp        $0c19                         ;[0c15] c3 19 0c
                    pop       hl                            ;[0c18] e1
                    ld        de,$ffff                      ;[0c19] 11 ff ff
                    jp        $0c0a                         ;[0c1c] c3 0a 0c
                    call      $0127                         ;[0c1f] cd 27 01
                    call      $011b                         ;[0c22] cd 1b 01
                    jr        nc,$0c2f                      ;[0c25] 30 08
                    call      $0c2f                         ;[0c27] cd 2f 0c
                    jp        nc,$016e                      ;[0c2a] d2 6e 01
                    inc       hl                            ;[0c2d] 23
                    ret                                     ;[0c2e] c9

                    ex        de,hl                         ;[0c2f] eb
                    call      $0146                         ;[0c30] cd 46 01
                    jr        c,$0c39                       ;[0c33] 38 04
                    bit       7,h                           ;[0c35] cb 7c
                    ret       z                             ;[0c37] c8
                    scf                                     ;[0c38] 37
                    ld        hl,$7fff                      ;[0c39] 21 ff 7f
                    ret                                     ;[0c3c] c9

                    ld        a,ixh                         ;[0c3d] dd 7c
                    or        ixl                           ;[0c3f] dd b5
                    jp        z,$0bf5                       ;[0c41] ca f5 0b
                    call      $0139                         ;[0c44] cd 39 01
                    jp        nc,$0be7                      ;[0c47] d2 e7 0b
                    xor       a                             ;[0c4a] af
                    push      af                            ;[0c4b] f5
                    push      bc                            ;[0c4c] c5
                    call      $0bc2                         ;[0c4d] cd c2 0b
                    pop       bc                            ;[0c50] c1
                    call      $012f                         ;[0c51] cd 2f 01
                    scf                                     ;[0c54] 37
                    push      af                            ;[0c55] f5
                    call      $0110                         ;[0c56] cd 10 01
                    jr        nz,$0c4c                      ;[0c59] 20 f1
                    push      ix                            ;[0c5b] dd e5
                    pop       hl                            ;[0c5d] e1
                    pop       af                            ;[0c5e] f1
                    ld        (hl),a                        ;[0c5f] 77
                    inc       hl                            ;[0c60] 23
                    jr        c,$0c5e                       ;[0c61] 38 fb
                    dec       hl                            ;[0c63] 2b
                    ret                                     ;[0c64] c9

                    ld        a,b                           ;[0c65] 78
                    or        c                             ;[0c66] b1
                    jr        z,$0c6f                       ;[0c67] 28 06
                    push      de                            ;[0c69] d5
                    ldir                                    ;[0c6a] ed b0
                    pop       hl                            ;[0c6c] e1
                    or        a                             ;[0c6d] b7
                    ret                                     ;[0c6e] c9

                    ld        h,d                           ;[0c6f] 62
                    ld        l,e                           ;[0c70] 6b
                    ret                                     ;[0c71] c9

                    xor       a                             ;[0c72] af
                    ld        c,a                           ;[0c73] 4f
                    ld        b,a                           ;[0c74] 47
                    cpir                                    ;[0c75] ed b1
                    ld        hl,$ffff                      ;[0c77] 21 ff ff
                    sbc       hl,bc                         ;[0c7a] ed 42
                    ret                                     ;[0c7c] c9

                    ld        b,d                           ;[0c7d] 42
                    ld        l,c                           ;[0c7e] 69
                    ld        h,l                           ;[0c7f] 65
                    ld        l,(hl)                        ;[0c80] 6e
                    halt                                    ;[0c81] 76
                    ld        h,l                           ;[0c82] 65
                    ld        l,(hl)                        ;[0c83] 6e
                    ld        (hl),l                        ;[0c84] 75
                    ld        h,l                           ;[0c85] 65
                    nop                                     ;[0c86] 00
                    dec       c                             ;[0c87] 0d
                    ld        c,h                           ;[0c88] 4c
                    ld        h,l                           ;[0c89] 65
                    ld        h,e                           ;[0c8a] 63
                    ld        (hl),h                        ;[0c8b] 74
                    ld        (hl),l                        ;[0c8c] 75
                    ld        (hl),d                        ;[0c8d] 72
                    ld        h,l                           ;[0c8e] 65
                    jr        nz,$0cf4                      ;[0c8f] 20 63
                    ld        l,a                           ;[0c91] 6f
                    ld        l,l                           ;[0c92] 6d
                    ld        (hl),b                        ;[0c93] 70
                    ld        (hl),h                        ;[0c94] 74
                    ld        h,l                           ;[0c95] 65
                    ld        (hl),l                        ;[0c96] 75
                    ld        (hl),d                        ;[0c97] 72
                    jr        nz,$0cf0                      ;[0c98] 20 56
                    ld        b,d                           ;[0c9a] 42
                    ld        c,h                           ;[0c9b] 4c
                    ld        b,c                           ;[0c9c] 41
                    ld        c,(hl)                        ;[0c9d] 4e
                    ld        c,e                           ;[0c9e] 4b
                    ld        a,(bc)                        ;[0c9f] 0a
                    nop                                     ;[0ca0] 00
                    nop                                     ;[0ca1] 00
                    nop                                     ;[0ca2] 00
                    nop                                     ;[0ca3] 00
                    nop                                     ;[0ca4] 00
                    nop                                     ;[0ca5] 00
                    nop                                     ;[0ca6] 00
                    nop                                     ;[0ca7] 00
                    nop                                     ;[0ca8] 00
                    nop                                     ;[0ca9] 00
                    nop                                     ;[0caa] 00
                    nop                                     ;[0cab] 00
                    nop                                     ;[0cac] 00
                    nop                                     ;[0cad] 00
                    nop                                     ;[0cae] 00
                    dec       c                             ;[0caf] 0d
                    ld        b,h                           ;[0cb0] 44
                    ld        h,l                           ;[0cb1] 65
                    ld        l,l                           ;[0cb2] 6d
                    ld        h,c                           ;[0cb3] 61
                    ld        (hl),d                        ;[0cb4] 72
                    ld        (hl),d                        ;[0cb5] 72
                    ld        h,c                           ;[0cb6] 61
                    ld        h,a                           ;[0cb7] 67
                    ld        h,l                           ;[0cb8] 65
                    jr        nz,$0d1f                      ;[0cb9] 20 64
                    ld        (hl),l                        ;[0cbb] 75
                    jr        nz,$0d32                      ;[0cbc] 20 74
                    ld        h,l                           ;[0cbe] 65
                    ld        (hl),e                        ;[0cbf] 73
                    ld        (hl),h                        ;[0cc0] 74
                    jr        nz,$0d27                      ;[0cc1] 20 64
                    ld        h,l                           ;[0cc3] 65
                    jr        nz,$0d32                      ;[0cc4] 20 6c
                    daa                                     ;[0cc6] 27
                    ld        h,c                           ;[0cc7] 61
                    ld        h,(hl)                        ;[0cc8] 66
                    ld        h,(hl)                        ;[0cc9] 66
                    ld        l,c                           ;[0cca] 69
                    ld        h,e                           ;[0ccb] 63
                    ld        l,b                           ;[0ccc] 68
                    ld        h,c                           ;[0ccd] 61
                    ld        h,a                           ;[0cce] 67
                    ld        h,l                           ;[0ccf] 65
                    ld        a,(bc)                        ;[0cd0] 0a
                    nop                                     ;[0cd1] 00
                    nop                                     ;[0cd2] 00
                    nop                                     ;[0cd3] 00
                    nop                                     ;[0cd4] 00
                    nop                                     ;[0cd5] 00
                    nop                                     ;[0cd6] 00
                    dec       c                             ;[0cd7] 0d
                    ld        b,h                           ;[0cd8] 44
                    ld        h,l                           ;[0cd9] 65
                    ld        l,l                           ;[0cda] 6d
                    ld        h,c                           ;[0cdb] 61
                    ld        (hl),d                        ;[0cdc] 72
                    ld        (hl),d                        ;[0cdd] 72
                    ld        h,c                           ;[0cde] 61
                    ld        h,a                           ;[0cdf] 67
                    ld        h,l                           ;[0ce0] 65
                    jr        nz,$0d47                      ;[0ce1] 20 64
                    ld        (hl),l                        ;[0ce3] 75
                    jr        nz,$0d5a                      ;[0ce4] 20 74
                    ld        h,l                           ;[0ce6] 65
                    ld        (hl),e                        ;[0ce7] 73
                    ld        (hl),h                        ;[0ce8] 74
                    jr        nz,$0d4f                      ;[0ce9] 20 64
                    ld        (hl),l                        ;[0ceb] 75
                    jr        nz,$0d61                      ;[0cec] 20 73
                    ld        l,a                           ;[0cee] 6f
                    ld        l,(hl)                        ;[0cef] 6e
                    ld        a,(bc)                        ;[0cf0] 0a
                    nop                                     ;[0cf1] 00
                    nop                                     ;[0cf2] 00
                    nop                                     ;[0cf3] 00
                    nop                                     ;[0cf4] 00
                    nop                                     ;[0cf5] 00
                    nop                                     ;[0cf6] 00
                    nop                                     ;[0cf7] 00
                    nop                                     ;[0cf8] 00
                    nop                                     ;[0cf9] 00
                    nop                                     ;[0cfa] 00
                    nop                                     ;[0cfb] 00
                    nop                                     ;[0cfc] 00
                    nop                                     ;[0cfd] 00
                    nop                                     ;[0cfe] 00
                    dec       c                             ;[0cff] 0d
                    ld        b,h                           ;[0d00] 44
                    ld        h,l                           ;[0d01] 65
                    ld        l,l                           ;[0d02] 6d
                    ld        h,c                           ;[0d03] 61
                    ld        (hl),d                        ;[0d04] 72
                    ld        (hl),d                        ;[0d05] 72
                    ld        h,c                           ;[0d06] 61
                    ld        h,a                           ;[0d07] 67
                    ld        h,l                           ;[0d08] 65
                    jr        nz,$0d6f                      ;[0d09] 20 64
                    ld        (hl),l                        ;[0d0b] 75
                    jr        nz,$0d82                      ;[0d0c] 20 74
                    ld        h,l                           ;[0d0e] 65
                    ld        (hl),e                        ;[0d0f] 73
                    ld        (hl),h                        ;[0d10] 74
                    jr        nz,$0d77                      ;[0d11] 20 64
                    ld        h,l                           ;[0d13] 65
                    ld        (hl),e                        ;[0d14] 73
                    jr        nz,$0d8a                      ;[0d15] 20 73
                    ld        (hl),a                        ;[0d17] 77
                    ld        l,c                           ;[0d18] 69
                    ld        (hl),h                        ;[0d19] 74
                    ld        h,e                           ;[0d1a] 63
                    ld        l,b                           ;[0d1b] 68
                    ld        a,(bc)                        ;[0d1c] 0a
                    nop                                     ;[0d1d] 00
                    nop                                     ;[0d1e] 00
                    nop                                     ;[0d1f] 00
                    nop                                     ;[0d20] 00
                    nop                                     ;[0d21] 00
                    nop                                     ;[0d22] 00
                    nop                                     ;[0d23] 00
                    nop                                     ;[0d24] 00
                    nop                                     ;[0d25] 00
                    nop                                     ;[0d26] 00
                    dec       c                             ;[0d27] 0d
                    ld        b,h                           ;[0d28] 44
                    ld        h,l                           ;[0d29] 65
                    ld        l,l                           ;[0d2a] 6d
                    ld        h,c                           ;[0d2b] 61
                    ld        (hl),d                        ;[0d2c] 72
                    ld        (hl),d                        ;[0d2d] 72
                    ld        h,c                           ;[0d2e] 61
                    ld        h,a                           ;[0d2f] 67
                    ld        h,l                           ;[0d30] 65
                    jr        nz,$0d97                      ;[0d31] 20 64
                    ld        (hl),l                        ;[0d33] 75
                    jr        nz,$0daa                      ;[0d34] 20 74
                    ld        h,l                           ;[0d36] 65
                    ld        (hl),e                        ;[0d37] 73
                    ld        (hl),h                        ;[0d38] 74
                    jr        nz,$0d9f                      ;[0d39] 20 64
                    ld        h,l                           ;[0d3b] 65
                    ld        (hl),e                        ;[0d3c] 73
                    jr        nz,$0da1                      ;[0d3d] 20 62
                    ld        l,a                           ;[0d3f] 6f
                    ld        (hl),l                        ;[0d40] 75
                    ld        (hl),h                        ;[0d41] 74
                    ld        l,a                           ;[0d42] 6f
                    ld        l,(hl)                        ;[0d43] 6e
                    ld        (hl),e                        ;[0d44] 73
                    ld        a,(bc)                        ;[0d45] 0a
                    nop                                     ;[0d46] 00
                    nop                                     ;[0d47] 00
                    nop                                     ;[0d48] 00
                    nop                                     ;[0d49] 00
                    nop                                     ;[0d4a] 00
                    nop                                     ;[0d4b] 00
                    nop                                     ;[0d4c] 00
                    nop                                     ;[0d4d] 00
                    nop                                     ;[0d4e] 00
                    dec       c                             ;[0d4f] 0d
                    ld        b,h                           ;[0d50] 44
                    ld        h,l                           ;[0d51] 65
                    ld        l,l                           ;[0d52] 6d
                    ld        h,c                           ;[0d53] 61
                    ld        (hl),d                        ;[0d54] 72
                    ld        (hl),d                        ;[0d55] 72
                    ld        h,c                           ;[0d56] 61
                    ld        h,a                           ;[0d57] 67
                    ld        h,l                           ;[0d58] 65
                    jr        nz,$0dbf                      ;[0d59] 20 64
                    ld        (hl),l                        ;[0d5b] 75
                    jr        nz,$0dd2                      ;[0d5c] 20 74
                    ld        h,l                           ;[0d5e] 65
                    ld        (hl),e                        ;[0d5f] 73
                    ld        (hl),h                        ;[0d60] 74
                    jr        nz,$0dc7                      ;[0d61] 20 64
                    ld        (hl),l                        ;[0d63] 75
                    jr        nz,$0dd0                      ;[0d64] 20 6a
                    ld        l,a                           ;[0d66] 6f
                    ld        a,c                           ;[0d67] 79
                    ld        (hl),e                        ;[0d68] 73
                    ld        (hl),h                        ;[0d69] 74
                    ld        l,c                           ;[0d6a] 69
                    ld        h,e                           ;[0d6b] 63
                    ld        l,e                           ;[0d6c] 6b
                    ld        a,(bc)                        ;[0d6d] 0a
                    nop                                     ;[0d6e] 00
                    nop                                     ;[0d6f] 00
                    nop                                     ;[0d70] 00
                    nop                                     ;[0d71] 00
                    nop                                     ;[0d72] 00
                    nop                                     ;[0d73] 00
                    nop                                     ;[0d74] 00
                    nop                                     ;[0d75] 00
                    nop                                     ;[0d76] 00
                    dec       c                             ;[0d77] 0d
                    ld        b,h                           ;[0d78] 44
                    ld        h,l                           ;[0d79] 65
                    ld        l,l                           ;[0d7a] 6d
                    ld        h,c                           ;[0d7b] 61
                    ld        (hl),d                        ;[0d7c] 72
                    ld        (hl),d                        ;[0d7d] 72
                    ld        h,c                           ;[0d7e] 61
                    ld        h,a                           ;[0d7f] 67
                    ld        h,l                           ;[0d80] 65
                    jr        nz,$0de8                      ;[0d81] 20 65
                    ld        h,(hl)                        ;[0d83] 66
                    ld        h,(hl)                        ;[0d84] 66
                    ld        h,c                           ;[0d85] 61
                    ld        h,e                           ;[0d86] 63
                    ld        h,l                           ;[0d87] 65
                    ld        l,l                           ;[0d88] 6d
                    ld        h,l                           ;[0d89] 65
                    ld        l,(hl)                        ;[0d8a] 6e
                    ld        (hl),h                        ;[0d8b] 74
                    jr        nz,$0dfb                      ;[0d8c] 20 6d
                    ld        h,l                           ;[0d8e] 65
                    ld        l,l                           ;[0d8f] 6d
                    ld        l,a                           ;[0d90] 6f
                    ld        l,c                           ;[0d91] 69
                    ld        (hl),d                        ;[0d92] 72
                    ld        h,l                           ;[0d93] 65
                    jr        nz,$0dfc                      ;[0d94] 20 66
                    ld        l,h                           ;[0d96] 6c
                    ld        h,c                           ;[0d97] 61
                    ld        (hl),e                        ;[0d98] 73
                    ld        l,b                           ;[0d99] 68
                    ld        a,(bc)                        ;[0d9a] 0a
                    nop                                     ;[0d9b] 00
                    nop                                     ;[0d9c] 00
                    nop                                     ;[0d9d] 00
                    nop                                     ;[0d9e] 00
                    dec       c                             ;[0d9f] 0d
                    ld        b,h                           ;[0da0] 44
                    ld        h,l                           ;[0da1] 65
                    ld        l,l                           ;[0da2] 6d
                    ld        h,c                           ;[0da3] 61
                    ld        (hl),d                        ;[0da4] 72
                    ld        (hl),d                        ;[0da5] 72
                    ld        h,c                           ;[0da6] 61
                    ld        h,a                           ;[0da7] 67
                    ld        h,l                           ;[0da8] 65
                    jr        nz,$0e1b                      ;[0da9] 20 70
                    ld        (hl),d                        ;[0dab] 72
                    ld        l,a                           ;[0dac] 6f
                    ld        h,a                           ;[0dad] 67
                    ld        (hl),d                        ;[0dae] 72
                    ld        h,c                           ;[0daf] 61
                    ld        l,l                           ;[0db0] 6d
                    ld        l,l                           ;[0db1] 6d
                    ld        h,c                           ;[0db2] 61
                    ld        (hl),h                        ;[0db3] 74
                    ld        l,c                           ;[0db4] 69
                    ld        l,a                           ;[0db5] 6f
                    ld        l,(hl)                        ;[0db6] 6e
                    jr        nz,$0e26                      ;[0db7] 20 6d
                    ld        h,l                           ;[0db9] 65
                    ld        l,l                           ;[0dba] 6d
                    ld        l,a                           ;[0dbb] 6f
                    ld        l,c                           ;[0dbc] 69
                    ld        (hl),d                        ;[0dbd] 72
                    ld        h,l                           ;[0dbe] 65
                    jr        nz,$0e27                      ;[0dbf] 20 66
                    ld        l,h                           ;[0dc1] 6c
                    ld        h,c                           ;[0dc2] 61
                    ld        (hl),e                        ;[0dc3] 73
                    ld        l,b                           ;[0dc4] 68
                    ld        a,(bc)                        ;[0dc5] 0a
                    nop                                     ;[0dc6] 00
                    dec       c                             ;[0dc7] 0d
                    ld        c,a                           ;[0dc8] 4f
                    ld        (hl),b                        ;[0dc9] 70
                    ld        (hl),h                        ;[0dca] 74
                    ld        l,c                           ;[0dcb] 69
                    ld        l,a                           ;[0dcc] 6f
                    ld        l,(hl)                        ;[0dcd] 6e
                    jr        nz,$0e39                      ;[0dce] 20 69
                    ld        l,(hl)                        ;[0dd0] 6e
                    ld        h,e                           ;[0dd1] 63
                    ld        l,a                           ;[0dd2] 6f
                    ld        l,(hl)                        ;[0dd3] 6e
                    ld        l,(hl)                        ;[0dd4] 6e
                    ld        (hl),l                        ;[0dd5] 75
                    ld        h,l                           ;[0dd6] 65
                    jr        nz,$0dfa                      ;[0dd7] 20 21
                    ld        a,(bc)                        ;[0dd9] 0a
                    dec       c                             ;[0dda] 0d
                    nop                                     ;[0ddb] 00
                    nop                                     ;[0ddc] 00
                    nop                                     ;[0ddd] 00
                    nop                                     ;[0dde] 00
                    nop                                     ;[0ddf] 00
                    nop                                     ;[0de0] 00
                    nop                                     ;[0de1] 00
                    nop                                     ;[0de2] 00
                    nop                                     ;[0de3] 00
                    nop                                     ;[0de4] 00
                    nop                                     ;[0de5] 00
                    nop                                     ;[0de6] 00
                    nop                                     ;[0de7] 00
                    nop                                     ;[0de8] 00
                    nop                                     ;[0de9] 00
                    nop                                     ;[0dea] 00
                    nop                                     ;[0deb] 00
                    nop                                     ;[0dec] 00
                    nop                                     ;[0ded] 00
                    nop                                     ;[0dee] 00
                    ld        d,d                           ;[0def] 52
                    ld        h,l                           ;[0df0] 65
                    ld        h,e                           ;[0df1] 63
                    ld        h,l                           ;[0df2] 65
                    ld        l,c                           ;[0df3] 69
                    halt                                    ;[0df4] 76
                    ld        h,l                           ;[0df5] 65
                    ld        h,h                           ;[0df6] 64
                    jr        nz,$0e5d                      ;[0df7] 20 64
                    ld        h,c                           ;[0df9] 61
                    ld        (hl),h                        ;[0dfa] 74
                    ld        h,c                           ;[0dfb] 61
                    jr        nz,$0e3b                      ;[0dfc] 20 3d
                    jr        nz,$0e30                      ;[0dfe] 20 30
                    ld        a,b                           ;[0e00] 78
                    dec       h                             ;[0e01] 25
                    jr        nc,$0e36                      ;[0e02] 30 32
                    ld        a,b                           ;[0e04] 78
                    jr        nz,$0e14                      ;[0e05] 20 0d
                    ld        a,(bc)                        ;[0e07] 0a
                    nop                                     ;[0e08] 00
                    ld        c,h                           ;[0e09] 4c
                    ld        (hl),e                        ;[0e0a] 73
                    ld        (hl),d                        ;[0e0b] 72
                    ld        d,d                           ;[0e0c] 52
                    ld        h,l                           ;[0e0d] 65
                    ld        h,a                           ;[0e0e] 67
                    ld        l,c                           ;[0e0f] 69
                    ld        (hl),e                        ;[0e10] 73
                    ld        (hl),h                        ;[0e11] 74
                    ld        h,l                           ;[0e12] 65
                    ld        (hl),d                        ;[0e13] 72
                    jr        nz,$0e53                      ;[0e14] 20 3d
                    jr        nz,$0e48                      ;[0e16] 20 30
                    ld        a,b                           ;[0e18] 78
                    dec       h                             ;[0e19] 25
                    jr        nc,$0e4e                      ;[0e1a] 30 32
                    ld        a,b                           ;[0e1c] 78
                    jr        nz,$0e2c                      ;[0e1d] 20 0d
                    ld        a,(bc)                        ;[0e1f] 0a
                    nop                                     ;[0e20] 00
                    ld        b,e                           ;[0e21] 43
                    ld        l,a                           ;[0e22] 6f
                    ld        l,l                           ;[0e23] 6d
                    ld        (hl),b                        ;[0e24] 70
                    ld        (hl),h                        ;[0e25] 74
                    ld        h,l                           ;[0e26] 65
                    ld        (hl),l                        ;[0e27] 75
                    ld        (hl),d                        ;[0e28] 72
                    jr        nz,$0e81                      ;[0e29] 20 56
                    ld        b,d                           ;[0e2b] 42
                    ld        c,h                           ;[0e2c] 4c
                    ld        b,c                           ;[0e2d] 41
                    ld        c,(hl)                        ;[0e2e] 4e
                    ld        c,e                           ;[0e2f] 4b
                    jr        nz,$0e6c                      ;[0e30] 20 3a
                    jr        nz,$0e59                      ;[0e32] 20 25
                    ld        l,h                           ;[0e34] 6c
                    ld        (hl),l                        ;[0e35] 75
                    ld        a,(bc)                        ;[0e36] 0a
                    dec       c                             ;[0e37] 0d
                    nop                                     ;[0e38] 00
                    ld        (hl),e                        ;[0e39] 73
                    pop       af                            ;[0e3a] f1
                    ex        af,af'                        ;[0e3b] 08
                    ld        h,e                           ;[0e3c] 63
                    ld        a,a                           ;[0e3d] 7f
                    ex        af,af'                        ;[0e3e] 08
                    ld        h,h                           ;[0e3f] 64
                    adc       e                             ;[0e40] 8b
                    ex        af,af'                        ;[0e41] 08
                    ld        (hl),l                        ;[0e42] 75
                    add       hl,de                         ;[0e43] 19
                    add       hl,bc                         ;[0e44] 09
                    ld        a,b                           ;[0e45] 78
                    ld        e,$09                         ;[0e46] 1e 09
                    ld        l,a                           ;[0e48] 6f
                    ret       pe                            ;[0e49] e8
                    ex        af,af'                        ;[0e4a] 08
                    ld        (hl),b                        ;[0e4b] 70
                    ld        e,$09                         ;[0e4c] 1e 09
                    ld        e,b                           ;[0e4e] 58
                    ld        l,(hl)                        ;[0e4f] 6e
                    ex        af,af'                        ;[0e50] 08
                    ld        l,(hl)                        ;[0e51] 6e
                    rst       $10                           ;[0e52] d7
                    ex        af,af'                        ;[0e53] 08
                    ld        b,d                           ;[0e54] 42
                    ld        h,c                           ;[0e55] 61
                    ex        af,af'                        ;[0e56] 08
                    ld        l,h                           ;[0e57] 6c
                    sub       b                             ;[0e58] 90
                    ex        af,af'                        ;[0e59] 08
                    nop                                     ;[0e5a] 00
                    ld        h,h                           ;[0e5b] 64
                    or        a                             ;[0e5c] b7
                    ex        af,af'                        ;[0e5d] 08
                    ld        (hl),l                        ;[0e5e] 75
                    push      bc                            ;[0e5f] c5
                    ex        af,af'                        ;[0e60] 08
                    ld        a,b                           ;[0e61] 78
                    jp        z,$6f08                       ;[0e62] ca 08 6f
                    cp        h                             ;[0e65] bc
                    ex        af,af'                        ;[0e66] 08
                    ld        e,b                           ;[0e67] 58
                    and       (hl)                          ;[0e68] a6
                    ex        af,af'                        ;[0e69] 08
                    ld        b,d                           ;[0e6a] 42
                    sbc       c                             ;[0e6b] 99
                    ex        af,af'                        ;[0e6c] 08
                    nop                                     ;[0e6d] 00
                    jr        z,$0ede                       ;[0e6e] 28 6e
                    ld        (hl),l                        ;[0e70] 75
                    ld        l,h                           ;[0e71] 6c
                    ld        l,h                           ;[0e72] 6c
                    add       hl,hl                         ;[0e73] 29
                    nop                                     ;[0e74] 00
