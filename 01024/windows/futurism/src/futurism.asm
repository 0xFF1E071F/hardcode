; ------------------------------------------------------
; FUTURISM - MandelBox 1k by Stefan "mad" Mader / Still
; ------------------------------------------------------
; thanks to hitchhikr for sources and packer so it was
; easy to put in the shader and don't care about the
; framework.... ;)
; ------------------------------------------------------
; ah and the fractal formula "mandelbox" speedups where
; proposed by buddhi and knighty at some forum called
; fractalforums.net
; ------------------------------------------------------

; ------------------------------------------------------
; 1kPack v0.9c - Direct X Framework (GetTickCount version)
; Written by Franck "hitchhikr" Charlet / Neural
; ------------------------------------------------------
; Thanks to rbraz for the trianglelist trick.
; ------------------------------------------------------
; buildblock RELEASE
; CAPT "[SOURCEDIR]nasmw.exe" -f bin "%2" -o "%1.bin" -s -O9
; CAPT "[SOURCEDIR]1kpack.exe" "depackers\dx_depacker_gtc.bin" "%1.bin"
; buildblockend
;
; buildblock DEBUG
; CAPT "[SOURCEDIR]nasmw.exe" -D DEBUG -f bin "%2" -o "%1.bin" -s -O9
; CAPT "[SOURCEDIR]1kpack.exe" "depackers\dx_depacker_gtc_debug.bin" "%1.bin"
; buildblockend

; ------------------------------------------------------
; Header
                                bits    32

; ------------------------------------------------------
; Includes
                                %include "d3d9_nasm.inc"

; ------------------------------------------------------
; Pre-processor constants
;%define DEBUG

; ------------------------------------------------------
; User constants
SCREENX                         equ     640
SCREENY                         equ     480

; ------------------------------------------------------
; Constants
WS_EX_TOPMOST                   equ     0x8
VK_ESCAPE                       equ     0x1b
WS_CAPTION                      equ     0xc00000
WS_POPUP                        equ     0x80000000
WS_BORDER                       equ     0x800000
WS_SYSMENU                      equ     0x80000
WS_VISIBLE                      equ     0x10000000
WS_THICKFRAME                   equ     0x40000
WS_POPUPWINDOW                  equ     WS_BORDER | WS_SYSMENU | WS_CAPTION | WS_VISIBLE | WS_THICKFRAME
SW_SHOWNORMAL                   equ     1

PM_REMOVE                       equ     0x1

SCREENDEPTH                     equ     D3DFMT_A8R8G8B8     ; 32 bits

D3DFVF_XYZRHW_SIZE              equ     (4 * 4)

BASE                            equ     0x420000

; Those are located inside the depacker
POS_fnc_exit                    equ     0x410090
POS_fnc_D3DXCompileShader       equ     0x410094
POS_fnc_LoadLibrary             equ     0x4100b4
POS_fnc_GetProcAddress          equ     0x4100b8
POS_fnc_GetTickCount            equ     0x4100bc
;POS_fnc_QueryPerformanceCounter equ     0x4100bc

; !!! Only valid for d3dx9_30.dll !!!
D3DX_D3DXCompileShader          equ     0xda6de
D3DX_D3DXCreateTextureFromFileInMemoryEx equ    (D3DX_D3DXCompileShader - 0xc1341)
D3DX_D3DXCreateTexture          equ     (D3DX_D3DXCompileShader - 0xbe4a2)

; ------------------------------------------------------
; Structures

; ------------------------------------------------------
; Vars datas
Device                          equ     0
OldTimeElapsed		            equ     Device + 4
TimeElapsed                     equ     OldTimeElapsed + 4
PixelShader                     equ     TimeElapsed + 4

; ---------------------------------------------------------
; Program entry point
; edi contains D3DXCompileShader address
                                org     BASE

EntryPoint:                     ;sub     edi, D3DX_D3DXCreateTextureFromFileInMemoryEx
                                ;; stack contains D3DXCreateTextureFromFileInMemoryEx
                                ;push    edi

                                ; Import the functions we need
                                mov     edi, table_dlls
load_dlls:                      push    edi
                                call    dword [POS_fnc_LoadLibrary]
                                test    eax, eax
                                jz      done_dlls
                                push    -1                              ; Fix a problem with windows 7
                                pop     ecx
                                repne   scasb                           ; Go to end of string
load_functions:                 xchg    ebx, eax                        ; DLL handle
                                push    edi
                                push    ebx
                                call    dword [POS_fnc_GetProcAddress]
                                test    eax, eax
                                jz      load_dlls
                                stosd
                                xchg    ebx, eax
                                repne   scasb                           ; Go to end of string
                                jmp     load_functions
