/* =========================================
 * FreeRTOS Stage 3 - SENSORES
 * FRDM-KL25Z
 * Fotorresistencia (LDR) + DHT11
 * LED RGB integrado funcional
 * ========================================= */

#include "FreeRTOS.h"
#include "task.h"

#include "MKL25Z4.h"

#include "fsl_debug_console.h"

#include "board.h"
#include "pin_mux.h"
#include "clock_config.h"

/* =========================================
 * DEFINES
 * ========================================= */

#define DHT_PIN 2           /* PTD2 */
#define DHT_PORT PORTD
#define DHT_GPIO PTD

#define LDR_CHANNEL 0       /* PTE20 -> ADC0_SE0 */

/* =========================================
 * Variables globales
 * ========================================= */

volatile uint16_t light_value = 0;      /* 0-1023 (10 bits) */
volatile uint8_t temperature = 0;       /* °C */
volatile uint8_t humidity = 0;          /* % */
volatile uint8_t dht_ready = 0;         /* Flag: DHT lectura lista */
volatile uint8_t button_pressed = 0;

/* =========================================
 * Prototipos
 * ========================================= */

void ADC0_Init(void);
uint16_t Read_ADC(uint8_t channel);

void DHT11_Init(void);
uint8_t DHT11_Read(uint8_t *temp, uint8_t *humid);

void Button_Init(void);
void RGB_LED_Init(void);

void delayMicroseconds(uint32_t us);

void vTaskLightSensor(void *pvParameters);
void vTaskTemperatureSensor(void *pvParameters);
void vTaskButtonPolling(void *pvParameters);
void vTaskLedControl(void *pvParameters);
void vTaskSerialMonitor(void *pvParameters);

/* =========================================
 * MAIN
 * ========================================= */

int main(void)
{
    BOARD_InitBootPins();
    BOARD_InitBootClocks();

    BOARD_InitDebugConsole();

    /* =====================================
     * Configurar pines analógicos
     * PTE20 -> ADC0_SE0 (Fotorresistencia)
     * ===================================== */

    SIM->SCGC5 |= SIM_SCGC5_PORTE_MASK;
    PORTE->PCR[20] = 0;  /* Analog */

    /* Inicializaciones */

    ADC0_Init();
    DHT11_Init();
    Button_Init();
    RGB_LED_Init();

    /* =====================================
     * Crear tareas
     * ===================================== */

    xTaskCreate(vTaskLightSensor,
                "Light",
                500,
                NULL,
                1,
                NULL);

    xTaskCreate(vTaskTemperatureSensor,
                "Temp",
                500,
                NULL,
                1,
                NULL);

    xTaskCreate(vTaskButtonPolling,
                "Button",
                500,
                NULL,
                1,
                NULL);

    xTaskCreate(vTaskLedControl,
                "LED",
                500,
                NULL,
                1,
                NULL);

    xTaskCreate(vTaskSerialMonitor,
                "UART",
                700,
                NULL,
                1,
                NULL);

    /* Iniciar scheduler */

    vTaskStartScheduler();

    while(1)
    {
    }
}

/* =========================================
 * ADC INIT
 * PTE20 -> ADC0_SE0
 * ========================================= */

void ADC0_Init(void)
{
    /* Activar reloj ADC0 */

    SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;

    /* Configuración ADC */

    ADC0->CFG1 =
            ADC_CFG1_MODE(1) |      /* 12 bits */
            ADC_CFG1_ADIV(1) |      /* Divide clock by 2 */
            ADC_CFG1_ADICLK(0);     /* Bus clock */

    ADC0->SC2 = 0;
    ADC0->SC3 = 0;
}

/* =========================================
 * READ ADC
 * ========================================= */

uint16_t Read_ADC(uint8_t channel)
{
    ADC0->SC1[0] = channel;

    while(!(ADC0->SC1[0] & ADC_SC1_COCO_MASK))
    {
    }

    return ADC0->R[0];
}

/* =========================================
 * DHT11 INIT
 * PTD2 como GPIO
 * ========================================= */

void DHT11_Init(void)
{
    /* Activar reloj PORTD */
    SIM->SCGC5 |= SIM_SCGC5_PORTD_MASK;

    /* Configurar PTD2 como GPIO */
    PORTD->PCR[DHT_PIN] = PORT_PCR_MUX(1);

    /* Configurar como salida (open-drain) */
    DHT_GPIO->PDDR |= (1 << DHT_PIN);

    /* Iniciar en HIGH */
    DHT_GPIO->PSOR |= (1 << DHT_PIN);
}

