# 📘 Práctica 4 SoC: Interrupciones y Control de Eventos

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

En esta práctica se implementa el uso de **interrupciones externas y temporizadores** en la tarjeta **FRDM-KL25Z**, evolucionando desde eventos simples con botones hasta un sistema interactivo completo con:

- Interrupciones por hardware (PORTA)
- Manejo de múltiples eventos
- Integración con LCD y keypad
- Control de ejecución (pausa/reanudación)

La práctica se divide en **tres partes progresivas**, cada una agregando complejidad al sistema.

---

## 🎯 Objetivo

Desarrollar sistemas embebidos capaces de:

- Detectar eventos mediante interrupciones externas  
- Manejar múltiples fuentes de interrupción  
- Integrar timers con interrupciones  
- Controlar la ejecución de procesos (pause/resume)  
- Integrar interfaz de usuario (LCD + keypad)  

---

## 🔧 Componentes Utilizados

### Hardware

- FRDM-KL25Z  
- Push buttons (PTA1, PTA2)  
- LED RGB (PTB18, PTB19, PTD1)  
- Keypad matricial  
- Pantalla LCD (modo 4 bits)  

### Software

- GPIO  
- Interrupciones PORTA  
- Timer TPM0  
- Interrupciones TPM0  
- Driver LCD  
- Lectura de keypad  

---

# 🔹 Parte 1: Interrupción básica por botón

## ⚙️ Descripción

Se implementa una interrupción externa utilizando botones conectados a:

- **PTA1**
- **PTA2**

---

## 🔄 Funcionamiento

- El sistema principal:
  - Hace parpadear el **LED rojo continuamente**
- Cuando se presiona un botón:
  - Se genera una interrupción
  - El **LED verde parpadea 3 veces**

---

## 🧠 Conceptos clave

- Interrupciones por flanco de bajada  
- Uso de `PORTA_IRQHandler`  
- Manejo básico de flags (`ISFR`)  

---

## 💡 Comportamiento

| Evento | Acción |
|------|--------|
| Sistema activo | LED rojo parpadea |
| Botón presionado | LED verde parpadea 3 veces |

---

# 🔹 Parte 2: Múltiples interrupciones en un solo puerto

## ⚙️ Descripción

Se mejora el sistema para manejar **múltiples fuentes de interrupción dentro del mismo puerto (PORTA)**.

---

## 🔄 Funcionamiento

- Se detecta qué botón fue presionado:
  - **PTA1 → LED verde**
  - **PTA2 → LED azul**

Cada uno ejecuta una acción distinta.

---

## 💡 Comportamiento

| Botón | LED activado |
|------|-------------|
| PTA1 | Verde |
| PTA2 | Azul |

Ambos parpadean 3 veces.

---

## 🧠 Conceptos clave

- Lectura de múltiples flags en `ISFR`  
- Manejo simultáneo de interrupciones  
- Uso de ciclos `while` para atender múltiples eventos  

---

# 🔹 Parte 3: Sistema interactivo con pausa y reanudación

## ⚙️ Descripción

Se integra todo lo aprendido en un sistema completo que incluye:

- Keypad (entrada)
- LCD (salida)
- Timer con interrupciones
- Botón externo para control de estado

---

## 🔢 Funcionalidad principal

El sistema permite:

1. Ingresar un número (00–99) mediante el keypad  
2. Mostrarlo en la LCD  
3. Iniciar un contador al confirmar  
4. Encender un LED al finalizar  

---

## ⏸️ Nueva funcionalidad: Pausa

Se agrega control mediante interrupción externa:

- Botón en **PTA1**:
  - **Pausa el contador**
  - Muestra `"PAUSED"` en la LCD  

---

## ▶️ Reanudación

- Se usa el keypad:
  - Tecla `*` (TECLA_REANUDAR)
  - Permite continuar el conteo  

---

## 🖥️ Visualización en LCD

### Ejecución normal
Tiempo
25


### Durante conteo


Tiempo
07


### Pausado


PAUSED


---

## ⏱️ Uso del Timer (TPM0)

- Incrementa el contador automáticamente  
- Genera interrupciones periódicas  
- Controla el fin del conteo  

---

## 💡 Control del LED

- LED apagado durante conteo  
- LED encendido al finalizar  

---

## 🧠 Conceptos clave

- Interrupciones anidadas (PORTA + TPM0)  
- Control de estados (`contar`, `pausado`)  
- Sincronización entre hardware y software  

---

## ⚡ Optimización de la LCD (Modo 4 bits)

Se utiliza el modo de **4 bits** para reducir el uso de GPIO.
[ D7 D6 D5 D4 ] → [ D3 D2 D1 D0 ]


Ventajas:

- Menor uso de pines  
- Sistema más eficiente  
- Compatible con hardware limitado  

---

## 🔄 Flujo General del Sistema

### Parte 1
1. Ejecutar programa principal  
2. Detectar botón  
3. Ejecutar interrupción  

### Parte 2
1. Detectar múltiples botones  
2. Identificar fuente  
3. Ejecutar acción correspondiente  

### Parte 3
1. Ingresar número  
2. Confirmar  
3. Iniciar conteo  
4. Pausar (botón)  
5. Reanudar (keypad)  
6. Finalizar y activar LED  

---

## 🧪 Aprendizajes Clave

- Uso de interrupciones externas  
- Manejo de múltiples eventos  
- Integración de timers con interrupciones  
- Control de estados en sistemas embebidos  
- Diseño de interfaces interactivas  
- Sincronización hardware-software  

---