done_dlls:
                                ; ----------------------------------------------------

                                mov     esi, API_CreateWindowEx
                                mov     edi, POS_fnc_GetTickCount
                                mov     ebp, Vars                       ; MUST BE ALIGNED !!

                                lea     eax, [ebp + PixelShader]

                                push    ebp                             ; CreateDevice
                                push    Present_Buffer
                                push    D3DCREATE_SOFTWARE_VERTEXPROCESSING

                                push    D3D_SDK_VERSION                 ; Direct3DCreate9

                                push    0                               ; D3DXCompileShader
                                push    0
                                push    eax
                                push    0
                                push    PShaderProfileName
                                push    ProcedureName
                                push    0
                                push    0
                                push    (fPShader - PShader)
                                push    PShader

                                %ifndef DEBUG
                                push    0                               ; SetCursor
                                %endif

                                push    0                               ; CreateWindowEx
                                push    0
                                push    0
                                push    0
                                %ifdef DEBUG
                                push    SCREENY
                                push    SCREENX
                                %else
                                push    0
                                push    0
                                %endif
                                push    0
                                push    0
                                %ifdef DEBUG
                                push    WS_POPUPWINDOW
                                %else
                                push    0
                                %endif
                                push    0
                                push    ClassName
                                %ifdef DEBUG
                                push    0
                                %else
                                push    WS_EX_TOPMOST
                                %endif
                                call    dword [esi]                     ; + (API_CreateWindowEx - API_CreateWindowEx)]
                                mov     ebx, eax
                                %ifdef DEBUG
                                push    SW_SHOWNORMAL
                                push    eax
                                call    dword [esi + (API_ShowWindow - API_CreateWindowEx)]
                                %else
                                call    dword [esi + (API_SetCursor - API_CreateWindowEx)]
                                %endif

                                call    dword [edi + (POS_fnc_D3DXCompileShader - POS_fnc_GetTickCount)]

                                ; ------------------------------------------------------
                                call    dword [esi + (API_Direct3DCreate9 - API_CreateWindowEx)]

                                push    ebx
                                push    D3DDEVTYPE_HAL
                                push    D3DADAPTER_DEFAULT              ; (0)
                                push    eax
                                mov     ebx, [eax]
                                call    [ebx + IDirect3D9.CreateDevice]

                                lea     eax, [ebp + PixelShader]
                                push    eax
                                mov     eax, [eax]
                                push    eax
                                mov     ebx, [eax]
                                call    [ebx + ID3DXConstantTable.GetBufferPointer]
                                push    eax
                                mov     eax, [ebp]
                                push    eax
                                mov     ebx, [eax]
                                call    [ebx + IDirect3DDevice9.CreatePixelShader]

;                               pop     ebx                             ; ebx = D3DXCreateTextureFromFileInMemoryEx

                                call    dword [edi + (POS_fnc_GetTickCount - POS_fnc_GetTickCount)]
                                mov     [ebp + OldTimeElapsed], eax

; ------------------------------------------------------
; Program loop
MainLoop:                       
                                %ifdef DEBUG
						        push	PM_REMOVE
						        push	0
						        push	0
						        push	0
						        push	Msg
                                call    dword [esi + (API_PeekMessage - API_CreateWindowEx)]
						        test    eax, eax
						        jz      No_Msg
						        push	Msg
                                call    dword [esi + (API_TranslateMessage - API_CreateWindowEx)]
No_Msg:
                                %endif

                                ; ------------------------------------------------------
                                ; Obtain the frames timer
                                call    dword [edi + (POS_fnc_GetTickCount - POS_fnc_GetTickCount)]
                                sub     eax, [ebp + OldTimeElapsed]
                                mov     [ebp + TimeElapsed], eax
                                fild    dword [ebp + TimeElapsed]
                                fstp	dword [ebp + TimeElapsed]
                                lea	    ecx, [ebp + TimeElapsed]

                                ; ------------------------------------------------------
                                ; Display a rectangle
                                push    VK_ESCAPE                       ; GetAsyncKeyState

                                push    0                               ; Present
                                push    0
                                push    0
                                push    0
                                mov     eax, [ebp]
                                push    eax
                                mov     ebx, [eax]

                                push    eax                             ; EndScene

                                push    D3DFVF_XYZRHW_SIZE              ; DrawPrimitiveUP
                                push    BigTriangle
                                push    1
                                push    D3DPT_TRIANGLELIST
                                push    eax

                                push    D3DFVF_XYZRHW                   ; SetFVF
                                push    eax

                                push    dword [ebp + PixelShader]       ; SetPixelShader
                                push    eax

								push    1					            ; (Nbr) SetPixelShaderConstantF
								push    ecx
								push    0					            ; First constant register number
								push    eax

                                push    eax
                                call    [ebx + IDirect3DDevice9.BeginScene]
                                call    [ebx + IDirect3DDevice9.SetPixelShaderConstantF]
                                call    [ebx + IDirect3DDevice9.SetPixelShader]
                                call    [ebx + IDirect3DDevice9.SetFVF]
                                call    [ebx + IDirect3DDevice9.DrawPrimitiveUP]
                                call    [ebx + IDirect3DDevice9.EndScene]
                                call    [ebx + IDirect3DDevice9.Present]
                                call    dword [esi + (API_GetAsyncKeyState - API_CreateWindowEx)]
                                sahf
                                jns     MainLoop
                                call    dword [edi + (POS_fnc_exit - POS_fnc_GetTickCount)]

