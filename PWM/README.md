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
