#ifndef PAC_SEMIHOST_DEF_H_INCLUDED
#define PAC_SEMIHOST_DEF_H_INCLUDED

#define SIZE	1024
#define FP_MAX	1024

#define SYS_TIME	1004
#define	SYS_WRITE	1005
#define	SYS_READ	1006
#define	SYS_OPEN	1007
#define	SYS_CLOSE	1008
#define	SYS_LSEEK	1009

#ifndef WIN32
#define	SYS_STAT	1010
#define	SYS_GETTIMEOFDAY	1011
#define	SYS_FSTAT	1012
#define	SYS_GETPID	1013
#define	SYS_UNLINK	1014
#define	SYS_LINK	1015
#endif

#define	NLIB_O_RDONLY	0x0000
#define	NLIB_O_WRONLY	0x0001
#define	NLIB_O_RDWR	0x0002
#define	NLIB_O_APPEND	0x0008
#define NLIB_O_CREAT	0x200	/* open with file create */
#define NLIB_O_TRUNC	0x400	/* open with truncation */
#define	NLIB_SEEK_SET	0
#define	NLIB_SEEK_CUR	1
#define	NLIB_SEEK_END	2

#define REG_ID		58	/* Cluser2 D2 */
#define PARAM_1		15	/* R15 */
#define PARAM_2		31	/* Cluster1 D15 */
#define PARAM_3		71	/* Cluster2 D15 */
#define RES_R		70	/* Cluster2 D14 */

#define RET_SUCCESS	0
#define RET_FAIL	-1

#endif
