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
```

Fórmula de la tasa de baudios
```text
                 Clock Source
Baud Rate = -----------------------------
              (OSR + 1) × SBR
```
Donde:
`Baud Rate` = tasa de transmisión deseada.
`Clock Source` = frecuencia del reloj utilizado por UART.
`OSR` = Oversampling Ratio.
`SBR` = Serial Baud Rate.

En nuestro caso:
Clock Source = 41.94 MHz
OSR + 1 = 16


Cálculo del SBR
Despejando SBR de la ecuación anterior:
```text
                     Clock Source
SBR = -----------------------------------------
          (OSR + 1) × Baud Rate
```
# Tabla de Resultados:

| Tasa de baudios | SBR (decimal) | SBR (hexadecimal) |   BDH  |   BDL  | Baudios reales |  Error |
| :-------------: | :-----------: | :---------------: | :----: | :----: | -------------: | :----: |
|       4800      |      546      |      `0x0222`     | `0x02` | `0x22` |        4800.82 | 0.017% |
|       9600      |      273      |      `0x0111`     | `0x01` | `0x11` |        9601.65 | 0.017% |
|      19200      |      137      |      `0x0089`     | `0x00` | `0x89` |       19133.21 | 0.347% |
|      38400      |       68      |      `0x0044`     | `0x00` | `0x44` |       38547.79 | 0.384% |
|      115200     |       23      |      `0x0017`     | `0x00` | `0x17` |      113967.39 | 1.069% |


# Parte 2 — Ejemplos UART

## Descripción

En esta parte de la práctica se implementaron los ejemplos de **transmisión y recepción UART** vistos en clase, utilizando la tarjeta **FRDM-KL25Z**.
El objetivo es verificar la comunicación serial entre la **KL25Z** y una computadora mediante un **terminal serial**, demostrando tanto el envío como la recepción de datos.

---

## Objetivos

* Implementar la comunicación **UART** en la KL25Z.
* Realizar transmisión de datos desde la **KL25Z hacia la computadora**.
* Realizar recepción de datos desde la **computadora hacia la KL25Z**.
* Verificar el funcionamiento de la comunicación mediante un **terminal serial**.

---

## Comunicación UART
La comunicación se realiza mediante dos direcciones:
```text
KL25Z  ───────────►  Computadora
       Transmisión

KL25Z  ◄───────────  Computadora
        Recepción
