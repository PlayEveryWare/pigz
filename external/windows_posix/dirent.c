#include "dirent.h"
#include <io.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

struct DIR_s
{
	intptr_t handle;
	struct dirent entry;
	struct dirent next_entry;
};

static void parse_entry(struct dirent* entry, const struct __finddata64_t* data)
{
	static_assert(sizeof(entry->d_name) == sizeof(data->name));
	memcpy(entry->d_name, data->name, sizeof(entry->d_name));
}

DIR* opendir(const char* name) {
	char name_with_wildcard[260];
	struct __finddata64_t data;
	DIR* result;
	intptr_t handle;

	snprintf(name_with_wildcard, sizeof(name_with_wildcard), "%s/*", name);

	handle = _findfirst64(name_with_wildcard, &data);
	if (-1 == handle) {
		return NULL;
	}

	result = calloc(1, sizeof(struct DIR_s));
	if (!result) {
		_findclose(handle);
		errno = ENOMEM;
		return NULL;
	}

	result->handle = handle;
	parse_entry(&result->next_entry, &data);
	return result;
}

int closedir(DIR* dirp) {
	return _findclose(dirp->handle);
}

struct dirent* readdir(DIR* dirp) {
	struct __finddata64_t data;

	if (!dirp) {
		errno = EBADF;
		return NULL;
	}

	if (!dirp->next_entry.d_name[0]) {
		return NULL;
	}

	dirp->entry = dirp->next_entry;

	if (-1 == _findnext64(dirp->handle, &data)) {
		dirp->next_entry.d_name[0] = 0;
	}
	else {
		parse_entry(&dirp->next_entry, &data);
	}

	return &dirp->entry;
}
