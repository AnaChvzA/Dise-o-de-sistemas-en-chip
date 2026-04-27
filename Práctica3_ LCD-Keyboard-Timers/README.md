# 📘 Práctica 3 SoC: Interfaz con Keypad, LCD y Temporización

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

En esta práctica se desarrolló un sistema embebido utilizando la tarjeta **FRDM-KL25Z**, el cual integra:

- Entrada mediante **keypad matricial**
- Salida visual mediante **pantalla LCD**
- Control de **LED RGB**
- Uso de **timers e interrupciones**

La práctica se dividió en **dos partes**, donde se fue incrementando la complejidad del sistema.

---

## 🎯 Objetivo

Desarrollar un sistema interactivo capaz de:

- Leer entradas de un keypad  
- Mostrar información en una LCD  
- Implementar lógica de confirmación de usuario  
- Manejar temporización con timers  
- Controlar eventos mediante interrupciones  

---

# 🔹 Parte 1: Selección y Confirmación de Color

## ⚙️ Funcionamiento

En esta primera parte, el sistema permite:

- Detectar teclas del keypad  
- Mostrar en la LCD el color seleccionado (preview)  
- Confirmar la selección con una tecla específica  
- Mantener el color en pantalla durante un tiempo  

---

## 🎮 Lógica de operación

1. El usuario presiona una tecla  
2. Se muestra el color correspondiente en la LCD  
3. Si se presiona la tecla de confirmación:
   - Se mantiene el color en pantalla por 3 segundos  

---

## 🎨 Colores disponibles

Dependiendo de la tecla presionada:

| Tecla | Color |
|------|------|
| 1, 9  | Red |
| 2, 10 | Green |
| 3, 11 | Yellow |
| 4, 12 | Blue |
| 5     | Pink |
| 6, 14 | Cyan |
| 7, 15 | White |
| Otros | Off |

---

## 🖥️ Visualización en LCD

Ejemplo:
Color:
Red


---

## ⚡ Características

- Anti-rebote por software  
- Uso de variable para última selección  
- Interfaz simple e intuitiva  

---

# 🔹 Funcionalidad 2: Temporizador Configurable

## ⚙️ Descripción

El sistema permite ingresar un valor numérico mediante el keypad para configurar un temporizador.

---

## 🔢 Entrada de datos

- Se pueden ingresar valores de **00 a 99**  
- Se capturan hasta **2 dígitos**  
- Se muestran en tiempo real en la LCD  

---

## ▶️ Funcionamiento

1. El usuario ingresa un número  
2. Se muestra en pantalla  
3. Se confirma con una tecla  
4. Se inicia el conteo usando el timer  
5. Al finalizar:
   - Se enciende el LED  

---

## ⏱️ Uso de Timer

Se utiliza el módulo **TPM0 con interrupciones** para:

- Incrementar el contador automáticamente  
- Comparar contra un límite  
- Ejecutar una acción al finalizar  

---

## 💡 Control del LED

- LED apagado durante el conteo  
- LED encendido al finalizar  
- Control mediante GPIO  

---

## 🖥️ Ejemplo en LCD

Tiempo
25


Durante el conteo:


Tiempo
07

---

## ⚡ Optimización de la LCD (Modo 4 bits)

Se utilizó el modo de **4 bits** para reducir el uso de pines GPIO.

### 🧠 Funcionamiento

Cada byte se divide en dos partes (nibbles):
[ D7 D6 D5 D4 ] → [ D3 D2 D1 D0 ]

Esto permite:

- Reducir uso de pines  
- Mantener funcionalidad completa  
- Optimizar recursos del microcontrolador  

---

## 🔄 Flujo General del Sistema

### Selección de color:
1. Leer tecla  
2. Mostrar color  
3. Confirmar  

### Temporizador:
1. Ingresar número  
2. Mostrar en LCD  
3. Confirmar  
4. Iniciar conteo  
5. Activar LED  

---

## 🧪 Aprendizajes Clave

- Manejo de keypad matricial  
- Uso de LCD en modo 4 bits  
- Implementación de timers (TPM0)  
- Uso de interrupciones  
- Diseño de interfaces con usuario  
- Integración de múltiples periféricos  

---

