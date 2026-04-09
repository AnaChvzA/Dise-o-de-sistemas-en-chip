# 📘 Práctica 1 SoC: Control de LED con Interfaz

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

Esta práctica consiste en el diseño e implementación de un sistema embebido utilizando la tarjeta **KL25**, el cual permite controlar un **LED RGB** mediante la interacción del usuario con un **keypad**, mostrando un menú en una **pantalla LCD**.

El sistema integra hardware y software para ofrecer una interfaz sencilla e interactiva.

---

## 🎯 Objetivo

Desarrollar un sistema embebido capaz de:

- Seleccionar distintos colores en un LED RGB  
- Navegar mediante un keypad  
- Visualizar un menú en una pantalla LCD  

---

## ⚙️ Funcionamiento General

El sistema realiza las siguientes funciones:

- Despliega un menú en la pantalla LCD  
- Detecta la entrada del usuario a través del keypad  
- Cambia el color del LED en tiempo real según la selección  

---

## 🔌 Entradas y Salidas

| Tipo     | Dispositivo |
|----------|------------|
| Entrada  | Keypad     |
| Salida   | LCD, LED RGB |

---

## 🧩 Requerimientos del Sistema

- Implementar al menos **8 colores distintos**  
- Desplegar un menú funcional en la LCD  
- Detectar correctamente las entradas del keypad  
- Controlar el LED RGB mediante GPIO  

---

## 🎨 Colores Implementados

1- 🔴 Rojo  
2- 🟢 Verde  
3- 🔵 Azul  
4- 🟡 Amarillo    
5- 🟣 Magenta  
6- 🔷 Cian
7- ⚪ Blanco  
8- ⚫ Apagado  

---

## ⚠️ Restricción Principal

El sistema debe utilizar un máximo de **16 pines GPIO**, lo cual implica optimización en:

- Conexión de periféricos  
- Uso eficiente de hardware  
- Diseño del sistema  

---

## ⚡ Optimización de la Interfaz LCD (Modo 4 bits)

Para cumplir con la restricción de pines GPIO, se implementó la comunicación con la LCD en **modo de 4 bits**, en lugar del modo tradicional de 8 bits.

### 🔍 Problema

Una interfaz LCD en modo de 8 bits requiere:

- 8 líneas de datos (D0–D7)  
- Líneas de control adicionales (RS, E, RW)

Esto incrementa significativamente el uso de pines GPIO.

### 💡 Solución

Se utilizó únicamente:

- Los **4 bits más significativos (D4–D7)**  
- Comunicación en **dos pasos (nibbles)** por cada dato

### 🧠 ¿Cómo funciona?

Cada byte (8 bits) se divide en dos partes:

1. **Nibble alto (bits más significativos)**  
2. **Nibble bajo (bits menos significativos)**  

Y se envían en este orden:
[ D7 D6 D5 D4 ] → [ D3 D2 D1 D0 ]

### 🔄 Proceso de envío

1. Se envía el nibble alto  
2. Se genera un pulso en la señal **Enable (E)**  
3. Se envía el nibble bajo  
4. Se genera otro pulso en **Enable (E)**  

### ✅ Ventajas

- Reduce el uso de pines GPIO de **8 a 4 líneas de datos**  
- Permite cumplir con la restricción de hardware  
- Mantiene funcionalidad completa de la LCD  

### ⚠️ Consideraciones

- La comunicación es ligeramente más lenta (doble envío)  
- Se requiere una correcta sincronización de señales  
- Es necesario inicializar la LCD específicamente en modo 4 bits  

---

## 🏗️ Arquitectura del Sistema

### 🔧 Hardware

- Tarjeta KL25  
- Pantalla LCD  
- Keypad matricial  
- LED RGB  

### 💻 Software

- Driver GPIO  
- Driver LCD  
- Módulo de lectura de keypad  
- Lógica de control del menú  

---

## 🧭 Diseño del Menú

El menú permite al usuario:

- Navegar entre opciones  
- Seleccionar un color  
- Confirmar la selección mediante el keypad  


---

## 🔄 Flujo del Sistema

1. Inicializar periféricos  
2. Mostrar menú en LCD  
3. Esperar entrada del usuario  
4. Leer keypad  
5. Procesar selección  
6. Cambiar color del LED  
7. Actualizar pantalla  

---

## 📦 Entrega Final

### 👥 Modalidad

Trabajo en equipo  

### 📄 Entregables

- Código funcional  
- Diagrama de flujo  
- Explicación del uso de pines  
- Demostración del sistema  

---

## 📝 Criterios de Evaluación

- ✔️ Funcionamiento correcto del sistema  
- ✔️ Optimización en el uso de pines  
- ✔️ Claridad en el diseño  
- ✔️ Trabajo en equipo  

---

## 🚀 Notas adicionales

- El sistema está diseñado para operar en tiempo real  
- Se recomienda modularizar el código para facilitar pruebas y mantenimiento  
- La correcta integración de hardware y software es clave para el funcionamiento  

---
