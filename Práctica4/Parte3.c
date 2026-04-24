#include <MKL25Z4.h>

// Definiciones para LCD
#define RS 0x04 /* PTA2 */
#define EN 0x20 /* PTA5 */
#define TECLA_CONFIRMAR 15 // Tecla #
#define TECLA_REANUDAR 16  // Tecla *

// Prototipos
void delayMs(int n);
void delayUs(int n);
void keypad_init(void);
char keypad_getkey(void);
void LED_init(void);
void LCD_init(void);
void LCD_command(unsigned char cmd);
void LCD_data(unsigned char data);
void LCD_nibble(unsigned char data);
void LCD_Hello(void);
void LCD_Print(int num);
void LCD_Paused(void);
int getDigit(char key);

// Variables globales de control
volatile int contador = 0;
volatile int limite = 0;
volatile int contar = 0;
volatile int pausado = 0; // Nueva variable para estado de pausa


int numero = 0;
int digitos = 0;

int main(void) {
    __disable_irq();

    // 1. Configuración de TPM0 (Timer para el contador)
    SIM->SCGC6 |= 0x01000000;
    SIM->SOPT2 |= 0x01000000;
    TPM0->SC = 0;
    TPM0->MOD = 65535;
    TPM0->SC = 0x07;     // Prescaler 128
    TPM0->SC |= 0x40;    // Habilitar interrupción de timer
    NVIC_EnableIRQ(TPM0_IRQn);

    // 2. Configuración de PORTA (Interrupción del Botón PTA1)
    SIM->SCGC5 |= 0x200;
    PORTA->PCR[1] = 0x00100; // GPIO
    PORTA->PCR[1] |= 0x00003; // Pull-up
    PTA->PDDR &= ~0x0002;    // Input
    PORTA->PCR[1] &= ~0xF0000;
    PORTA->PCR[1] |= 0xA0000; // Falling edge
    NVIC_EnableIRQ(PORTA_IRQn);

    // 3. Inicialización de Periféricos
    keypad_init();
    LED_init();
    LCD_init();
    LCD_Hello();
    LCD_Print(0);

    __enable_irq();

    unsigned char key;
    static int ultimo = -1;

    while(1) {
        key = keypad_getkey();

        if (key != 0) {
            // Caso 1: Si estamos pausados, buscar la tecla '*' para reanudar
            if (pausado && key == TECLA_REANUDAR) {
                pausado = 0;
                contar = 1;
                TPM0->SC |= 0x08; // Re-iniciar timer
                LCD_Print(contador); // Volver a mostrar el tiempo
            }
            // Caso 2: Si no está pausado, procesar dígitos normalmente
            else if (!pausado) {
                int digito = getDigit(key);

                if (digito != -1) {
                    if (digitos < 2) {
                        numero = numero * 10 + digito;
                        digitos++;
                        LCD_Print(numero);
                    }
                }
                else if (key == TECLA_CONFIRMAR) {
                    if (digitos == 2) {
                        contador = 0;
                        limite = numero + 1;
                        contar = 1;
                        PTB->PSOR = 0x40000; // Apagar LED Rojo
                        numero = 0;
                        digitos = 0;
                        TPM0->CNT = 0;
                        TPM0->SC |= 0x08; // Iniciar timer
                    }
                }
            }
            delayMs(200); // Anti-rebote teclado
        }

        // Actualizar LCD si el contador cambia y no estamos pausados
        if (contar && !pausado && contador != ultimo) {
            LCD_Print(contador);
            ultimo = contador;
        }
    }
}

// --- Manejador de Interrupción del Botón (Pausa) ---
void PORTA_IRQHandler(void) {
    if (contar) { // Solo pausar si el tiempo está corriendo
        pausado = 1;
        contar = 0;
        TPM0->SC &= ~0x08; // Detener el timer
        LCD_Paused();      // Mostrar mensaje PAUSED
    }
    PORTA->ISFR = 0xFFFFFFFF; // Limpiar banderas
}

// --- Manejador del Timer (Contador) ---
void TPM0_IRQHandler(void) {
    TPM0->SC |= 0x80; // Limpiar bandera TOF
    if (contar && !pausado) {
        contador++;
        if (contador >= limite) {
            contar = 0;
            PTB->PCOR = 0x40000; // Encender LED Rojo al terminar
            TPM0->SC &= ~0x08;   // Apagar timer
        }
    }
}