```

UART (*Universal Asynchronous Receiver-Transmitter*) permite transmitir y recibir información de manera serial sin utilizar una señal de reloj compartida.

---

## 1. Transmisión: KL25Z → Computadora

En este ejemplo, la **KL25Z transmite información hacia la computadora** mediante UART.

El programa envía datos a través del puerto UART y estos pueden visualizarse en el terminal serial de la computadora.

### Funcionamiento

```text
┌──────────────┐       UART       ┌──────────────┐
│    KL25Z     │ ───────────────► │ Computadora  │
│              │                  │              │
│  Transmisor  │                  │ Terminal     │
└──────────────┘                  └──────────────┘
```

### Verificación

Para comprobar la transmisión:

1. Se conecta la KL25Z a la computadora.
2. Se configura el puerto serial correspondiente.
3. Se abre un terminal serial.
4. Se ejecuta el programa en la KL25Z.
5. Se observan en el terminal los datos enviados por la tarjeta.

Si la comunicación funciona correctamente, los mensajes enviados por la KL25Z aparecen en el terminal serial.

---

## 2. Recepción: Computadora → KL25Z

En este ejemplo, la **computadora envía información hacia la KL25Z** mediante UART.

La KL25Z recibe los caracteres enviados desde el terminal serial y puede procesarlos de acuerdo con el programa implementado.

### Funcionamiento

```text
┌──────────────┐       UART       ┌──────────────┐
│ Computadora  │ ───────────────► │    KL25Z     │
│              │                  │              │
│ Terminal     │                  │  Receptor    │
└──────────────┘                  └──────────────┘
```

### Verificación

Para comprobar la recepción:

1. Se conecta la KL25Z a la computadora.
2. Se configura el puerto serial.
3. Se abre el terminal serial.
4. Se ejecuta el programa en la KL25Z.
5. Se escriben caracteres desde el terminal.
6. La KL25Z recibe y procesa los datos enviados.

La recepción correcta se confirma cuando la KL25Z responde o realiza la acción programada a partir de los datos recibidos.

---

## Resultados

Se verificaron las dos direcciones de comunicación UART:

| Comunicación | Dirección           | Resultado  |
| ------------ | ------------------- | ---------- |
| Transmisión  | KL25Z → Computadora | ✅ Correcta |
| Recepción    | Computadora → KL25Z | ✅ Correcta |

La prueba permitió comprobar que la **KL25Z puede transmitir y recibir datos mediante UART**, estableciendo una comunicación serial bidireccional con la computadora.

---

# Parte 3 — Sistema de Control y Monitoreo mediante UART

## Descripción

En esta parte de la práctica se desarrolló un **sistema de control y monitoreo para la tarjeta FRDM-KL25Z**, utilizando la comunicación **UART** como interfaz entre la tarjeta y la computadora.

El sistema presenta un menú interactivo en un terminal serial, desde el cual el usuario puede seleccionar diferentes funciones de la tarjeta:

* Control del LED RGB.
* Lectura del ADC.
* Monitoreo de un teclado matricial 4×4.
* Monitoreo de dos botones.

La comunicación entre la **KL25Z y la computadora** se realiza mediante **UART0 a 57600 baudios**, utilizando un terminal serial como interfaz de usuario.

---

## Objetivos

* Integrar diferentes periféricos de la KL25Z en un solo programa.
* Utilizar UART como interfaz de comunicación con la computadora.
* Controlar el LED RGB desde el terminal serial.
* Leer el valor de un ADC y convertirlo a voltaje.
* Detectar las teclas presionadas en un keypad 4×4.
* Detectar cambios de estado en dos botones.
* Implementar un menú interactivo mediante comandos UART.
* Utilizar SysTick para realizar mediciones periódicas de tiempo.

---

## Diagrama general del sistema

```text
                         ┌─────────────────────┐
                         │     Computadora     │
                         │                     │
                         │    Terminal Serial │
                         └──────────┬──────────┘
                                    │
                               UART 57600
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │       KL25Z         │
                         │                     │
                         │      UART0          │
                         └──────────┬──────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
              ▼                     ▼                     ▼
        ┌───────────┐         ┌───────────┐         ┌───────────┐
        │  LED RGB  │         │    ADC    │         │  Keypad   │
        │           │         │           │         │    4×4    │
        └───────────┘         └───────────┘         └───────────┘
                                   
                                    │
                                    ▼
                              ┌───────────┐
                              │  Botones  │
                              │  Button 1 │
                              │  Button 2 │
                              └───────────┘
```

---

## Periféricos utilizados

| Periférico      | Pines                  | Función             |
| --------------- | ---------------------- | ------------------- |
| LED rojo        | PTB18                  | Control de LED RGB  |
| LED verde       | PTB19                  | Control de LED RGB  |
| LED azul        | PTD1                   | Control de LED RGB  |
| Button 1        | PTA4                   | Detección de botón  |
| Button 2        | PTC3                   | Detección de botón  |
| Keypad filas    | PTE0–PTE3              | Escaneo de filas    |
| Keypad columnas | PTE4, PTE5, PTD6, PTD7 | Lectura de columnas |
| ADC             | PTE20 / ADC0_SE0       | Lectura analógica   |
| UART TX         | PTA2                   | Transmisión         |
| UART RX         | PTA1                   | Recepción           |

---

# Menú principal

Al iniciar el programa, la KL25Z envía mediante UART un menú al terminal serial:

```text
*================================*
*      KL25Z UART SYSTEM         *
*================================*
*Commands:                       *
*L - LED control                 *
*A - Read ADC                    *
*K - Read keypad                 *
*B - Button status               *
*================================*
Please select an option:
```

El usuario puede seleccionar una opción escribiendo el comando correspondiente.

| Comando | Función               |
| ------- | --------------------- |
| `L`     | Control del LED RGB   |
| `A`     | Lectura del ADC       |
| `K`     | Lectura del keypad    |
| `B`     | Estado de los botones |

Los comandos pueden introducirse utilizando letras mayúsculas o minúsculas.

---

# 1. Control del LED RGB

La opción `L` permite controlar el LED RGB integrado en la KL25Z.

Al seleccionar esta opción se muestra:

```text
LED control

1 - Red
2 - Green
3 - Blue
0 - All OFF
Q - Return to Main Menu

