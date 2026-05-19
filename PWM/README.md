# 📘 Práctica: PWM con TPM0 y Control de Intensidad LED

**Institución:** ITESM - Campus Guadalajara  
**Curso:** Sistemas en Chip (SoC)  
**Fecha:** 2026  

---

## 👥 Integrantes del equipo

- Vanessa Sarahí Salazar Ibarra — A01646141  
- Ángeles Araiza García — A00574806  
- Ana Cristina Chávez Acosta — A01742237  

---

# 📌 Descripción

En esta práctica se implementó el uso de señales **PWM (Pulse Width Modulation)** utilizando el módulo **TPM0** de la tarjeta **FRDM-KL25Z**.

La práctica se divide en dos partes:

- Generación de señales PWM con distintos duty cycles
- Variación progresiva del duty cycle para controlar la intensidad de un LED

---

# 🎯 Objetivo

Desarrollar un sistema capaz de:

- Generar señales PWM usando TPM0
- Modificar el duty cycle
- Controlar la intensidad luminosa de un LED
- Comprender la relación entre duty cycle y potencia entregada

---

# 🧠 Concepto principal

PWM (Pulse Width Modulation) permite controlar la cantidad de energía entregada a una carga variando el tiempo en que la señal permanece activa.

---

# ⚡ Conceptos importantes

## 🟢 Frecuencia PWM

La frecuencia define cuántos ciclos PWM ocurren por segundo.

En esta práctica:

```text
Frecuencia = 60 Hz
```


## Duty Cycle

El duty cycle representa el porcentaje de tiempo que la señal permanece activa dentro de un período.

# 📐 Fórmula
Duty Cycle (%) = (CnV / MOD) × 100

## 🔧 Componentes utilizados
# Hardware
- FRDM-KL25Z
- LED integrado (PTD1)
- Timer TPM0
- Software
- C
- TPM0 PWM
- GPIO
- Delay por software

## Parte 1: PWM con duty cycles fijos
# ⚙️ Descripción

Se configuró TPM0 para generar una señal PWM de:

60 Hz

con diferentes duty cycles:

- 0%
- 25%
- 50%
- 75%
- 100%

# ⚙️ Configuración del PWM
Clock del TPM0
SIM->SOPT2 |= 0x01000000;

Se utiliza:

MCGFLLCLK = 41.94 MHz
Prescaler
División entre 16
Registro MOD
TPM0->MOD = 43702;

Este valor genera una frecuencia de:

60 Hz

# 📊 Cálculo del Duty Cycle
Fórmula utilizada
CnV = DutyCycle × MOD

📋 Valores calculados

- Duty Cycle	Valor CnV
- 0%	            0
- 25%	          10925
- 50%	          21851
- 75%	          32776
- 100%	        43702

# 💡 Comportamiento del LED

El LED de la FRDM-KL25Z es:

Activo en bajo (Active Low)

0%	Encendido máximo
100%	Apagado

## Parte 2: PWM dinámico
# ⚙️ Descripción

En esta parte se implementó un PWM cuyo duty cycle cambia automáticamente.

El valor del registro:
CnV
se incrementa continuamente para modificar la intensidad del LED.

# 🔄 Funcionamiento
Cada:
20 ms
el duty cycle aumenta:
1%
# 📐 Incremento aplicado
437 ≈ 1% de 43702
💡 Efecto observado

Debido a que el LED es activo en bajo:

Mayor duty cycle → menor intensidad
Menor duty cycle → mayor intensidad

Esto genera un efecto visual de:

Fade In / Fade Out
# ⚙️ Configuración TPM0
- Modo PWM
- TPM0->CONTROLS[1].CnSC = 0x20 | 0x08;

Configuración:

Edge-aligned PWM
Pulse High

# 🔄 Flujo del sistema
Parte 1
Configurar TPM0
Definir MOD
Calcular CnV
Generar PWM
Observar intensidad LED
Parte 2
Inicializar PWM
Incrementar CnV
Actualizar duty cycle
Esperar 20 ms
Repetir proceso

