# RISC-V Pipelined Processor — RV32I

Implementación en Verilog de un procesador RISC-V de 5 etapas con forwarding, detección de hazards y soporte para un subconjunto de instrucciones RV32I.

---
## Equipo:
- Vanessa Sarahí Salazar Ibarra — A01646141  
- Ángeles Araiza García — A00574806  
- Ana Cristina Chávez Acosta — A01742237  

## Arquitectura

El pipeline consta de 5 etapas clásicas:

```
IF  →  ID  →  EX  →  MEM  →  WB
```

| Etapa | Descripción |
|---|---|
| **IF** | Fetch de instrucción desde memoria, incremento de PC |
| **ID** | Decodificación, lectura del Register File, generación de inmediatos |
| **EX** | Ejecución en ALU, cálculo de dirección de branch |
| **MEM** | Acceso a memoria de datos (load/store) |
| **WB** | Escritura de resultado en Register File |

---

## Instrucciones soportadas

| Tipo | Instrucciones |
|---|---|
| R-Type | `add`, `sub`, `and`, `or`, `slt` |
| I-Type | `addi`, `lw` |
| S-Type | `sw` |
| B-Type | `beq` |
| J-Type | `jal` |

---

## Estructura de módulos

```
Pipelined.v               ← Top-level
├── ProgramCounter.v       ← PC con soporte de stall
├── InstructionMemory.v    ← Memoria de instrucciones (readmemh)
├── IF_ID.v                ← Registro de pipeline IF/ID
├── RegisterFile.v         ← 32 registros x 32 bits, write-first
├── Immediate.v            ← Generador de inmediatos (I/S/B/J)
├── MainDecoder.v          ← Decodificador principal de control
├── ID_EX.v                ← Registro de pipeline ID/EX
├── ALUControl.v           ← Control de operación ALU
├── ALU.v                  ← ALU (add/sub/and/or/slt)
├── ForwardingUnit.v       ← Forwarding EX→EX y MEM→EX
├── HazardUnit.v           ← Detección de load-use y control hazards
├── EX_MEM.v               ← Registro de pipeline EX/MEM
├── DataMemory.v           ← Memoria de datos
├── MEM_WB.v               ← Registro de pipeline MEM/WB
├── Adder.v                ← Sumador para PC+4 y branch target
└── mux.v                  ← Mux parametrizable N entradas x 32 bits
```

---

## Manejo de hazards

### Data Hazards — ForwardingUnit
Detecta dependencias RAW y selecciona la fuente correcta para SrcA y SrcB:

| `ForwardAE/BE` | Fuente |
|---|---|
| `00` | Register File (RD1E / RD2E) |
| `01` | Resultado de WB (ResultW) |
| `10` | Resultado de MEM (ALUResultM) |

### Load-Use Hazard — HazardUnit
Cuando una instrucción `lw` es seguida inmediatamente por una instrucción que usa el registro cargado, la unidad inserta una burbuja (stall) automáticamente:
- `StallF = 1`
- `StallD = 1`
- `FlushE = 1`

### Control Hazards — HazardUnit
Al detectar un branch tomado o un jump (`PCSrcE = 1`), se limpian las etapas IF e ID:
- `FlushD = 1`
- `FlushE = 1`

### WB → ID (mismo ciclo) — RegisterFile write-first
El Register File implementa forwarding interno: si el registro que se está escribiendo en WB coincide con un operando que se está leyendo en ID en el mismo ciclo, se devuelve el valor nuevo directamente sin necesidad de stall adicional.

```verilog
else if (RegWrite && (rd == rs1) && (rd != 5'd0))
    rd1 = wd;
```

---

## Programa de prueba

El siguiente programa valida la operación básica del pipeline y el forwarding:

```asm
addi x1, x0, 5      # x1 = 5
addi x2, x0, 7      # x2 = 7
add  x3, x1, x2     # x3 = 12  (forwarding MEM→EX)
sub  x4, x3, x1     # x4 = 7   (forwarding EX→EX)
or   x5, x1, x4     # x5 = 7   (forwarding EX→EX)
and  x6, x1, x4     # x6 = 5   (forwarding EX→EX)
```

**Resultados esperados:**

| Registro | Valor |
|---|---|
| x1 | 5 |
| x2 | 7 |
| x3 | 12 |
| x4 | 7 |
| x5 | 7 |
| x6 | 5 |

Archivo `InstrMem.hex`:
```
00500093
00700113
002081B3
40118233
0020E2B3
0020F333
00000013
00000013
00000013
00000013
```

---

## Simulación

El proyecto fue desarrollado y verificado en **Questa Altera Starter FPGA Edition** (ModelSim compatible).

Para correr la simulación:

1. Compilar todos los módulos `.v` en orden o usando el script `.do` generado por Quartus.
2. Asegurarse de que `InstrMem.hex` esté en el directorio de trabajo de la simulación.
3. Correr el testbench `Pipelined_tb.v`.
4. La simulación corre por `500ns` e imprime los resultados de los registros al final.

---

## Notas de implementación

- El mux parametrizable (`mux.v`) usa `mux_in[sel*32 +: 32]` para selección por índice, por lo que el orden de concatenación en `mux_in` importa: el primer elemento en la concatenación (`{}`) ocupa los bits más altos y corresponde al selector más alto.
- La memoria de instrucciones inicializa todas las posiciones a NOP (`32'h00000013`) antes de cargar el `.hex`, evitando valores `x` cuando el PC sale del rango del programa.
- El Register File implementa escritura síncrona (flanco positivo) y lectura asíncrona con forwarding interno write-first.

---

## Herramientas

- **Lenguaje:** Verilog (IEEE 1364-2001)
- **Simulador:** Questa Altera Starter FPGA Edition 2025.2
- **ISA:** RISC-V RV32I (subconjunto)
