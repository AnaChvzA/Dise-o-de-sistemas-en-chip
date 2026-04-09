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

- 🔴 Rojo  
- 🟢 Verde  
- 🔵 Azul  
- 🟡 Amarillo  
- 🔷 Cian  
- 🟣 Magenta  
- ⚪ Blanco  
- ⚫ Apagado  

---

## ⚠️ Restricción Principal

El sistema debe utilizar un máximo de **16 pines GPIO**, lo cual implica optimización en:

- Conexión de periféricos  
- Uso eficiente de hardware  
- Diseño del sistema  

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

### 📋 Ejemplo de menú
