#include "FreeRTOS.h"
#include "task.h"

#include "MKL25Z4.h"

#include "fsl_debug_console.h"

#include "board.h"
#include "pin_mux.h"
#include "clock_config.h"

volatile uint16_t light_value = 0;
volatile uint16_t temp_value = 0;
volatile uint8_t button_pressed = 0;

void ADC0_Init(void);
uint16_t Read_ADC(uint8_t channel);
void Button_Init(void);
void RGB_LED_Init(void);

void vTaskLightSensor(void *pvParameters);
void vTaskTemperatureSensor(void *pvParameters);
void vTaskButtonPolling(void *pvParameters);
void vTaskLedControl(void *pvParameters);
void vTaskSerialMonitor(void *pvParameters);

int main(void)
{
    BOARD_InitBootPins();
    BOARD_InitBootClocks();
    BOARD_InitDebugConsole();

    // PTE20 -> ADC0_SE0 (luz)
    // PTE21 -> ADC0_SE4a (temperatura)

    SIM->SCGC5 |= SIM_SCGC5_PORTE_MASK;
    PORTE->PCR[20] = 0;
    PORTE->PCR[21] = 0;

    ADC0_Init();
    Button_Init();
    RGB_LED_Init();

    xTaskCreate(vTaskLightSensor, "Light", 500, NULL, 1, NULL);
    xTaskCreate(vTaskTemperatureSensor, "Temp", 500, NULL, 1, NULL);
    xTaskCreate(vTaskButtonPolling, "Button", 500, NULL, 1, NULL);
    xTaskCreate(vTaskLedControl, "LED", 500, NULL, 1, NULL);
    xTaskCreate(vTaskSerialMonitor, "UART", 700, NULL, 1, NULL);

    vTaskStartScheduler();

    while(1);
}

void ADC0_Init(void)
{
    SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;

    ADC0->CFG1 = ADC_CFG1_MODE(2) |   /* 10 bits */
                 ADC_CFG1_ADIV(1) |   /* Divide clock by 2 */
                 ADC_CFG1_ADICLK(0);  /* Bus clock */

    ADC0->SC2 = 0;
    ADC0->SC3 = 0;
}

uint16_t Read_ADC(uint8_t channel)
{
    ADC0->SC1[0] = channel;

    while(!(ADC0->SC1[0] & ADC_SC1_COCO_MASK));

    return ADC0->R[0];
}

void Button_Init(void)
{
    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;

    // PTB0: GPIO 
    PORTB->PCR[0] = PORT_PCR_MUX(1) | PORT_PCR_PE_MASK | PORT_PCR_PS_MASK;

    PTB->PDDR &= ~(1 << 0);
}

void RGB_LED_Init(void)
{
    SIM->SCGC5 |= SIM_SCGC5_PORTB_MASK;
    SIM->SCGC5 |= SIM_SCGC5_PORTD_MASK;

    // LEDs: Rojo (PTB18), Verde (PTB19), Azul (PTD1)
    PORTB->PCR[18] = PORT_PCR_MUX(1);
    PORTB->PCR[19] = PORT_PCR_MUX(1);
    PORTD->PCR[1]  = PORT_PCR_MUX(1);

    PTB->PDDR |= (1 << 18);
    PTB->PDDR |= (1 << 19);
    PTD->PDDR |= (1 << 1);

    // LEDs activos en LOW, iniciados apagados
    PTB->PSOR = (1 << 18);
    PTB->PSOR = (1 << 19);
    PTD->PSOR = (1 << 1);
}

void vTaskLightSensor(void *pvParameters)
{
    for(;;)
    {
        light_value = Read_ADC(0);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

void vTaskTemperatureSensor(void *pvParameters)
{
    for(;;)
    {
        temp_value = Read_ADC(4);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

void vTaskButtonPolling(void *pvParameters)
{
    for(;;)
    {
        // Pull-up: botón presionado = 0
        if((PTB->PDIR & (1 << 0)) == 0)
            button_pressed = 1;
        else
            button_pressed = 0;

        vTaskDelay(pdMS_TO_TICKS(50));
    }
}

void vTaskLedControl(void *pvParameters)
{
    for(;;)
    {
        // Rojo: encendido si luz > 500 
        if(light_value > 500)
            PTB->PCOR = (1 << 18);
        else
            PTB->PSOR = (1 << 18);

        // Azul: encendido si temperatura > 500 
        if(temp_value > 500)
            PTD->PCOR = (1 << 1);
        else
            PTD->PSOR = (1 << 1);

        // Verde: encendido si botón presionado 
        if(button_pressed)
            PTB->PCOR = (1 << 19);
        else
            PTB->PSOR = (1 << 19);

        vTaskDelay(pdMS_TO_TICKS(200));
    }
}

void vTaskSerialMonitor(void *pvParameters)
{
    for(;;)
    {
        PRINTF("Light: %4d | Temp: %4d | Button: %d\r\n",
               light_value, temp_value, button_pressed);

        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
