#ifndef CFGFILE_H_
#define CFGFILE_H_

#include "filesys.h"

extern char * make_hard_dir_cfg_line (char *dst);
extern char * make_hard_file_cfg_line (char *dst);
extern void parse_filesys_spec (int readonly, char *spec);
extern void parse_hardfile_spec (char *spec);

extern char uae4all_hard_dir[256];
extern char uae4all_hard_file[256];

extern uaedev_mount_info *currprefs_mountinfo;

void init_mountinfo();

#endif
