# 📡 Challenge: Sistema tipo Radar con Sensor Ultrasónico y Motor a Pasos

**Institución:** ITESM - Campus Guadalajara  
**Proyecto:** Challenge de Sistemas Embebidos  
**Fecha:** Abril 2026  

---

## 👥 Integrantes del equipo

- Vanessa Sarahí Salazar Ibarra — A01646141  
- Ángeles Araiza García — A00574806  
- Ana Cristina Chávez Acosta — A01742237  

---

## 📌 Descripción

En este challenge se desarrolló un sistema tipo **radar** utilizando la tarjeta **FRDM-KL25Z**, un **sensor ultrasónico** y un **motor a pasos**.

El sistema:

- Barre un ángulo de **0° a 180°**
- Mide distancias en cada posición
- Envía los datos por **UART**
- Visualiza en tiempo real un **mapa polar tipo radar en Python**

---

## 🎯 Objetivo

Diseñar e implementar un sistema capaz de:

- Controlar un motor a pasos para realizar un barrido angular  
- Medir distancias con un sensor ultrasónico  
- Transmitir datos por comunicación serial  
- Visualizar los datos en tiempo real como un radar  

---

## 🧠 Concepto del sistema

El sistema funciona como un radar básico:

1. El motor rota gradualmente  
2. El sensor mide la distancia en cada ángulo  
3. Se envía el par `(ángulo, distancia)`  
4. Python grafica los puntos en coordenadas polares  

---

## 🔧 Componentes utilizados

### Hardware

- FRDM-KL25Z  
- Sensor ultrasónico (HC-SR04 o similar)  
- Motor a pasos  
- Driver de motor  
- Cables de conexión  

### Software

- C (para microcontrolador)  
- Python (visualización)  
- UART (comunicación serial)  
- Matplotlib (gráficas)  

---

## ⚙️ Funcionamiento del sistema

### 🔄 Barrido del radar

- El motor se mueve en pasos discretos  
- Rango: **0 a 530 pasos (~180°)**  
- Al llegar al límite:
  - Cambia de dirección (ida y vuelta)

---

### 📏 Medición de distancia

Se utiliza un sensor ultrasónico:

- Trigger: 10 µs  
- Se mide el tiempo del pulso ECHO  
- Conversión:

```text
Distancia (cm) = tiempo / 58

El sistema envía datos en formato:

posición,distancia

Ejemplo:

120,45

```
0x01, 0x03, 0x02, 0x06,
0x04, 0x0C, 0x08, 0x09
 id="motor_seq"


Esto permite:

- Movimiento más suave  
- Mayor resolución angular  

---

## 🐍 Visualización en Python

El script en Python:

- Lee datos desde el puerto serial  
- Convierte posición → ángulo  
- Grafica en coordenadas polares  

---

### 🔄 Conversión de ángulo

```text
ángulo = (posición / 530) * 180°

     ↑
   (Radar)
  /       \
 •   •      •
      |
``` id="radar_ascii"

---

## 🔄 Flujo del sistema

1. Inicializar GPIO, UART y sensor  
2. Mover motor un paso  
3. Medir distancia  
4. Enviar datos por UART  
5. Repetir proceso  
6. Python recibe y grafica  

---

## ⚡ Configuración importante

### Microcontrolador

- UART: 9600 baud  
- Pines:
  - Motor: PTD0–PTD3  
  - Trigger: PTB0  
  - Echo: PTB1  

### Python

```python
PORT = 'COM4'
BAUD = 9600
MAX_STEPS = 530
``` id="python_config"

---

## 🧪 Aprendizajes clave

- Control de motores a pasos  
- Uso de sensores ultrasónicos  
- Comunicación UART  
- Procesamiento de datos en tiempo real  
- Visualización en Python  
- Integración hardware-software  

---

## 🚀 Posibles mejoras

- 🔥 Radar 360°  
- 📡 Filtrado de ruido  
- 🎯 Detección de objetos  
- 📈 Guardado de datos  
- 🎨 Interfaz gráfica más avanzada  

---

## 📝 Notas adicionales

- El sistema funciona en tiempo real  
- La precisión depende del sensor y temporización  
- El uso de medio paso mejora la resolución  
- Python permite una visualización dinámica y clara  

---
