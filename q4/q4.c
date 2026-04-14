#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

typedef int (*fptr)(int, int);

int main(){
while (1) {
    char function_name[7];
    int a,b;
    if(scanf("%s %d %d", function_name, &a, &b) != 3){
        return 0;
    }

    char sofile_name[20] = "./lib";
    int n = strlen(function_name);
    for (int i = 0; i < n; i++) {
        sofile_name[5+i] = function_name[i];
    }
    
    sofile_name[5+n] = '.';
    sofile_name[6+n] = 's';
    sofile_name[7+n] = 'o';
    sofile_name[8+n] = '\0';
    
    void* handle = dlopen(sofile_name, RTLD_LAZY);
    fptr function = dlsym(handle, function_name);

    int result = function(a,b);
    printf("%d\n", result);

    dlclose(handle);
}
return 0;
}