/* =========================================
 * DELAY MICROSEGUNDOS
 * Aproximado a 48MHz
 * ========================================= */

void delayMicroseconds(uint32_t us)
{
    volatile uint32_t i;
    for (i = 0; i < us * 4; i++)
    {
        __nop();
    }
}

/* =========================================
 * DHT11 READ FUNCTIONS
 * ========================================= */

void DHT_set_line_low(void)
{
    DHT_GPIO->PCOR |= (1 << DHT_PIN);  /* LOW */
    DHT_GPIO->PDDR |= (1 << DHT_PIN);  /* Output */
}

void DHT_set_line_high(void)
{
    DHT_GPIO->PSOR |= (1 << DHT_PIN);   /* HIGH */
    DHT_GPIO->PDDR &= ~(1 << DHT_PIN);  /* Input (Open-drain) */
}

uint8_t DHT_read_pin(void)
{
    return ((DHT_GPIO->PDIR >> DHT_PIN) & 1);
}

/* =========================================
 * DHT11 READ DATA
 * Retorna:
 *   1 -> Éxito
 *   0 -> Error / Timeout
 * ========================================= */

uint8_t DHT11_Read(uint8_t *temp, uint8_t *humid)
{
    uint8_t data[5] = {0, 0, 0, 0, 0};
    uint8_t bit_index = 0;
    uint8_t byte_index = 0;
    uint16_t pulse_width = 0;
    uint16_t timeout = 0;

    /* ====================================
     * 1. ENVIAR PULSO DE INICIO
     * 18ms LOW seguido de HIGH
     * ==================================== */

    DHT_set_line_low();
    vTaskDelay(pdMS_TO_TICKS(18));

    DHT_set_line_high();
    delayMicroseconds(40);

    /* ====================================
     * 2. ESPERAR RESPUESTA DEL SENSOR
     * Sensor responde con LOW
     * ==================================== */

    timeout = 100;
    while (DHT_read_pin() == 1 && timeout--)
    {
        delayMicroseconds(1);
    }

    if (timeout == 0)
        return 0;  /* Timeout - sensor no responde */

    /* ====================================
     * 3. ESPERAR FIN DE RESPUESTA
     * ==================================== */

    timeout = 100;
    while (DHT_read_pin() == 0 && timeout--)
    {
        delayMicroseconds(1);
    }

    if (timeout == 0)
        return 0;

    /* ====================================
     * 4. LEER 40 BITS (5 BYTES)
     * ==================================== */

    for (int i = 0; i < 40; i++)
    {
        /* Esperar inicio de pulso (LOW a HIGH) */
        timeout = 100;
        while (DHT_read_pin() == 0 && timeout--)
        {
            delayMicroseconds(1);
        }

        if (timeout == 0)
            return 0;

        /* Contar duración del pulso HIGH */
        pulse_width = 0;
        timeout = 100;
        while (DHT_read_pin() == 1 && timeout--)
        {
            delayMicroseconds(1);
            pulse_width++;
        }

        /* Si pulse > 30us es '1', si < 30us es '0' */
        if (pulse_width > 30)
        {
            data[byte_index] |= (1 << (7 - bit_index));
        }

        bit_index++;
        if (bit_index == 8)
        {
            bit_index = 0;
            byte_index++;
        }
    }

    /* ====================================
     * 5. VERIFICAR CHECKSUM
     * Suma de primeros 4 bytes
     * ==================================== */

    uint8_t checksum = data[0] + data[1] + data[2] + data[3];

    if (checksum != data[4])
    {
        return 0;  /* Checksum incorrecto */
    }

    /* ====================================
     * 6. EXTRAER DATOS
     * data[0] = Humedad entera
     * data[1] = Humedad decimal
     * data[2] = Temperatura entera
     * data[3] = Temperatura decimal
     * ==================================== */

    *humid = data[0];
    *temp = data[2];

    return 1;  /* Lectura exitosa */
}

/* =========================================
 * BUTTON INIT
 * PTB0
 * Pull-up interno
 * ========================================= */

void Button_Init(void)
{
    /* Activar reloj PORTB */

    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;

    /* PTB0 GPIO + pull-up */

    PORTB->PCR[0] =
            PORT_PCR_MUX(1) |
            PORT_PCR_PE_MASK |
            PORT_PCR_PS_MASK;

    /* Entrada */

    PTB->PDDR &= ~(1 << 0);
}

