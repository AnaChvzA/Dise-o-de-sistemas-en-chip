# 📘 Práctica: Medición de Frecuencia con Input Capture y LCD

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

En esta práctica se implementó un sistema de medición de frecuencia utilizando la tarjeta **FRDM-KL25Z** y el módulo **TPM0 en modo Input Capture**.

El sistema:

- Detecta señales externas
- Calcula el período entre flancos positivos
- Obtiene la frecuencia de la señal
- Muestra el resultado en una pantalla LCD

---

# 🎯 Objetivo

Desarrollar un sistema capaz de:

- Capturar eventos digitales mediante Input Capture
- Medir el período de una señal
- Calcular la frecuencia en Hertz
- Visualizar datos en tiempo real en una LCD

---

# 🧠 Concepto principal

La práctica utiliza el módulo **TPM0 (Timer/PWM Module)** en modo **Input Capture**.

Cuando ocurre un flanco positivo:

1. El timer almacena automáticamente el valor del contador
2. Se calcula la diferencia entre capturas consecutivas
3. Se obtiene el período
4. Se calcula la frecuencia

---

# 🔧 Componentes utilizados

## Hardware

- FRDM-KL25Z
- Pantalla LCD 16x2
- Generador de señal / señal externa
- Cables de conexión

---

## Software

- C
- TPM0 Input Capture
- SysTick
- GPIO
- Driver LCD

---

# ⚙️ Funcionamiento del sistema

## 🔄 Captura de señal

El pin:

```text
PTC1 → TPM0_CH0
```
se configura como entrada de captura.

Cada vez que ocurre un flanco positivo:

El valor del timer se guarda automáticamente
  Se activa una bandera (CHF)
  Medición del período

El sistema almacena:

Captura actual
Captura anterior

Luego calcula:

Periodo = CapturaActual - CapturaAnterior


## 📐 Cálculo de frecuencia

La frecuencia se calcula mediante:

Frecuencia = Clock / Periodo

En este caso:

Frecuencia = 163828 / periodo

## 🖥️ Visualización en LCD

La frecuencia se muestra continuamente en la pantalla:

Freq:120 Hz

La actualización ocurre aproximadamente cada:

300 ms


## ⚙️ Configuración del TPM0
Fuente de reloj
SIM->SOPT2 |= SIM_SOPT2_TPMSRC(1);
Prescaler
TPM_SC_PS(7)

Prescaler:

128
Flanco detectado
TPM_CnSC_ELSA_MASK

Detecta:

Flanco positivo

La LCD se utiliza en modo de 4 bits para reducir el número de pines utilizados.

# Funcionamiento

Cada byte se divide en dos nibbles:

[ D7 D6 D5 D4 ] → [ D3 D2 D1 D0 ]

🔄 Flujo General del Sistema
Inicializar LCD
Configurar TPM0 Input Capture
Esperar flanco positivo
Capturar tiempo
Calcular período
Obtener frecuencia
Mostrar resultado en LCD
Repetir proceso

📊 Arquitectura del sistema
Señal externa
      ↓
Input Capture (TPM0)
      ↓
Cálculo de período
      ↓
Cálculo de frecuencia
      ↓
LCD 16x2
