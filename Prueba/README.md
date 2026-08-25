# 📘 Práctica 1: UART

**Institución:** ITESM - Campus Guadalajara  
**Fecha:** Agosto 2026  

---

## 👥 Integrantes del equipo

**Nombres:**
- Vanessa Sarahí Salazar Ibarra  
- Ángeles Araiza García  
- Ana Cristina Chávez Acosta  

**Matrículas:**
- A01646141  
- A00574806  
- A01742237  

---

# Parte 1 - Teoría: Cálculo de la Tasa de Baudios UART

## Objetivo

La primera parte de la práctica consiste en realizar los cálculos necesarios para configurar correctamente la comunicación **UART0** del microcontrolador **KL25Z**.

Se debe calcular el valor del **Serial Baud Rate (SBR)** para diferentes tasas de transmisión estándar y posteriormente determinar:

- SBR en decimal.
- SBR en hexadecimal.
- Valor del registro `BDH`.
- Valor del registro `BDL`.
- Tasa de baudios real obtenida.
- Porcentaje de error respecto a la tasa de baudios deseada.

Estos cálculos permiten seleccionar correctamente los valores que posteriormente serán utilizados en la configuración del periférico UART.

---

# Parámetros utilizados

Para todos los cálculos se utilizan los siguientes valores:

```text
Frecuencia del reloj = 41.94 MHz
OSR = 15
```

Fórmula de la tasa de baudios
```text
                 Clock Source
Baud Rate = -----------------------------
              (OSR + 1) × SBR
```
Donde:
`Baud Rate` = tasa de transmisión deseada.
`Clock Source` = frecuencia del reloj utilizado por UART.
`OSR` = Oversampling Ratio.
`SBR` = Serial Baud Rate.

En nuestro caso:
Clock Source = 41.94 MHz
OSR + 1 = 16


Cálculo del SBR
Despejando SBR de la ecuación anterior:
```text
                     Clock Source
SBR = -----------------------------------------
          (OSR + 1) × Baud Rate
```
# Tabla de Resultados:

| Tasa de baudios | SBR (decimal) | SBR (hexadecimal) |   BDH  |   BDL  | Baudios reales |  Error |
| :-------------: | :-----------: | :---------------: | :----: | :----: | -------------: | :----: |
|       4800      |      546      |      `0x0222`     | `0x02` | `0x22` |        4800.82 | 0.017% |
|       9600      |      273      |      `0x0111`     | `0x01` | `0x11` |        9601.65 | 0.017% |
|      19200      |      137      |      `0x0089`     | `0x00` | `0x89` |       19133.21 | 0.347% |
|      38400      |       68      |      `0x0044`     | `0x00` | `0x44` |       38547.79 | 0.384% |
|      115200     |       23      |      `0x0017`     | `0x00` | `0x17` |      113967.39 | 1.069% |
