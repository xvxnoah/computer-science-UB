#include <stdio.h>
const int MAX = 3;

int main () {

   int  var[] = {10, 100, 200};
   int  i, *ptr;

   /* let us have array address in pointer */
   ptr =  &var;
        
   for ( i = 0; i < MAX; i++) {

      printf("Address of var[%d] = %x\n", i, &var[i]);
      printf("Value of var[%d]  is %x\n", i, var[i]);      
      printf("Value of ptr for iteration %d is %x\n", i, ptr);
      printf("Value of ptr for iteration %d is %x\n", i, *ptr);

      *ptr += 1;  
      /* move to the next location */
      ptr++;
   }
        
   return 0;
}
