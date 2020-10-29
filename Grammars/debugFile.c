

#include <stdio.h>

double Heap[16384]; //Estructura para heap 
double Stack[16394]; //Estructura para stack 
double p = 4; // Puntero p
double h = 4; // Puntero h
double _t0, _t1, _t2, _t3, _t4, _t5, _t6, _t7, _t8, _t9, _t10, _t11, _t12, _t13, _t14, _t15, _t16, _t17, _t18, _t19, _t20, _t21, _t22, _t23, _t24, _t25, _t26, _t27, _t28, _t29, _t30, _t31, _t32, _t33, _t34, _t35, _t36, _t37, _t38, _t39, _t40, _t41, _t42, _t43, _t44, _t45, _t46, _t47, _t48, _t49, _t50, _t51, _t52, _t53, _t54, _t55, _t56, _t57, _t58, _t59, _t60, _t61, _t62, _t63, _t64; //Lista de temporales utilizados 





int main()
{
    Stack[(int)p - 2] = 0;
    Heap[2] = -1;
    
    Heap[3] = 0;
	
    

	// Expresion para i
	_t0 = 0;
	// Apuntador hacia espacio en variable i
	_t1 = p - 4;
	// Asignando valor a variable i
	Stack[(int)_t1] = 0;
	
	L1:
	// Expresion para i
	_t2 = p - 2;
	_t3 = Stack[(int)_t2];
	
	L2:
		_t3 = _t3 + 1;
		_t4 = Heap[(int)_t3];
	if(_t4 != -1) goto L2;
	
	_t3 = _t3 + 1;
	
	_t5 = _t3 + 0;
	_t6 = Heap[(int)_t5];
	_t7 = Stack[(int)_t6];
	// 1
	_t8 = _t7 + 1;
	
	// Apuntador hacia espacio en variable i
	_t9 = p - 2;
	_t10 = Stack[(int)_t9];
	
	L3:
		_t10 = _t10 + 1;
		_t11 = Heap[(int)_t10];
	if(_t11 != -1) goto L3;
	
	_t10 = _t10 + 1;
	
	_t12 = _t10 + 0;
	_t13 = Heap[(int)_t12];
	_t14 = Stack[(int)_t13];
	
	// Asignando valor a variable i
	Stack[(int)_t13] = _t8;
	
	// Expresion para a
	_t15 = 0;
	// Apuntador hacia espacio en variable a
	_t16 = p - 3;
	// Asignando valor a variable a
	Stack[(int)_t16] = 0;
	
	L5:
	_t17 = p - 2;
	_t18 = Stack[(int)_t17];
	
	L6:
		_t18 = _t18 + 1;
		_t19 = Heap[(int)_t18];
	if(_t19 != -1) goto L6;
	
	_t18 = _t18 + 1;
	
	_t20 = _t18 + 1;
	_t21 = Heap[(int)_t20];
	_t22 = Stack[(int)_t21];
	// 3
	if (_t22 < 3) goto L7;
	goto L8;
	L7:
	_t23 = 1;
	goto L9;
	L8:
	_t23 = 0;
	L9:
	
	if (_t23 == 0) goto L4;
	// Expresion para a
	_t24 = p - 2;
	_t25 = Stack[(int)_t24];
	
	L10:
		_t25 = _t25 + 1;
		_t26 = Heap[(int)_t25];
	if(_t26 != -1) goto L10;
	
	_t25 = _t25 + 1;
	
	_t27 = _t25 + 1;
	_t28 = Heap[(int)_t27];
	_t29 = Stack[(int)_t28];
	// 1
	_t30 = _t29 + 1;
	
	// Apuntador hacia espacio en variable a
	_t31 = p - 2;
	_t32 = Stack[(int)_t31];
	
	L11:
		_t32 = _t32 + 1;
		_t33 = Heap[(int)_t32];
	if(_t33 != -1) goto L11;
	
	_t32 = _t32 + 1;
	
	_t34 = _t32 + 1;
	_t35 = Heap[(int)_t34];
	_t36 = Stack[(int)_t35];
	
	// Asignando valor a variable a
	Stack[(int)_t35] = _t30;
	
	_t37 = p - 2;
	_t38 = Stack[(int)_t37];
	
	L12:
		_t38 = _t38 + 1;
		_t39 = Heap[(int)_t38];
	if(_t39 != -1) goto L12;
	
	_t38 = _t38 + 1;
	
	_t40 = _t38 + 1;
	_t41 = Heap[(int)_t40];
	_t42 = Stack[(int)_t41];
	
	printf("%d", (int)_t42);
	printf("\n");
	
	_t43 = 7;
	printf("%d", (int)7);
	printf("\n");
	
	
	goto L5;
	L4:
	
	
	_t44 = p - 2;
	_t45 = Stack[(int)_t44];
	
	L13:
		_t45 = _t45 + 1;
		_t46 = Heap[(int)_t45];
	if(_t46 != -1) goto L13;
	
	_t45 = _t45 + 1;
	
	_t47 = _t45 + 0;
	_t48 = Heap[(int)_t47];
	_t49 = Stack[(int)_t48];
	// 3
	if (_t49 == 3) goto L14;
	goto L15;
	L14:
	_t50 = 1;
	goto L16;
	L15:
	_t50 = 0;
	L16:
	
	if (_t50 == 0) goto L17;
	
	// break
	
		goto L0;
	
	
	goto L18;
	L17:
	L18:
	
	_t51 = p - 2;
	_t52 = Stack[(int)_t51];
	
	L19:
		_t52 = _t52 + 1;
		_t53 = Heap[(int)_t52];
	if(_t53 != -1) goto L19;
	
	_t52 = _t52 + 1;
	
	_t54 = _t52 + 0;
	_t55 = Heap[(int)_t54];
	_t56 = Stack[(int)_t55];
	
	printf("%d", (int)_t56);
	printf("\n");
	
	_t57 = 9;
	printf("%d", (int)9);
	printf("\n");
	
	
	_t58 = p - 2;
	_t59 = Stack[(int)_t58];
	
	L20:
		_t59 = _t59 + 1;
		_t60 = Heap[(int)_t59];
	if(_t60 != -1) goto L20;
	
	_t59 = _t59 + 1;
	
	_t61 = _t59 + 0;
	_t62 = Heap[(int)_t61];
	_t63 = Stack[(int)_t62];
	// 5
	if (_t63 < 5) goto L21;
	goto L22;
	L21:
	_t64 = 1;
	goto L23;
	L22:
	_t64 = 0;
	L23:
	
	if (_t64 == 1) goto L1;
	L0:
	
	

    return 0;
}

