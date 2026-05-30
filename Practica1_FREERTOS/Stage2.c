#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

#include "MKL25Z4.h"
#include "fsl_debug_console.h"
#include "board.h"
#include "pin_mux.h"
#include "clock_config.h"

typedef enum {
    SENSOR_LIGHT,
    SENSOR_TEMP,
    SENSOR_BUTTON
} sensor_type_t;

typedef struct {
    sensor_type_t type;
    uint16_t      value;
} sensor_msg_t;

QueueHandle_t sensorQueue;

void ADC0_Init(void);
uint16_t Read_ADC(uint8_t channel);
void Button_Init(void);
void RGB_LED_Init(void);

void vTaskLightSensor(void *pvParameters);
void vTaskTemperatureSensor(void *pvParameters);
void vTaskButtonPolling(void *pvParameters);
void vTaskLedControl(void *pvParameters);

int main(void) {
    BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitDebugConsole();

    // Configurar pines analogicos: PTE20 -> ADC0_SE0, PTE21 -> ADC0_SE4a
    SIM->SCGC5 |= SIM_SCGC5_PORTE_MASK;
    PORTE->PCR[20] = 0;
    PORTE->PCR[21] = 0;

    ADC0_Init();
    Button_Init();
    RGB_LED_Init();

    sensorQueue = xQueueCreate(10, sizeof(sensor_msg_t));
    if(sensorQueue == NULL) {
        PRINTF("Error: no se pudo crear la queue\r\n");
        while(1);
    }

    PRINTF("FreeRTOS KL25Z - Stage 2: Message Queues\r\n");

    xTaskCreate(vTaskLightSensor, "Light", 500, NULL, 2, NULL);
    xTaskCreate(vTaskTemperatureSensor, "Temp", 500, NULL, 2, NULL);
    xTaskCreate(vTaskButtonPolling, "Button", 500, NULL, 1, NULL);
    xTaskCreate(vTaskLedControl, "LED", 500, NULL, 3, NULL);

    vTaskStartScheduler();

    while(1);
}

void ADC0_Init(void) {
    SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;

    ADC0->CFG1 = ADC_CFG1_MODE(2) |      // 10 bits
                 ADC_CFG1_ADIV(1) |      // Divide clock by 2
                 ADC_CFG1_ADICLK(0);     // Bus clock

    ADC0->SC2 = 0;
    ADC0->SC3 = 0;
}

uint16_t Read_ADC(uint8_t channel) {
    ADC0->SC1[0] = channel;

    while(!(ADC0->SC1[0] & ADC_SC1_COCO_MASK));

    return ADC0->R[0];
}

void Button_Init(void) {
    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;

    PORTB->PCR[0] = PORT_PCR_MUX(1) |
                    PORT_PCR_PE_MASK |   // Pull-up
                    PORT_PCR_PS_MASK;

    PTB->PDDR &= ~(1 << 0);  // Entrada
}

void RGB_LED_Init(void) {
    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;
    SIM->SCGC5 |= SIM_SCGC5_PORTD_MASK;

    PORTB->PCR[18] = PORT_PCR_MUX(1);
    PORTB->PCR[19] = PORT_PCR_MUX(1);
    PORTD->PCR[1]  = PORT_PCR_MUX(1);

    PTB->PDDR |= (1 << 18);
    PTB->PDDR |= (1 << 19);
    PTD->PDDR |= (1 << 1);

    // LEDs apagados (activos en LOW)
    PTB->PSOR = (1 << 18);
    PTB->PSOR = (1 << 19);
    PTD->PSOR = (1 << 1);
}

// Tarea: Sensor de luz (Productor)
void vTaskLightSensor(void *pvParameters) {
    sensor_msg_t msg;

    for(;;) {
        msg.type  = SENSOR_LIGHT;
        msg.value = Read_ADC(0);

        xQueueSend(sensorQueue, &msg, pdMS_TO_TICKS(10));
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

// Tarea: Sensor de temperatura (Productor)
void vTaskTemperatureSensor(void *pvParameters) {
    sensor_msg_t msg;

    for(;;) {
        msg.type  = SENSOR_TEMP;
        msg.value = Read_ADC(4);

        xQueueSend(sensorQueue, &msg, pdMS_TO_TICKS(10));
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

// Tarea: Lectura del botón (Productor)
void vTaskButtonPolling(void *pvParameters) {
    sensor_msg_t msg;

    for(;;) {
        msg.type  = SENSOR_BUTTON;
        msg.value = (PTB->PDIR & (1 << 0)) ? 1 : 0;

        xQueueSend(sensorQueue, &msg, pdMS_TO_TICKS(10));
        vTaskDelay(pdMS_TO_TICKS(50));  // Debounce
    }
}

// Tarea: Control de LEDs (Consumidor)
// LED ROJO (PTB18): luz > 500
// LED AZUL (PTD1): temp > 500
// LED VERDE (PTB19): botón presionado
void vTaskLedControl(void *pvParameters) {
    sensor_msg_t msg;

    uint16_t light_value  = 0;
    uint16_t temp_value   = 0;
    uint16_t button_value = 1;  // Pull-up: inactivo = 1

    for(;;) {
        if(xQueueReceive(sensorQueue, &msg, portMAX_DELAY) == pdPASS) {
            switch(msg.type) {
                case SENSOR_LIGHT:
                    light_value = msg.value;
                    break;
                case SENSOR_TEMP:
                    temp_value = msg.value;
                    break;
                case SENSOR_BUTTON:
                    button_value = msg.value;
                    break;
            }

            // LED ROJO
            if(light_value > 500)
                PTB->PCOR = (1 << 18);  // ON
            else
                PTB->PSOR = (1 << 18);  // OFF

            // LED AZUL
            if(temp_value > 500)
                PTD->PCOR = (1 << 1);   // ON
            else
                PTD->PSOR = (1 << 1);   // OFF

            // LED VERDE
            if(button_value == 0)
                PTB->PCOR = (1 << 19);  // ON
            else
                PTB->PSOR = (1 << 19);  // OFF
        }
    }
}