Please select an option:
```

### Comandos

| Comando | Acción                    |
| ------- | ------------------------- |
| `1`     | Enciende LED rojo         |
| `2`     | Enciende LED verde        |
| `3`     | Enciende LED azul         |
| `0`     | Apaga todos los LEDs      |
| `Q`     | Regresa al menú principal |

### LED activo en bajo

El LED RGB de la KL25Z utiliza lógica **Active Low**:

```text
GPIO = 0  → LED ON
GPIO = 1  → LED OFF
```

Por esta razón, para encender un LED se utiliza `PCOR` y para apagarlo se utiliza `PSOR`.

---

# 2. Lectura del ADC

La opción `A` permite monitorear una entrada analógica utilizando el ADC de la KL25Z.
El ADC se configura con una resolución de **12 bits**, por lo que el valor obtenido se encuentra entre:

```text
0 ─────────────── 4095
```

La referencia utilizada en el programa es:

```text
Vref = 3.3 V
```

El valor ADC se convierte a voltaje mediante:

```text
Voltage = ADC_value × 3.3 / 4095
```

### Funcionamiento

El sistema realiza una nueva lectura cada **500 ms**.

Ejemplo de salida:

```text
ADC Monitoring
Reading ADC every 500 ms...
Press Q to return to Main Menu.

ADC Value: 2048
Voltage: 1.65 V
```

La lectura continúa automáticamente hasta que el usuario presiona:

```text
Q
```
para regresar al menú principal.

---

# 3. Keypad 4×4

La opción `K` permite detectar las teclas presionadas en un **teclado matricial 4×4**.
El teclado utiliza cuatro filas y cuatro columnas:

```text
Rows:
R1 → PTE0
R2 → PTE1
R3 → PTE2
R4 → PTE3

Columns:
C1 → PTE4
C2 → PTE5
C3 → PTD6
C4 → PTD7
```

El mapa utilizado por el programa es:

```text
┌───┬───┬───┬───┐
│ 1 │ 2 │ 3 │ A │
├───┼───┼───┼───┤
│ 4 │ 5 │ 6 │ B │
├───┼───┼───┼───┤
│ 7 │ 8 │ 9 │ C │
├───┼───┼───┼───┤
│ * │ 0 │ # │ D │
└───┴───┴───┴───┘
```

### Funcionamiento

El programa realiza un escaneo de las filas:

1. Todas las filas se colocan en `HIGH`.
2. Una fila se coloca en `LOW`.
3. Se leen las cuatro columnas.
4. Si una columna está en `LOW`, se identifica la tecla.
5. Se espera a que la tecla sea liberada.
6. Se devuelve el carácter correspondiente.

Ejemplo:

```text
Keypad Monitoring
Press a key:
Press Q to return to Main Menu.

Key pressed: 5
```

La tecla `Q` enviada desde el terminal serial permite regresar al menú principal.

---

# 4. Monitoreo de botones

La opción `B` permite monitorear dos botones:

```text
Button 1 → PTA4
Button 2 → PTC3
```

Los botones utilizan resistencias **pull-up**, por lo que funcionan con lógica activa en bajo:

```text
0 → PRESSED
1 → RELEASED
```

Al entrar en esta opción, se muestra inicialmente el estado de ambos botones:

```text
Button 1: RELEASED
Button 2: RELEASED
```

Cuando cambia el estado de un botón, el programa muestra el nuevo estado mediante UART.

Ejemplo:

```text
Button 1: PRESSED