; ------------------------------------------------------
; Datas
                                %ifdef DEBUG
Msg:                            times   100 db 0
                                %endif

ClassName:                      db      "edi"
ProcedureName:                  db      "t", 0
PShaderProfileName:             db      "ps_3_0", 0

PShader:                        db      "float f;"
                                db      "float _d(float3 c)"
                                db      "{"
                                db      "float sc=2.85;" ; scale darf nicht kleiner 1
                                db      "float de=1;"
                                db      "float fr2=1;" ; farrad*farrad
                                db      "float mr2=.25;" ;minrad*minrad
                                db      "float3 p=0;"
                                db      "int i;"
                                db      "for(i=0;i<8;i++)"
                                db      "{"
                                db      "p=sign(p)*(1-abs(abs(p)-1));"
                                db      "float r2=dot(p,p);"
                                db      "if(r2<mr2)"
                                db      "{"
                                db      "p*=fr2/mr2;"
                                db      "de*=fr2/mr2;"
                                db      "}"
                                db      "else if(r2<fr2)"
                                db      "{"
                                db      "p*=fr2/r2;"
                                db      "de*=fr2/r2;"
                                db      "}"
                                db      "p*=sc;"
                                db      "p+=c;"
                                db      "de*=sc;"
                                db      "de+=1;"
                                db      "}"
                                db      "return(length(p)-sc+1)/de-pow(sc,1-i);"
                                db      "}"
                                db      "float3 _n(float3 p)"
                                db      "{"
                                db      "float dt=.001;"
                                db      "float3 n=float3(_d(p+float3(dt,0,0)),_d(p+float3(0,dt,0)),_d(p+float3(0,0,dt)))-_d(p);"
                                db      "return normalize(n);"
                                db      "}"
                                db      "float4 t(float2 v:VPOS):COLOR"
                                db      "{"
                                db      "float3 d=normalize(float3(v.xy/float2(320,200)-1,1));"
                                db      "float3 sp=float3(sin(f*.0001)*4,0,-cos(f*.000025)*4-1);"
                                db      "float3 p=sp+d*.5;"
                                db      "float k=1;"
                                db      "for(int i=0;i<200&&abs(k)>.00025;i++)"
                                db      "{"
                                db      "k=_d(p);"
                                db      "p+=d*k;"
                                ;db    "p.x=frac((p.x+5)*0.1)/0.1-5;"
                                db      "}"
                                db      "float3 n=_n(p);"
                                db      "float3 l=normalize(float3(.2,1,.3));"
                                db      "float h=dot(n,l)*.5+.5;"
                                db      "float s=pow(saturate(dot(n,normalize(normalize(sp-p)+l))),20);"
                                db      "h*=1.5-length(p-sp);"
                                db      "return float4(.6,.9,1,0)*h+float4(.9,.6,.3,0)*(1-h)*.2+s;"
                                db      "}"
fPShader:

                                ; -------------------------------
table_dlls:                     db      "user32", 0
API_CreateWindowEx:             db      "CreateWindowExA", 0
                                %ifdef DEBUG
API_ShowWindow:                 db      "ShowWindow", 0
                                %else
API_SetCursor:                  db      "SetCursor", 0
                                %endif
API_GetAsyncKeyState:           db      "GetAsyncKeyState", 0
                                %ifdef DEBUG
API_PeekMessage:                db      "PeekMessageA", 0
API_TranslateMessage:           db      "TranslateMessage", 0
                                %endif
                                db      "d3d9", 0
API_Direct3DCreate9:            db      "Direct3DCreate9", 0

Present_Buffer:                 dd      SCREENX                     ; dpBackBufferWidth
                                dd      SCREENY                     ; dpBackBufferHeight
                                dd      SCREENDEPTH                 ; dpBackBufferFormat
                                dd      0                           ; dpBackBufferCount
                                dd      0                           ; dpMultiSampleType
                                dd      0                           ; dpMultiSampleQuality
BigTriangle:                    dd      D3DSWAPEFFECT_DISCARD       ; dpSwapEffect
                                dd      0                           ; dphDeviceWindow
                                ; dpWindowed / Windowed = 1 / Fullscreen = 0
                                %ifdef DEBUG
                                dd      1
                                %else
                                dd      0
                                %endif
                                dd      0                           ; dpEnableAutoDepthStencil
                                dd      2048.0                      ; dpAutoDepthStencilFormat (D3DFMT_D16)
                                dd      0                           ; dpFlags
                                dd      0                           ; dpFullScreen_RefreshRateInHz
                                dd      0                           ; dpFullScreen_PresentationInterval
                                dd      0
                                dd      2048.0

                                ; Note: the packer strips any 0 located
                                ; at the end of the file (including the flt above)
                                align   8
Vars:
; ------------------------------------------------------
