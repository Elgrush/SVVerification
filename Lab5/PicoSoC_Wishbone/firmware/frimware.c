//#define N 1024
#define GPIO_ADDR  0x10010000
#define ARRAY_ADDR 0x00010000
#define RAM_SIZE (16 * 1024) 

typedef int m4[4][4];

int __mulsi3(int a, int b)
{
    int result = 0;
    while (b) {
        if (b & 1) result += a;
        a <<= 1;
        b >>= 1;
    }
    return result;
}

void mat4_mul_opt(const m4 A, const m4 B, m4 C)
{
    int a0, a1, a2, a3;

    for (int i = 0; i < 4; i++) {

        a0 = A[i][0];
        a1 = A[i][1];
        a2 = A[i][2];
        a3 = A[i][3];

        C[i][0] =
            a0 * B[0][0] +
            a1 * B[1][0] +
            a2 * B[2][0] +
            a3 * B[3][0];

        C[i][1] =
            a0 * B[0][1] +
            a1 * B[1][1] +
            a2 * B[2][1] +
            a3 * B[3][1];

        C[i][2] =
            a0 * B[0][2] +
            a1 * B[1][2] +
            a2 * B[2][2] +
            a3 * B[3][2];

        C[i][3] =
            a0 * B[0][3] +
            a1 * B[1][3] +
            a2 * B[2][3] +
            a3 * B[3][3];
    }
}


void mat4_mul(const m4 A, const m4 B, m4 C) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            int sum = 0;
            for (int k = 0; k < 4; k++) {
                sum += A[i][k] * B[k][j];
            }
            C[i][j] = sum;
        }
    }
}

static inline int mul_no_mul(int a, int b)
{
    int result = 0;

    int neg = 0;
    if (a < 0) { a = -a; neg ^= 1; }
    if (b < 0) { b = -b; neg ^= 1; }

    while (b != 0) {
        if (b & 1)
            result += a;
        a <<= 1;
        b >>= 1;
    }

    return neg ? -result : result;
}

void mat4_mul_no_mul(const m4 A, const m4 B, m4 C)
{
    for (int i = 0; i < 4; i++) {

        int a0 = A[i][0];
        int a1 = A[i][1];
        int a2 = A[i][2];
        int a3 = A[i][3];

        for (int j = 0; j < 4; j++) {

            C[i][j] =
                mul_no_mul(a0, B[0][j]) +
                mul_no_mul(a1, B[1][j]) +
                mul_no_mul(a2, B[2][j]) +
                mul_no_mul(a3, B[3][j]);
        }
    }
}



void mem_test(int* arr){
    int words = RAM_SIZE / 4;

    for (int i = 0; i < words; i++) {
        arr[i] = i;
    }

    for (int i = 0; i < words; i++) {
        if (arr[i] != i) {
            arr[i] = 0xFFFFF;
            while (1);
        }
    }
}

void matrix(int* arr){
    m4 A, B, C;

    for(int i = 0; i<4; i++){
        for(int j = 0; j<4; j++){
            A[i][j] = arr[i*4+j];
            B[i][j] = arr[16+i*4+j];
        }
    }

    mat4_mul(A, B, C);

    for(int i = 0; i<4; i++){
        for(int j = 0; j<4; j++){
            arr[32+i*4+j] = C[i][j];
        }
    }
}

void main()
{
    int* arr = (int*)(ARRAY_ADDR)+1;

    //mem_test(arr);
    matrix(arr);

}
