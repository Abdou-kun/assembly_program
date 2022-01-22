;*******************************************************************Projet TP*************************************************************************************** 

                    ;********   *******        ***      ***********            ************  ********  
                    ;***    **  ***   **    *********   **                     ************  ***    **
                    ;********   *******    **       **  **********   *******       ***       ********
                    ;***        ***   **   **       **  **********   *******       ***       ***  
                    ;***        ***    **   *********   **                         ***       ***
                    ;***        ***     **     ***      ***********                ***       ***

                                            ;NOM : ALLOUI                          NOM : RADJAI
                                            ;PRENOM : ABDELRAOUF                   PRENOM : NABIL
                                            ;MATRICULE : 191931089460              MATRICULE : 191931063491
                                            ;GROUPE : 3-2                          GROUPE : 3-2        

;******************************************Les declarations de segments ,structures de donnees et de variables********************************************************

Data segment

    T dw 200 dup(?) ;declaration du tableau T
    
    NewT dw 200 dup(?) ;declaration du tableau NewT
    
    n dw ? ;declaration de la variable n(nombres d'elements des tableau)
    
;*************************************declaration des differents message a afficher*******************************************************    

    msg  db 0AH,0DH,'appuyer sur une touche pour continuer ... $'
    
    msg1 db 'Entrez le nombre elements du tableau n: $'  
    
    msg2 db 'Entrez un nombre : $'
    
    msg3 db 'Les elements du tableau en hexa sont :',0AH,0DH, '$'
    
    msg4 db 'le maximum des elements du tableau en decimal est : $'
    
    msg5 db 'Le minimum  des elements du tableau en hexa est: $'
    
    msg6 db 'Les elements du tableau en binaire sont :',0AH,0DH,'$'
    
;*****************************************************************************************************************************************    
    
    chaineLu db 200 dup(?);declaration de la chaine numerique qui doit etre lu en entres 
    
    minimum dw ? ;declaration de la variable minimum ou est stocke la minimum des valeurs du tableau T
    
    maximum dw ? ;declaration de la variable maximum ou est stocke la maximum des valeurs du tableau T
    
    produit dw ? ;declaration de la variable produit ou est stocke le resultat du  produit de deux nombre
    
    nombre dw ?  ;declaration de la variable nombre pour stocker le nombre de la chaine numerique lu

Data ends

Stack segment

Stack ends

extra segment

extra ends

Code segment

    Assume DS:Data, CS:Code, SS:Stack, es:extra ;la directive assume permet d'assigner a chaque segment le registre segment qui lui correspond
    
    Start:
    
        MOV     AX, Data
        MOV     DS, AX
        MOV     AX, Stack
        MOV     SS , AX
        MOV     AX, extra
        MOV     es, AX

                                                    ;***       * ***     * * *     ***  ***       ***
                                                    ;*** *   * * ***  ***     ***   *   *** *     ***
                                                    ;***   *     ***  ***********   *   ***   *   ***
                                                    ;***         ***  ***     ***   *   ***     * ***
                                                    ;***         ***  ***     ***  ***  ***       ***
        MOV     AX, 32
            
        lectureDeN:;lecture de la taille de n tel que n superieur ou egale a 100 et inferieur ou egale a 200
        
            
            CALL    EffacerEcran ;appel de la procedure qui permet d'effacer l'ecran
            
            lea     DX, msg1  ;DX = offset de msg1
            
            CALL    AfficherChaine ;afficher la chaine msg1

            ;lecture de la chaine numerique et sa conversion en nombre en appelant les deux procedures suivantes
            
            CALL    LireUneChaineNumeriqueDec
            
            CALL    ConvertirChaineNumEnNombre

            MOV     AX, nombre 
            MOV     n, AX
            ;CMP     n, 100 
            ;jb      lectureDeN ;si n est inferieur a 100 saut au label lectureDeN
            ;CMP     n, 200
            ;ja      lectureDeN ; si n est superieur a 200 saut au label lectureDeN  
            MOV     CX, n 
            XOR     SI, SI;si=0
        
        LectureDesEltDuTab:;Lecture des elements du tableau element par element et les stocker dans T
        
            CALL    EffacerEcran
            
            lea     DX, msg2  ;DX=offset de msg2
            
            CALL    AfficherChaine ;afficher la chaine msg2
            
        
            ;empiler  si puis CX la pile pour les sauvgarder

            PUSH    SI
            PUSH    CX
            
            CALL    LireUneChaineNumeriqueDec
            
            CALL    ConvertirChaineNumEnNombre
            ;depiler CX puis si   
            POP     CX
            POP     SI
            
            ;mettre la valeur lu dans le tab et incrementation du si
            MOV     AX,nombre
            MOV     T[SI], AX 
            inc     SI
            inc     SI
            
            LOOP    LectureDesEltDuTab ;comparer lla valeur du CX a 0 pour saut conditionel et decrementation du CX 
            
            CALL    appuyerPourContinuer

            CALL    EffacerEcran

            lea     DX, msg3  ;DX=offset msg3
        
        CALL        AfficherChaine 
        
        MOV         CX, n
        XOR         SI, SI
        
        AffichageDesEltDuTab: ;affichage des elements du tableau T en hexadecimal
        
            ;mettre la valeur de T dans le BX pour l'afficher en hexa grace a la procedure AfficheNBHexa
            MOV     BX, T[SI]
            inc     SI
            inc     SI
            
            CALL    AfficheNBHexa
            
            MOV     DX,48H
            
            CALL    AfficheCaractere
            
            MOV     DX, 09h
            
            CALL    AfficheCaractere
            
        LOOP    AffichageDesEltDuTab

        CALL    appuyerPourContinuer

        CALL    EffacerEcran
        
        CALL    MaximumDeT ; chercher le maximum du T

        lea     DX, msg4
        
        CALL    afficherChaine 
        
        MOV     AX, maximum

        CALL    AfficheNBDecimal
        
        CALL    appuyerPourContinuer

        CALL    EffacerEcran

        CALL    MinimumDeT ; chercher le minimum du T

        MOV     minimum, AX
        MOV     BX, minimum
        lea     DX, msg5
        
        CALL    afficherChaine

        CALL    AfficheNBHexa
        
        MOV     DX, 48H
        
        CALL    AfficheCaractere
        
        CALL    appuyerPourContinuer
        
        CALL    EffacerEcran

        MOV     CX, n
        XOR     SI, SI
        
        CALL    DivisionMinimumParSeize ;
        
        affectationToNewT:

            MOV     AX, T[si]
            
            MOV     produit, 0
            CALL    ProduitDedeuxNombres
            MOV     AX, produit
            MOV     NewT[si], AX
            inc     SI
            inc     SI   
            LOOP    affectationToNewT 

        MOV     CX, n
        XOR     SI, SI
        MOV     DX, offset msg6
        
        CALL    AfficherChaine

        affichageNewTEnBinaire:

            PUSH    CX
            MOV     BX, NewT[SI]
            CALL    AfficheNBBinaire
            
            
            MOV     DX,09
            PUSH    CX
            MOV     CX,3
            Tabulation:
            
            CALL    AfficheCaractere
            
            loop Tabulation
            
            POP     CX
            INC     SI
            INC     SI
            POP     CX

        LOOP    affichageNewTEnBinaire
        
        CALL    appuyerPourContinuer
        
        CALL    EffacerEcran
    
    MOV ah, 4ch ; le programme est termine par l'instruction specifique qui est INT 21h avec la fonction 4Ch son role est de terminer un programme (exit) 
    INT 21h 

code ends


;**********************************************************Declaration des procedures**************************************************************************

;Procedure qui charge de la lecture d un nombre sous forme de chaine numerique decimale

LireUneChaineNumeriqueDec   PROC

    XOR     CX, CX  ; passage des parametre par registres
    XOR     SI, SI

    nombre_suiv:

;entez un caractere via le clavier dans AL:

    CALL    lectureCaractere

;autoriser les numbres seulement:
    
    CMP     AL, '0'
    jae     ok_0    ;verifier si le nombre est superieur ou egale a '0'
    jb      sortie
    
    ok_0:        

        CMP     AL, '9'
        ja      sortie
        MOV     chaineLu[SI],AL ; verifier si le nombre est inferieur ou egale a '9'
        inc     SI
        JMP     nombre_suiv

    sortie:
    
    RET    
    
LireUneChaineNumeriqueDec ENDP
    
;Procedure qui cenverte une chaine numerique en un nombre
    
ConvertirChaineNumEnNombre PROC
        
    PUSH    SI
    PUSH    CX ; passage des parametres par pile
    PUSH    BP
    MOV     BP,SP 
    MOV     CX, SI
    XOR     SI, SI
    MOV     nombre, 0

    Tronsformation:

    ; multiplication de CX par 10 (le premier resultat est egale a zero)     

    MOV     BX, 10 
    MOV     AX, nombre
    MUL     BX
    MOV     nombre, AX 
    XOR     AX, AX
    MOV     AL, chaineLu[si]
    inc     si
    SUB     AX, 30h  ; convertion de code ASCII

    ; addionner AL et CX:

    ADD nombre, AX

    LOOP Tronsformation

    POP     BP
    POP     CX
    POP     si

    RET
        
ConvertirChaineNumEnNombre  ENDP

;Procedure qui affiche le nombre en decimal

AfficheNBDecimal    proc
    
    PUSH    AX
    PUSH    BX
    PUSH    BP      ; passage des parametres par pile
    MOV     BP, SP
    MOV     BX, 10
    XOR     CX, CX
    
    empiler:
    
        XOR     DX, DX
        div     BX  
        ADD     DX, 48  
        PUSH    DX 
        inc     CX 
        CMP     AX, 0 
        jne     empiler    
        
    depiler:

        MOV     AH, 02h ; stocker 02h dans ah en suite on fait un appel a l'intruption 21h pour afficher un caractere avec echo
        POP     DX  
        
        INT 21h  
        
        LOOP    depiler
        
        POP     BP        
        POP     BX
        POP     AX
        
    RET      
        
AfficheNBDecimal    ENDP  

;Procdures minimum avec passage de parametres par registres 

MinimumDeT proc
    
    MOV     SI, 0
    MOV     AX, T[SI]    
    MOV     CX, n     
    DEC     CX

    BoucleMini:
    
        INC     SI
        INC     SI
        CMP     AX, T[SI]
        JA      affectationToMini    
        JMP     Boucle

    affectationToMini:
    
        MOV     AX, T[si]

    Boucle:

        LOOP    BoucleMini

    RET
    
MinimumDeT   ENDP

;procdures maximum avec passage de parametres par pile

MaximumDeT   PROC

    
    
    MOV     CX, n ;mettre le taille du tableau n dans le CX 
    XOR     SI, SI;initialiser la valeur du si a 0
    MOV     AX, T[SI]
    MOV     maximum, AX
    dec     CX

    BoucleMax:
    
        INC     SI
        INC     SI
        MOV     AX, T[si]
        CMP     maximum, AX
        JB      affectationToMax
        JMP     Boucle1

    affectationToMax:
        
        MOV     maximum, AX

    Boucle1:
    
        LOOP    BoucleMax

    RET

MaximumDeT  ENDP

;procedures qui permet d'afficher un nombre en hexa

AfficheNBHexa   PROC

    PUSH    CX
    PUSH    BP
    MOV     BP,SP
    MOV     CX, 3

    PoidsFortDuAH:

        MOV     AL, BH
        and     AL, 0f0h
        shr     AL, 4
        JMP     affichage

    PoidsFaibleDuAH:

        MOV     AL, BH
        and     AL, 0fh
        DEC     CX
        JMP     affichage

    PoidsFortDuAL:

        MOV     AL, bl
        and     AL, 0f0h
        shr     AL, 4
        DEC     CX
        JMP     affichage

    PoidsFaibleDuAL:

        MOV     AL, bl
        and     AL, 0fh 
        DEC     CX
        JMP     affichage

    affichage:
        
        CMP     AL, 0Ah                   
        JE      caseA                   
        CMP     AL, 0Bh
        JE      caseB
        CMP     AL, 0Ch                    
        JE      caseC
        CMP     AL, 0Dh
        JE      caseD
        CMP     AL, 0Eh
        JE      caseE
        CMP     AL, 0Fh
        JE      caseF
        
        ;cas ou le digithexa sois entre 0 et 9

        ADD     AL, 30h
        MOV     DL, AL

        CALL    AfficheCaractere

        CALL    condition

        JMP     Exit

        ;cas ou le digithexa egal a 'A' 
        
        caseA:
        
            MOV     DL, 41H
            
            CALL    AfficheCaractere
    
            CALL    condition
            
            JMP     Exit

        ;cas ou le digithexa egal a 'B'   
        
        caseB:

            MOV     DL, 42H

            CALL    AfficheCaractere
            
            CALL    condition
            
            JMP     Exit


        ;cas ou le digithexa egal a 'C' 
        
        caseC:
            
            MOV     DL, 43H

            CALL    AfficheCaractere

            CALL    condition
            
            JMP     Exit

        ;cas ou le digithexa egal a 'D' 
        
        caseD:
            
            MOV     DL, 44H

            CALL    AfficheCaractere
            
            CALL    condition
            
            JMP     Exit

        ;cas ou le digithexa egal a 'E' 
        
        caseE:
            
            MOV     DL, 45H

            CALL    AfficheCaractere
            
            CALL    condition
            
            JMP     Exit

        ;cas ou le digithexa egal a 'F'
        
        caseF:

            MOV     DL, 46H

            CALL    AfficheCaractere

            CALL    condition
            
            JMP     Exit

        Exit:

            POP     BP
            POP     CX

    RET

AfficheNBHexa ENDP

;procedure peremtant de verifier la valeur du CX pour traiter le bon digithexa 

condition   PROC

    CMP     CX, 3
    JE      PoidsFaibleDuAH
    CMP     CX, 2
    JE      PoidsFortDuAL
    CMP     CX, 1
    JE      PoidsFaibleDuAL

    RET
    
condition   ENDP

;Procedure qui affiche un caractere

AfficheCaractere    PROC

    MOV     ah, 02H 

    INT 21H
    
    RET
    
AfficheCaractere    ENDP
    
; Procedure qui afficher une chaine 
    
AfficherChaine  PROC
    
    MOV     ah, 09H

    INT 21H
    
    RET
    
AfficherChaine  ENDP

;Procedure qui efface l'ecran
    
EffacerEcran    PROC

    PUSH    CX
    MOV     AX, 600H
    MOV	    BH, 7     
    MOV	    CX, 0
    MOV	    DX, 184FH 
    
    INT	10H 
    
;mettre le curseur a la premier position
    
    MOV	    ah, 2
    MOV	    BH, 0
    MOV     DX, 0
    INT	    10H
    
    POP     CX
    
    RET
    
EffacerEcran    ENDP
    
;Procedure qui divise le minimum du tableau par 16
    
DivisionMinimumParSeize     PROC
    
    PUSH Minimum          
    PUSH    BP
    MOV     BP, SP
    MOV     BX, [BP+2]
    shr     BX, 4
    POP     BP 
    POP     Minimum

    RET    
    
DivisionMinimumParSeize     ENDP

;Procedure qui affiche le nombre binaire a

AfficheNBBinaire    PROC

    MOV     CX, 16
        
    print:        

        MOV     ah, 2H      
        MOV     DL, '0'
        test    BX, 1000000000000000b  ; test first bit.
        jz      zero
        MOV     DL, '1'
        
    zero:    

        INT     21h       
        shl     BX, 1 ;decalage a gauche d'un bit
        LOOP    print
        
    MOV        DX, 98
    CALL       AfficheCaractere


    RET

AfficheNBBinaire    ENDP

;Procedure qui fait le produit de deux nombres 

ProduitDedeuxNombres    PROC

    PUSH    BX
    PUSH    produit
    PUSH    BP
    MOV     BP, SP

    multiplication:
    
        test    BX, 0000000000000001b
        jz      decalage
        ADD     [BP+2], AX

    decalage:

        shr     BX, 1
        shl     AX, 1
        CMP     BX, 0
        jnz     multiplication
        
        

    POP     BP
    POP     produit
    POP     BX 
    
    RET  

ProduitDedeuxNombres    ENDP

;Procedure qui sert a lire un carectere via le clavier

lectureCaractere     PROC
    
    MOV     ah, 01h ; stocker 01h dans ah puis on fait un appel a l'interuption 21h pour lire un caractere via le clavier
    INT 21H
    
    RET

lectureCaractere     ENDP 

;Procedure 

appuyerPourContinuer    PROC
    
    lea     DX, msg

    CALL    AfficherChaine
    
    CALL    lectureCaractere

    RET  
    
appuyerPourContinuer    ENDP

End Start