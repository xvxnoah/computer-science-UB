#include <string.h>

int main(int argc, char* argv[]){
  if(argc >= 2){
    if(!strcmp(argv[1], "ten")){
      return 10;
    }
    else if (!strcmp(argv[1], "twenty")){
      return 20;
    }
  }
  return 100;
}