/* =========================================
 * RGB LED INIT
 * ========================================= */

void RGB_LED_Init(void)
{
    /* Clocks */

    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;
    SIM->SCGC5 |= SIM_SCGC5_PORTD_MASK;

    /* =====================================
     * LED ROJO -> PTB18
     * LED VERDE -> PTB19
     * LED AZUL -> PTD1
     * ===================================== */

    PORTB->PCR[18] = PORT_PCR_MUX(1);
    PORTB->PCR[19] = PORT_PCR_MUX(1);
    PORTD->PCR[1]  = PORT_PCR_MUX(1);

    /* Outputs */

    PTB->PDDR |= (1 << 18);
    PTB->PDDR |= (1 << 19);
    PTD->PDDR |= (1 << 1);

    /* OFF initially
     * LEDs active LOW
     */

    PTB->PSOR = (1 << 18);
    PTB->PSOR = (1 << 19);
    PTD->PSOR = (1 << 1);
}

/* =========================================
 * TASK SENSOR LUZ
 * PTE20 -> ADC0_SE0
 * Fotorresistencia
 * Lee cada 500ms
 * ========================================= */

void vTaskLightSensor(void *pvParameters)
{
    for(;;)
    {
        light_value = Read_ADC(LDR_CHANNEL);

        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

/* =========================================
 * TASK SENSOR TEMPERATURA
 * PTD2 -> DHT11
 * Lee cada 2 segundos (DHT11 requiere este tiempo)
 * ========================================= */

void vTaskTemperatureSensor(void *pvParameters)
{
    for(;;)
    {
        if (DHT11_Read(&temperature, &humidity))
        {
            dht_ready = 1;  /* Lectura exitosa */
        }
        else
        {
            dht_ready = 0;  /* Error en lectura */
        }

        vTaskDelay(pdMS_TO_TICKS(2000));  /* DHT11 mínimo 2 segundos */
    }
}

/* =========================================
 * TASK BUTTON
 * PTB0
 * ========================================= */

void vTaskButtonPolling(void *pvParameters)
{
    for(;;)
    {
        /* Pull-up:
         * Presionado = 0
         */

        if((PTB->PDIR & (1 << 0)) == 0)
        {
            button_pressed = 1;
        }
        else
        {
            button_pressed = 0;
        }

        vTaskDelay(pdMS_TO_TICKS(50));
    }
}

/* =========================================
 * TASK LEDs
 * LED ROJO -> Luz (LDR > 50%)
 * LED AZUL -> Temperatura (> 25°C)
 * LED VERDE -> Botón
 * ========================================= */

void vTaskLedControl(void *pvParameters)
{
    for(;;)
    {
        /* =================================
         * LED ROJO -> Sensor de luz
         * Enciende si hay buena iluminación
         * Umbral: 50% (512 de 1023)
         * ================================= */

        if(light_value > 512)
        {
            PTB->PCOR = (1 << 18); /* ON */
        }
        else
        {
            PTB->PSOR = (1 << 18); /* OFF */
        }

        /* =================================
         * LED AZUL -> Sensor de temperatura
         * Enciende si temperatura > 25°C
         * ================================= */

        if(temperature > 25)
        {
            PTD->PCOR = (1 << 1); /* ON */
        }
        else
        {
            PTD->PSOR = (1 << 1); /* OFF */
        }

        /* =================================
         * LED VERDE -> Botón
         * ================================= */

        if(button_pressed)
        {
            PTB->PCOR = (1 << 19); /* ON */
        }
        else
        {
            PTB->PSOR = (1 << 19); /* OFF */
        }

        vTaskDelay(pdMS_TO_TICKS(200));
    }
}

/* =========================================
 * TASK UART
 * Monitoreo en consola serial
 * ========================================= */

void vTaskSerialMonitor(void *pvParameters)
{
    for(;;)
    {
        if (dht_ready)
        {
            PRINTF("LUZ: %4d/1023 | TEMP: %d°C | HUM: %d%% | BOTON: %d\r\n",
                   light_value,
                   temperature,
                   humidity,
                   button_pressed);
        }
        else
        {
            PRINTF("LUZ: %4d/1023 | TEMP: ERR | HUM: ERR | BOTON: %d\r\n",
                   light_value,
                   button_pressed);
        }

        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