Button 1: RELEASED
```

Esto permite detectar tanto la presión como la liberación de cada botón.

---

# 5. SysTick

El programa utiliza el temporizador **SysTick** para generar una interrupción cada **1 ms**.

La variable global:

```c
volatile uint32_t milliseconds = 0;
```

se incrementa dentro del manejador de interrupción:

```c
void SysTick_Handler(void)
{
    milliseconds++;
}
```

La configuración se realiza mediante:

```c
SysTick_Config(SystemCoreClock / 1000U);
```

Esto permite utilizar la variable `milliseconds` como referencia de tiempo.

En particular, el ADC utiliza este contador para realizar una lectura cada:

```text
500 ms
```

---

# 6. Comunicación UART

La comunicación serial se realiza utilizando **UART0**.

### Configuración

```text
Baud rate: 57600
Data bits: 8
Parity: None
```

Los pines utilizados son:

```text
PTA2 → UART0_TX
PTA1 → UART0_RX
```

La transmisión se realiza mediante:

```c
UART0_putc()
UART0_puts()
```

Mientras que la recepción utiliza:

```c
UART0_getc()
UART0_available()
```

La función `UART0_available()` permite comprobar si existe un carácter disponible sin bloquear el programa.

Esto es especialmente importante en las opciones del **ADC, keypad y botones**, ya que permite seguir monitoreando los periféricos mientras se verifica si el usuario desea regresar al menú principal.

---

# Flujo de funcionamiento

El programa sigue la siguiente secuencia:

```text
              INICIO
                 │
                 ▼
        Inicializar UART0
                 │
                 ▼
          Inicializar LED
                 │
                 ▼
        Inicializar botones
                 │
                 ▼
        Inicializar keypad
                 │
                 ▼
          Inicializar ADC
                 │
                 ▼
         Inicializar SysTick
                 │
                 ▼
          Mostrar menú
                 │
                 ▼
       Esperar comando UART
                 │
        ┌────────┼────────┐
        │        │        │
        ▼        ▼        ▼
        L        A        K        B
        │        │        │        │
        ▼        ▼        ▼        ▼
       LED      ADC     Keypad   Buttons
        │        │        │        │
        └────────┴────────┴────────┘
                 │
                 ▼
        Regresar al menú
                 │
                 └──────► Repetir
```

---

# Estructura del programa

El código está organizado en diferentes módulos funcionales:

```text
main()
 │
 ├── UART0_init()
 │
 ├── LED_init()
 │
 ├── Button_init()
 │
 ├── Keypad_init()
 │
 ├── ADC_init()
 │
 ├── SysTick
 │
 └── showMenu()
       │
       └── processCommand()
             │
             ├── optionLED()
             ├── optionADC()
             ├── optionKeypad()
             └── optionButtons()
```

Esta estructura permite mantener separadas las funciones de inicialización, control y monitoreo de cada periférico.

---

# Pruebas realizadas

Para verificar el funcionamiento del sistema se pueden realizar las siguientes pruebas:

### LED RGB

* Seleccionar `L`.
* Encender el LED rojo con `1`.
* Encender el LED verde con `2`.
* Encender el LED azul con `3`.
* Apagar todos los LEDs con `0`.
* Regresar con `Q`.

### ADC

* Seleccionar `A`.
* Observar las lecturas cada 500 ms.
* Variar el voltaje de entrada.
* Verificar que cambien el valor ADC y el voltaje mostrado.
* Presionar `Q` para regresar.

### Keypad

* Seleccionar `K`.
* Presionar diferentes teclas del keypad.
* Verificar que el carácter mostrado corresponda a la tecla presionada.
* Presionar `Q` desde el terminal para regresar.

### Botones

* Seleccionar `B`.
* Presionar Button 1.
* Presionar Button 2.
* Verificar los cambios entre `PRESSED` y `RELEASED`.
* Presionar `Q` para regresar.

---
# Parte 4 — Comunicación UART mediante Interrupciones

## Descripción

En esta parte de la práctica se modificó el sistema desarrollado anteriormente para implementar la **recepción UART mediante interrupciones**.

A diferencia de la Parte 3, donde la recepción de caracteres se realizaba mediante *polling* del registro de estado de UART, en esta versión la **recepción de datos es manejada por una rutina de interrupción (`UART0_IRQHandler`)**.

Los caracteres recibidos desde la computadora se almacenan en un **buffer circular de recepción**, permitiendo que el programa principal pueda procesarlos posteriormente.

---

# Diferencia respecto a la Parte 3

En la Parte 3, la recepción UART utilizaba directamente el registro de estado:

```c
while (!(UART0->S1 & 0x20))
{
}
```

Esto significa que el procesador permanecía esperando hasta que llegara un carácter.
En la Parte 4, la recepción se realiza mediante una **interrupción**.
Cuando llega un carácter:

```text
Computadora
     │
     │ UART
     ▼
  UART0 RX
     │
     ▼
 Interrupción
     │
     ▼
UART0_IRQHandler()
     │
     ▼
Buffer circular
     │
     ▼
