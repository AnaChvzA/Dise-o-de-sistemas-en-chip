
# 📘 Práctica 5 SoC: Medición de Luminosidad con ADC y Visualización en LCD

**Institución:** ITESM - Campus Guadalajara  
**Fecha:** Abril 2026  

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

## 📌 Descripción

En esta práctica se implementa un sistema embebido en la tarjeta **FRDM-KL25Z** que realiza la lectura de una señal analógica proveniente de un sensor de luz mediante el **ADC (Convertidor Analógico-Digital)**.

El sistema procesa la señal, calcula un porcentaje de luminosidad y despliega el resultado en una **pantalla LCD**, además de controlar un **LED** dependiendo del nivel de iluminación.

---

## 🎯 Objetivo

Desarrollar un sistema capaz de:

- Leer una señal analógica usando el ADC  
- Procesar la señal para obtener un valor de luminosidad  
- Mostrar el resultado en una LCD  
- Controlar un LED en función de la iluminación  
- Implementar temporización mediante interrupciones  

---

## ⚙️ Funcionamiento General

El sistema realiza las siguientes operaciones:

1. Lee el valor analógico desde el pin **PTE20 (ADC0)**  
2. Convierte la señal a un valor digital de 16 bits  
3. Calcula el porcentaje de luminosidad  
4. Muestra el valor en la LCD  
5. Enciende un LED si la iluminación es baja  
6. Apaga el LED automáticamente después de un tiempo usando un timer  

---

## 🔌 Entradas y Salidas

| Tipo     | Dispositivo |
|----------|------------|
| Entrada  | Sensor de luz (analógico en PTE20) |
| Salida   | LCD, LED (PTD1) |

---

## 🧩 Componentes Utilizados

### 🔧 Hardware

- Tarjeta FRDM-KL25Z  
- Sensor de luz (entrada analógica)  
- Pantalla LCD (modo 4 bits)  
- LED indicador  

### 💻 Software

- Módulo ADC (ADC0)  
- Driver LCD (modo 4 bits)  
- Timer TPM0 con interrupciones  
- Lógica de control del sistema  

---

## 📊 Conversión de Señal

El ADC trabaja con:

- Resolución: **16 bits (0 – 65535)**  
- Referencia: **3.3V**  
- Promediado: **32 muestras (reducción de ruido)**  

### 📐 Cálculo de luminosidad

```text
Luminosidad (%) = (resultado_ADC * 100) / 65535