// --- Funciones de la LCD ---
void LCD_Paused(void) {
    LCD_command(0x01);
    delayMs(2);

    LCD_command(0x80); // Fila 1

    char mensaje[] = "PAUSED          "; // 16 chars

    for (int i = 0; i < 16; i++) {
        LCD_data(mensaje[i]);
    }
}

void LCD_Print(int num) {
    LCD_command(0x01);
    delayMs(2);
    LCD_command(0x80);
    LCD_data('T'); LCD_data('i'); LCD_data('e'); LCD_data('m'); LCD_data('p'); LCD_data('o');
    LCD_command(0xC0); // Fila 2
    if (num < 10) {
        LCD_data('0');
        LCD_data(num + '0');
    } else {
        LCD_data((num / 10) + '0');
        LCD_data((num % 10) + '0');
    }
}

// --- Funciones de Keypad ---
int getDigit(char key) {
    switch(key) {
        case 1: return 1;
        case 2: return 2;
        case 3: return 3;
        case 5: return 4;
        case 6: return 5;
        case 7: return 6;
        case 9: return 7;
        case 10: return 8;
        case 11: return 9;
        case 14: return 0;
        default: return -1;
    }
}

void keypad_init(void) {
    SIM->SCGC5 |= 0x0800;
    for(int i=0; i<8; i++) PORTC->PCR[i] = 0x103;


    PTC->PDDR = 0x0F;
}

char keypad_getkey(void) {
    int row, col;
    const char row_select[] = {0x01, 0x02, 0x04, 0x08};
    for (row = 0; row < 4; row++) {
        PTC->PDDR = 0x0F;
        PTC->PDOR = ~row_select[row];
        delayUs(2);
        col = PTC->PDIR & 0xF0;
        if (col != 0xF0) {
            if (col == 0xE0) return row*4+1;
            if (col == 0xD0) return row*4+2;
            if (col == 0xB0) return row*4+3;
            if (col == 0x70) return row*4+4;
        }
    }
    return 0;
}

// --- Resto de funciones auxiliares (LCD_init, delayMs, etc.) ---
void LCD_init(void) {
    SIM->SCGC5 |= 0x1000 | 0x0200; // Port D y A
    PORTD->PCR[4]=PORTD->PCR[5]=PORTD->PCR[6]=PORTD->PCR[7]=0x100;
    PTD->PDDR |= 0xF0;
    PORTA->PCR[2]=PORTA->PCR[5]=0x100;
    PTA->PDDR |= (RS | EN);
    delayMs(20);
    LCD_nibble(0x30); delayMs(5);
    LCD_nibble(0x30); delayUs(100);
    LCD_nibble(0x30); delayUs(100);
    LCD_nibble(0x20);
    LCD_command(0x28); LCD_command(0x06); LCD_command(0x01); LCD_command(0x0F);
}

void LCD_nibble(unsigned char data) {
    PTD->PDOR = (PTD->PDOR & 0x0F) | (data & 0xF0);
    PTA->PSOR = EN; delayUs(5); PTA->PCOR = EN;
}

void LCD_command(unsigned char cmd) {
    PTA->PCOR = RS; LCD_nibble(cmd); LCD_nibble(cmd << 4); delayMs(2);
}

void LCD_data(unsigned char data) {
    PTA->PSOR = RS; LCD_nibble(data); LCD_nibble(data << 4); delayMs(2);
}

void LCD_Hello(void) {
    LCD_command(0x01);
    LCD_command(0x80);
    LCD_data('R'); LCD_data('E'); LCD_data('A'); LCD_data('D'); LCD_data('Y');
    delayMs(1000);
}

void LED_init(void) {
    SIM->SCGC5 |= 0x400;
    PORTB->PCR[18] = 0x100; // Red
    PTB->PDDR |= 0x40000;
    PTB->PSOR = 0x40000; // Off
}

void delayUs(int n) {
    volatile int i;
    while(n--)
    	for(i = 0; i < 10; i++);
}

void delayMs(int n) {
    volatile int i;
    while(n--)
    	for(i = 0; i < 7000; i++);
}