Programa principal
```
De esta manera, el hardware UART notifica al procesador cuando existe un dato recibido.

---

# Comunicación UART

La transmisión continúa utilizando *polling*, mientras que la **recepción utiliza interrupciones**.

Esto significa que:

```text
TX → Polling
RX → Interrupt
```

Esta implementación cumple con el objetivo de utilizar interrupciones para la recepción UART.

---

# 1. Habilitación de la interrupción UART

Una de las principales modificaciones se encuentra en la configuración del registro `UART0->C2`.
En esta versión se utiliza:

```c
UART0->C2 = 0x2C;
```

El valor `0x2C` habilita:

```text
RIE → Receiver Interrupt Enable
TE  → Transmitter Enable
RE  → Receiver Enable
```

Por lo tanto, el UART queda configurado para generar una interrupción cuando se recibe un carácter.

---

# 2. NVIC

Además de habilitar la interrupción dentro del UART, es necesario habilitarla en el **Nested Vectored Interrupt Controller (NVIC)**.
Esto se realiza mediante:
```c
NVIC_EnableIRQ(UART0_IRQn);
```

El flujo de recepción queda entonces:

```text
Dato recibido
     │
     ▼
UART0 RX
     │
     ▼
RIE = 1
     │
     ▼
NVIC
     │
     ▼
UART0_IRQHandler()
```

---

# 3. UART0_IRQHandler()

La función:
```c
void UART0_IRQHandler(void)
```
es la rutina de servicio de interrupción (**ISR**) utilizada para procesar los datos recibidos.
Cuando llega un carácter desde la computadora, el handler obtiene el dato:
```c
receivedChar = UART0->D;
```

Posteriormente, el carácter se almacena en el buffer circular.
Es importante destacar que la recepción del hardware se realiza **dentro de la interrupción** y no dentro del programa principal.

---

# 4. Buffer circular
Para almacenar los caracteres recibidos se implementó un **buffer circular de 64 posiciones**:
```c
#define UART_RX_BUFFER_SIZE 64
```
El buffer se declara como:

```c
volatile char uartRxBuffer[UART_RX_BUFFER_SIZE];
```

Se utilizan dos índices:

```c
volatile uint8_t uartRxHead = 0;
volatile uint8_t uartRxTail = 0;
```

### `uartRxHead`

Indica la posición donde la interrupción almacenará el siguiente carácter recibido.

### `uartRxTail`

Indica la posición desde donde el programa principal leerá el siguiente carácter disponible.

El funcionamiento puede representarse como:

```text
              BUFFER CIRCULAR

       ┌─────┬─────┬─────┬─────┬─────┐
       │     │     │     │     │     │
       │ C1  │ C2  │ C3  │ ... │ Cn  │
       └─────┴─────┴─────┴─────┴─────┘
         ▲                       ▲
         │                       │
       Tail                     Head
         │                       │
      Lectura                 Escritura
      programa                   ISR
```

Cuando `head` alcanza el final del buffer, vuelve a la posición inicial.

Esto se realiza mediante:

```c
(nextHead =
    (uint8_t)((uartRxHead + 1u)
              % UART_RX_BUFFER_SIZE));
```

---

# 5. Verificación de buffer lleno

Antes de almacenar un carácter, la interrupción calcula la siguiente posición de `head`.

```c
if (nextHead != uartRxTail)
```

Si la siguiente posición no coincide con `tail`, significa que existe espacio disponible.
En ese caso, el carácter se almacena:

```c
uartRxBuffer[uartRxHead] = receivedChar;
```

y posteriormente se actualiza `head`.

Si el buffer está lleno, el carácter recibido se descarta.

Esto evita sobrescribir datos que todavía no han sido procesados por el programa principal.

---

# 6. UART0_getc()

En esta versión, `UART0_getc()` ya **no consulta directamente el registro `UART0->S1`**.
En lugar de ello, espera a que exista un carácter dentro del buffer:

```c
while (uartRxHead == uartRxTail)
{
}
```

Cuando existe información disponible, se obtiene:

```c
receivedChar =
    uartRxBuffer[uartRxTail];
