#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vuart_loop.h"
//#include "Valu___024unit.h"


#define MAX_SIM_TIME 2000
//vluint64_t sim_time = 0;
int sim_time = 0;


int main(int argc, char** argv, char** env) {
    Vuart_loop *dut = new Vuart_loop;


    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 1);
    m_trace->open("waveform.vcd");


    //init values
    dut->clk = 1;
    dut->rst_n = 0;
    dut->tx_data_valid = 0;


    for(int i=0; i<4000000;i++)
    {
        //
        dut->clk ^= 1;
        dut->eval();


        if(i==20)dut->rst_n = 1; //снимаем сброс


        if(i%10000==30) //циклично передаем случайный байт данных
        {
            dut->tx_data_valid = 1;
            dut->rx_data_ready  = 1;
            dut->tx_data = rand()%255; //генерация псевдослучайного числа от 0 до 255
        }


        //if((dut->tx_data_ready==0) && i>30)dut->tx_data_valid = 0;
        m_trace->dump(sim_time);
        sim_time++;
    }


    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
