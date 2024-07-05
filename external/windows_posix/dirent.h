#pragma once
#include <stdint.h>

struct DIR_s;
typedef struct DIR_s DIR;

struct dirent {
	uintptr_t d_handle;	
	char d_name[260];
};

DIR* opendir(const char* name);
int closedir(DIR* dirp);
struct dirent* readdir(DIR* dirp);