```

y se actualiza `tail`.

Por lo tanto, la función `UART0_getc()` trabaja sobre el **buffer de software** y no directamente sobre el hardware UART.

---

# 7. UART0_available()

La función:
```c
uint8_t UART0_available(void)
```
permite determinar si existen caracteres pendientes de procesar.

La comprobación se realiza mediante:

```c
return (uartRxHead != uartRxTail);
```

Esto permite que las diferentes funciones del sistema revisen si existe información recibida sin consultar directamente los registros del UART.

---

# 8. SysTick

Al igual que en la Parte 3, se utiliza **SysTick** para generar una base de tiempo de 1 ms.

La interrupción:

```c
void SysTick_Handler(void)
{
    milliseconds++;
}
```

incrementa la variable:

```c
volatile uint32_t milliseconds = 0;
```

La configuración se realiza mediante:

```c
SysTick_Config(
    SystemCoreClock / 1000U
);
```

Esto permite realizar tareas periódicas, como la actualización del ADC cada 500 ms.

Por lo tanto, el programa utiliza dos fuentes de interrupción:

```text
┌───────────────────────┐
│       INTERRUPCIONES  │
├───────────────────────┤
│                       │
│ SysTick               │
│ → Cada 1 ms           │
│                       │
│ UART0                 │
│ → Al recibir datos    │
│                       │
└───────────────────────┘
```

---

# 9. Control del LED RGB

El sistema conserva el control del LED RGB de la Parte 3.

Los pines utilizados son:

| LED   | Pin   |
| ----- | ----- |
| Rojo  | PTB18 |
| Verde | PTB19 |
| Azul  | PTD1  |

# 10. Lectura del ADC

El ADC continúa funcionando con una resolución de **12 bits**.

El rango de valores es:

```text
0 ─────────────── 4095
```

y se utiliza una referencia de:

```text
3.3 V
```

La conversión a voltaje se realiza mediante:

```text
Voltage = ADC_value × 3.3 / 4095
```
---

# 11. Keypad 4×4

El sistema mantiene el escaneo del keypad matricial 4×4.

El mapa utilizado es:

```text
┌───┬───┬───┬───┐
│ 1 │ 2 │ 3 │ A │
├───┼───┼───┼───┤
│ 4 │ 5 │ 6 │ B │
├───┼───┼───┼───┤
│ 7 │ 8 │ 9 │ C │
├───┼───┼───┼───┤
│ * │ 0 │ # │ D │
└───┴───┴───┴───┘
```

La lectura del keypad continúa siendo realizada mediante escaneo de GPIO.

La diferencia principal es que los comandos recibidos desde la computadora, como `Q`, son gestionados mediante el buffer UART alimentado por la interrupción.

---

# 12. Monitoreo de botones

Los botones utilizados son:

```text
Button 1 → PTA4
Button 2 → PTC3
```

Ambos utilizan lógica activa en bajo:

```text
0 → PRESSED
1 → RELEASED
```

El programa compara continuamente el estado actual con el estado anterior.
Cuando detecta un cambio, muestra el nuevo estado mediante UART.
---

# Flujo de interrupción UART

El proceso completo de recepción es:

```text
┌─────────────────┐
│   Computadora   │
└────────┬────────┘
         │
         │ Carácter
         ▼
┌─────────────────┐
│     UART0 RX    │
└────────┬────────┘
         │
         │ RIE
         ▼
┌─────────────────┐
│      NVIC       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│UART0_IRQHandler │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Buffer circular │
│     64 bytes    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  UART0_getc()   │
│  / available()  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Programa main   │
└─────────────────┘
```

---

---

# Comparación: Parte 3 vs Parte 4

| Característica               | Parte 3      | Parte 4          |
| ---------------------------- | ------------ | ---------------- |
| UART TX                      | Polling      | Polling          |
| UART RX                      | Polling      | **Interrupción** |
| Registro `UART0->S1` para RX | Sí           | **No**           |
| Buffer circular              | No           | **Sí**           |
| NVIC                         | No para UART | **Sí**           |
| `UART0_IRQHandler()`         | No           | **Sí**           |
| SysTick                      | Sí           | Sí               |
| LED RGB                      | Sí           | Sí               |
| ADC                          | Sí           | Sí               |
| Keypad 4×4                   | Sí           | Sí               |
| Botones                      | Sí           | Sí               |
| Menú UART                    | Sí           | Sí               |

La principal diferencia entre ambas partes es la forma en que se recibe la información desde la computadora.

---

# Resultado

La Parte 4 implementa correctamente la **recepción UART mediante interrupciones**.

Los datos recibidos por UART0 generan una interrupción que ejecuta `UART0_IRQHandler()`. La rutina almacena los caracteres en un **buffer circular de 64 bytes**, desde donde posteriormente son procesados por el programa principal.

La transmisión UART permanece basada en *polling*, mientras que la recepción utiliza el mecanismo de interrupciones:

```text
TX → Polling
RX → Interrupt + Circular Buffer
```

El resto de las funcionalidades del sistema continúan operando:

```text
✓ LED RGB
✓ ADC
✓ Keypad 4×4
✓ Buttons
✓ SysTick
✓ UART Menu
✓ UART RX Interrupt
```

---
