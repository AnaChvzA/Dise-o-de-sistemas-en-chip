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
