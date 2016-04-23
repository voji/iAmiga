#ifndef FILESYS_H_
#define FILESYS_H_


/*
  * UAE - The Un*x Amiga Emulator
  *
  * Unix file system handler for AmigaDOS
  *
  * Copyright 1997 Bernd Schmidt
  */

#define FILESYS_VIRTUAL 0
#define FILESYS_HARDFILE 1
#define FILESYS_HARDFILE_RDB 2
#define FILESYS_HARDDRIVE 3

struct hardfiledata {
    unsigned long size;
    int nrcyls;
    int secspertrack;
    int surfaces;
    int reservedblocks;
    int blocksize;
    FILE *fd;
};
#ifdef WIN32
int truncate (const char *name, long int len);
#endif

struct uaedev_mount_info;

extern struct hardfiledata *get_hardfile_data (int nr);
extern int kill_filesys_unit (struct uaedev_mount_info *mountinfo, int nr);
extern int nr_units (struct uaedev_mount_info *mountinfo);
extern char *get_filesys_unit (struct uaedev_mount_info *mountinfo, int nr,
                        char **volname, char **rootdir, int *readonly,
                        int *secspertrack, int *surfaces, int *reserved,
                        int *cylinders, int *size, int *blocksize);

#endif