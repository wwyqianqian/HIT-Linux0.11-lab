#include <string.h>
#include <errno.h>
#include <asm/segment.h>

char username[24] = "";
int sys_iam(const char * name) {
    int n = 0, i;
    char temp[32];
    for (i = 0; i < 32; i++) {
        temp[i] = get_fs_byte(&name[i]);
	if (temp[i] != '\0')
	    n++;
 	else
	    break;
    }  
    if (n < 24)
	strcpy(username, temp);
    else
	n = -EINVAL;
    return n;
}

int sys_whoami(char * name, unsigned int size) { 
    int n = strlen(username), i;
    if (n < size) {
	for (i = 0; i < n; i++) {
	    put_fs_byte(username[i], &name[i]);
        }
    }
    else
	n = -EINVAL;
    return n;
}

