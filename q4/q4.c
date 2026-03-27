#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

typedef int (*fptr)(int, int);

int main(){
    char function_name[7];
    int a,b;
    scanf("%s %d %d", function_name, &a, &b);

    char sofile_name[12] = "./lib";
    int n = strlen(function_name);
    for (int i = 0; i < n; i++) {
        sofile_name[5+i] = function_name[i];
    }
    sofile_name[5+n] = '\0';
    
    void* handle = dlopen(sofile_name, RTLD_LAZY);
    fptr function = dlsym(handle, function_name);

    int result = function(a,b);
    printf("%d\n", result);

    dlclose(handle);
return 0;
}