#define __LIBRARY__
#include <unistd.h>
#include <errno.h>
#include <asm/segment.h>

_syscall1(int, iam, const char *, name);

int main(int argc, char * argv[]) {

    if(argc > 1 && iam(argv[1]) >= 0)
	return 0;

    return -1;
}
