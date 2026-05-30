//Stage3

#include "FreeRTOS.h"
#include "task.h"
#include "MKL25Z4.h"
#include "board.h"
#include "pin_mux.h"
#include "clock_config.h"

#define LDR_CHANNEL 0       /* PTE20 -> ADC0_SE0 */
#define LM35_CHANNEL 4      /* PTE21 -> ADC0_SE4a */

volatile uint16_t light_value = 0;      /* 0-4095 (LDR) */
volatile uint16_t temp_raw = 0;         /* 0-4095 (LM35 ADC) */
volatile float temperature = 0.0f;      /* Temperatura en °C */
volatile uint8_t button_pressed = 0;

//Funciones 
void ADC0_Init(void);
uint16_t Read_ADC(uint8_t channel);
void Button_Init(void);
void RGB_LED_Init(void);
void delayMs(uint32_t ms);

void vTaskLightSensor(void *pvParameters);
void vTaskTemperatureSensor(void *pvParameters);
void vTaskButtonPolling(void *pvParameters);
void vTaskLedControl(void *pvParameters);

static inline void nop(void)
{
    __asm("nop");
}

//DelayMs
void delayMs(uint32_t ms)
{
    volatile uint32_t i, j;
    for (i = 0; i < ms; i++)
        for (j = 0; j < 2000; j++)
            nop();
}

//Main
int main(void)
{
    BOARD_InitBootPins();
    BOARD_InitBootClocks();

    //Pines analogicos 
    SIM->SCGC5 |= SIM_SCGC5_PORTE_MASK;
    PORTE->PCR[20] = 0;  /* PTE20 - LDR */
    PORTE->PCR[21] = 0;  /* PTE21 - LM35 */

    //Peris
    ADC0_Init();
    Button_Init();
    RGB_LED_Init();

   //Parpadear al inicio para indicar que inició el programa

    for (int i = 0; i < 5; i++)
    {
        PTB->PCOR = (1 << 18);  /* LED Rojo ON */
        delayMs(300);
        PTB->PSOR = (1 << 18);  /* LED Rojo OFF */
        delayMs(300);
    }

    //Tareas
    xTaskCreate(vTaskLightSensor, "LightSensor", 256, NULL, 2, NULL);
    xTaskCreate(vTaskTemperatureSensor, "TempSensor", 256, NULL, 2, NULL);
    xTaskCreate(vTaskButtonPolling, "Button", 256, NULL, 2, NULL);
    xTaskCreate(vTaskLedControl, "LedControl", 256, NULL, 2, NULL);

    //Scheduler
    vTaskStartScheduler();

    while(1) {}
    return 0;
}

//ADC

void ADC0_Init(void)
{
    /* Habilitar reloj ADC0 */
    SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;

    /* Configuración: 12 bits, clock/2, bus clock */
    ADC0->CFG1 = ADC_CFG1_MODE(1) |    /* 12 bits */
                 ADC_CFG1_ADIV(1) |    /* Divide by 2 */
                 ADC_CFG1_ADICLK(0);   /* Bus clock */

    ADC0->SC2 = 0;
    ADC0->SC3 = 0;
}

//Leer ADC 

uint16_t Read_ADC(uint8_t channel)
{
    ADC0->SC1[0] = channel;

    /* Esperar a que termine la conversión */
    while(!(ADC0->SC1[0] & ADC_SC1_COCO_MASK))
    {
    }

    return ADC0->R[0];
}

//Botón PTB0

void Button_Init(void)
{
    /* Habilitar reloj PORTB */
    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;

    /* PTB0 con pull-up interno */
    PORTB->PCR[0] = PORT_PCR_MUX(1) |
                    PORT_PCR_PE_MASK |
                    PORT_PCR_PS_MASK;

    /* Configurar como entrada */
    PTB->PDDR &= ~(1 << 0);
}

// LEDs RGB
// Rojo: PTB18, Verde: PTB19, Azul: PTD1  


void RGB_LED_Init(void)
{
    //Relojes
    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;
    SIM->SCGC5 |= SIM_SCGC5_PORTD_MASK;

    //GPIOS
    PORTB->PCR[18] = PORT_PCR_MUX(1);  /* Red */
    PORTB->PCR[19] = PORT_PCR_MUX(1);  /* Green */
    PORTD->PCR[1]  = PORT_PCR_MUX(1);  /* Blue */

    /Salidas
    PTB->PDDR |= (1 << 18);
    PTB->PDDR |= (1 << 19);
    PTD->PDDR |= (1 << 1);

    // Apagar LEDs 
    PTB->PSOR = (1 << 18);
    PTB->PSOR = (1 << 19);
    PTD->PSOR = (1 << 1);
}


// TASK: LEER SENSOR DE LUZ (LDR)
// Lee PTE20 (ADC0_SE0) cada 500ms

void vTaskLightSensor(void *pvParameters)
{
    for(;;)
    {
        light_value = Read_ADC(LDR_CHANNEL);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

//TASK: LEER SENSOR DE TEMPERATURA (LM35)
//Lee PTE21 (ADC0_SE4a) cada 500ms


void vTaskTemperatureSensor(void *pvParameters)
{
    for(;;)
    {
        temp_raw = Read_ADC(LM35_CHANNEL);

        // Convertir ADC a voltaje (3.3V / 4095)
        // LM35: 10mV por °C, entonces 3.3V = 330°C máximo
        temperature = (temp_raw / 4095.0f) * 3.3f * 100.0f;

        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

//TASK: POLLING DE BOTÓN
//Lee PTB0 cada 50ms

void vTaskButtonPolling(void *pvParameters)
{
    for(;;)
    {
       
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

//TASK: CONTROL DE LEDs

void vTaskLedControl(void *pvParameters)
{
    for(;;)
    {
        /* LED ROJO - Sensor de luz (NO MODIFICAR) */
        if(light_value > 2048)
        {
            PTB->PCOR = (1 << 18);  /* ON */
        }
        else
        {
            PTB->PSOR = (1 << 18);  /* OFF */
        }

        // LED AZUL - Sensor de temperatura LM35
        
        if(temperature > 30.0f)
        {
            PTD->PCOR = (1 << 1);   
        }
        else
        {
            PTD->PSOR = (1 << 1);  
        }

        // LED VERDE - Botón 
        if(button_pressed)
        {
            PTB->PCOR = (1 << 19);  /* ON */
        }
        else
        {
            PTB->PSOR = (1 << 19);  /* OFF */
        }

        vTaskDelay(pdMS_TO_TICKS(200));
    }
}
