void __call_printString___string_ (){
	
	
	// Apuntador hacia espacio en variable value
	_t8 = p - 2;
	_t9 = Stack[(int)_t8];

  	
  	L4:
  	_t9= _t9 + 1;
  	_t11 = Heap[(int)_t9];
  	
  	if(_t11 == -1) goto L5;
	if(_t11 == -2)goto L6; 
  	printf("%c", (int)_t11);
	L6: 

	_t9= _t9 + 1;
  	_t11 = Heap[(int)_t9];
	printf("%d", _t11);


  	goto L4;
   
  	L5:
  
	
	L3:
	return;
}

	
void power_number_number_ (){
	
	_t2 = p - 3;
	_t3 = Stack[(int)_t2];
	// 0
	if (_t3 <= 0) goto L4;
	goto L5;
	L4:
	_t4 = 1;
	goto L6;
	L5:
	_t4 = 0;
	L6:
	
	if (_t4 == 0) goto L7;
	_t5 = 1;
		// Return
	
	_t6 = p - 1;
	
	Stack[(int)_t6] = 1;
	
		goto L3;
	
	
	goto L8;
	L7:
	L8:
	
	// Expresion para a
	_t7 = p - 2;
	_t8 = Stack[(int)_t7];
	
	// Apuntador hacia espacio en variable a
	_t9 = p + 0;
	// Asignando valor a variable a
	Stack[(int)_t9] = _t8;
	
	// Expresion para pot
	_t10 = p - 3;
	_t11 = Stack[(int)_t10];
	// 1
	_t12 = _t11 - 1;
	
	// Apuntador hacia espacio en variable pot
	_t13 = p - 3;
	_t14 = Stack[(int)_t13];
	
	// Asignando valor a variable pot
	Stack[(int)_t13] = _t12;
	
	L10:
	_t15 = p - 3;
	_t16 = Stack[(int)_t15];
	// 0
	if (_t16 > 0) goto L11;
	goto L12;
	L11:
	_t17 = 1;
	goto L13;
	L12:
	_t17 = 0;
	L13:
	
	if (_t17 == 0) goto L9;
	// Expresion para a
	_t18 = p + 0;
	_t19 = Stack[(int)_t18];
	_t20 = p - 2;
	_t21 = Stack[(int)_t20];
	_t22 = _t19 * _t21;
	
	// Apuntador hacia espacio en variable a
	_t23 = p + 0;
	_t24 = Stack[(int)_t23];
	
	// Asignando valor a variable a
	Stack[(int)_t23] = _t22;
	
	// Expresion para pot
	_t25 = p - 3;
	_t26 = Stack[(int)_t25];
	// 1
	_t27 = _t26 - 1;
	
	// Apuntador hacia espacio en variable pot
	_t28 = p - 3;
	_t29 = Stack[(int)_t28];
	
	// Asignando valor a variable pot
	Stack[(int)_t28] = _t27;
	
	
	goto L10;
	L9:
	
	
	_t30 = p + 0;
	_t31 = Stack[(int)_t30];
	
		// Return
	
	_t32 = p - 1;
	
	Stack[(int)_t32] = _t31;
	
		goto L3;
	
	L3:
	return;
}


let a = 839
 while(a!=0)
    {
        let b=a%10;

        a=(a-b)/10;
        console.log(b) 

    }





		
void __call_concatString___number_string_ (){
	
	// number
	#_t0 = p - 2;
	#_t1 = Stack[(int)#_t0];
	
	//string
	#_t2 = p - 3;
	#_t3 = Stack[(int)#_t2];

	//contador
	#_t4 = 0

	// nuevo string
	#_t5 = h;
	#_t6 = #_t5 + 1;

	//number to string
	if(#t1 > -1) goto #L1;
		#_t1 = #_t1 - 1
	goto #L2:
	#L1: 
		#_t1 = #_t1 + 1000
	#L2:



	Heap[(int) #_t6] = #_t1;   // number pos 1
	#_t6 = #_t6 + 1;
	
	// #_t4 = #_t4 + 1;			// contador  + 1

	#L3:
	#_t7 = #_t3 + 1;
	#_t8 = Heap[(int) #_t7 ]; 
	if(#_t8 == -1) goto L4;

	Heap[(int) #_t6] = #_t8;
	#_t6 = #_t6 + 1;

	goto #L3;
	#L4:


	#_t9 = Heap[(int) #_t3 ]; 
	#_t9 = #_t9 + 1;

	Heap[(int) #_t5] = #_t9;   // length 
	
	
	Heap[(int) #_t6] = -1;    // null
	#_t6 = #_t6 + 1;
	h = #_t6;
	

	#_t10 = p - 1;
	Stack[(int) #_t10] = #_t5;
	
	L7:
	return;
}



	// string
	#_t0 = p - 2;
	#_t1 = Stack[(int)#_t0];
	
	//string
	#_t2 = p - 3;
	#_t3 = Stack[(int)#_t2];


	// nuevo string
	#_t5 = h;
	#_t6 = #_t5 + 1;

	

	#_t4 = #_t1;
	#L1:
	#_t4 = #_t4 + 1;
	#_t12 = Heap[(int) #_t4]; 
	if(#_t12 == -1) goto #L2;

	Heap[(int) #_t6] = #_t12;
	#_t6 = #_t6 + 1;

	goto #L1;
	#L2:
	
	

	#_t7 = #_t3;
	#L3:
	#_t7 = #_t7 + 1;
	#_t8 = Heap[(int) #_t7]; 
	if(#_t8 == -1) goto #L4;

	Heap[(int) #_t6] = #_t8;
	#_t6 = #_t6 + 1;

	goto #L3;
	#L4:


	#_t9 = Heap[(int) #_t1]; 
	#_t10 = Heap[(int) #_t3]; 
	#_t9 = #_t9 + #_t10;

	Heap[(int) #_t5] = #_t9;   // length 
	
	
	Heap[(int) #_t6] = -1;    // null
	#_t6 = #_t6 + 1;
	h = #_t6;
	

	#_t11 = p - 1;
	Stack[(int) #_t11] = #_t5;
	







	// String to lowercase

	
	// string
	#_t0 = p - 2;
	#_t1 = Stack[(int)#_t0];
	

	// nuevo string
	#_t2 = h;

	// length
	#_t3 = Heap[(int) #_t1]; 
	Heap[(int) #_t2] = #_t3;
	#_t4 = #_t2 + 1;

	

	#_t5 = #_t1;
	#L1:
	#_t5 = #_t5 + 1;
	#_t6 = Heap[(int) #_t5]; 
	if(#_t6 == -1) goto #L2;


	if(#_t6 < 65) goto #L3;
	if(#_t6 > 90) goto #L3;

	#_t6 = #_t6 + 32;

	#L3:


	Heap[(int) #_t4] = #_t6;
	#_t4 = #_t4 + 1;




	goto #L1;
	#L2:
	
	
	Heap[(int) #_t4] = -1;    // null
	#_t4 = #_t4 + 1;
	h = #_t4;
	

	#_t7 = p - 1;
	Stack[(int) #_t7] = #_t2;