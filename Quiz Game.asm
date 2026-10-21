.MODEL SMALL
.STACK 100H           ; 256 bytes

.DATA
    WELCOME_MSG DB '=== GENERAL KNOWLEDGE QUIZ ===$', 0DH, 0AH
    CORRECT_MSG DB ' -> Correct!$', 0DH, 0AH, '$'
    WRONG_MSG   DB ' -> Wrong!$', 0DH, 0AH, '$'
    SCORE_MSG   DB 0DH, 0AH, 'Final Score: $'
    OUT_OF_MSG  DB ' / 3$', 0DH, 0AH
    PASS_MSG    DB ' -> Great job! You passed!$', 0DH, 0AH
    FAIL_MSG    DB ' -> Better luck next time!$', 0DH, 0AH

    ; General Knowledge Questions
    Q1 DB 0DH, 0AH, 'Q1: Capital of France? (A: Paris  B: Rome): $'
    Q2 DB 0DH, 0AH, 'Q2: Red planet in space? (A: Venus  B: Mars): $'
    Q3 DB 0DH, 0AH, 'Q3: Largest ocean on Earth? (A: Pacific  B: Atlantic): $'
    
    QUESTIONS DW Q1, Q2, Q3        ; Array of question string addresses
    ANSWERS   DB 'A', 'B', 'A'     ; Correct answers (A: Paris, B: Mars, A: Pacific)
    SCORE     DB 0                 ; User score counter

.CODE
MAIN PROC
    MOV AX, @DATA                ; Load data segment address into AX
    MOV DS, AX                   ; Initialize Data Segment

    CALL CLEAR_SCREEN            ; Reset screen using BIOS interrupt
    LEA DX, WELCOME_MSG          ; Load welcome message address
    CALL DISPLAY_PROC            ; Display welcome header

    MOV CX, 3                    ; Loop counter for 3 questions
    XOR SI, SI                   ; Pointer for QUESTIONS array (word offset)
    XOR DI, DI                   ; Pointer for ANSWERS array (byte offset)

QUESTION_LOOP:
    MOV DX, QUESTIONS[SI]        ; Load pointer to current question string
    CALL DISPLAY_PROC            ; Display the question prompt

    MOV AH, 01H                  ; Function 01h: Read single keypress
    INT 21H                      ; Read user choice into AL

    ; Convert lowercase input to uppercase ('a'->'A', 'b'->'B')
    AND AL, 0DFH                 ; Bitwise AND with 8-bit mask to clear bit 5

    CMP AL, ANSWERS[DI]          ; Compare user input with answer array
    JNE WRONG_ANSWER             ; Jump if input does not match answer

    INC SCORE                    ; Increment score counter on correct match
    LEA DX, CORRECT_MSG          ; Load address of "Correct!" string
    JMP PRINT_FEEDBACK           ; Jump to display result

WRONG_ANSWER:
    LEA DX, WRONG_MSG            ; Load address of "Wrong!" string

PRINT_FEEDBACK:
    CALL DISPLAY_PROC            ; Print feedback message
    ADD SI, 2                    ; Advance to next question pointer (word = 2 bytes)
    INC DI                       ; Advance to next answer byte
    LOOP QUESTION_LOOP           ; Decrement CX and loop if CX > 0

    ; Display Final Results
    LEA DX, SCORE_MSG            ; Load score label string
    CALL DISPLAY_PROC            ; Print score label
    
    MOV DL, SCORE                ; Load total score count into DL
    ADD DL, '0'                  ; Convert numerical score to ASCII digit
    MOV AH, 02H                  ; Direct character output function
    INT 21H                      ; Output score character

    LEA DX, OUT_OF_MSG           ; Load "/ 3" suffix string
    CALL DISPLAY_PROC            ; Output total string

    CMP SCORE, 2                 ; Compare final score to passing cutoff (2)
    JL SHOW_FAIL                 ; Conditional jump: Jump if score < 2

    LEA DX, PASS_MSG             ; Load victory message address
    JMP SHOW_RESULT              ; Unconditional jump to result display

SHOW_FAIL:
    LEA DX, FAIL_MSG             ; Load failure message address

SHOW_RESULT:
    CALL DISPLAY_PROC            ; Output final result message

    MOV AH, 4CH                  ; Function 4Ch: Return control to DOS
    INT 21H                      ; Terminate program execution
MAIN ENDP

; =========================================================
; PROCEDURES
; =========================================================

DISPLAY_PROC PROC                ; Procedure to display string stored at DX
    PUSH AX                      ; Save AX state on stack
    PUSH DX                      ; Save DX state on stack
    MOV AH, 09H                  ; DOS function 09h: Output string
    INT 21H                      ; Trigger interrupt
    POP DX                       ; Restore DX state from stack
    POP AX                       ; Restore AX state from stack
    RET                          ; Return to caller
DISPLAY_PROC ENDP

CLEAR_SCREEN PROC                ; Procedure to clear screen using video mode
    PUSH AX                      ; Save AX state on stack
    MOV AH, 00H                  ; Video mode function
    MOV AL, 03H                  ; Mode 03h: 80x25 standard text screen
    INT 10H                      ; Trigger BIOS video interrupt
    POP AX                       ; Restore AX state from stack
    RET                          ; Return to caller
CLEAR_SCREEN ENDP

END MAIN