#ifndef _INIFILE_H_
#define _INIFILE_H_

/*
 * char* GetInitKey(FileName, Section, Key)
 * Return Key=>Value
 * Ex:
 *
 * + [config]
 * + dbhost=localhost
 *
 * strcpy(dbhost,GetInitKey("config.ini", "config", "dbhost"));
 */
char *getValue(char *filename, char *section, char *value)
{
	FILE * fp;
	char tmpLine[1024];
	int rtnval;
	int i = 0;
	int flag = 0;
	char * tmp;
	static char tmpstr[1024];

	if ((fp = fopen( filename, "r")) == NULL ) {
			return "have no such file";
	}

	while (!feof(fp)) {
		rtnval = fgetc(fp);
		if ( rtnval == EOF ) {
			break;
		} else {
			tmpLine[i++] = rtnval;
		}

		if (( rtnval == '\n') || (rtnval == '/')) {
			if (rtnval == '/') {
				rtnval = fgetc(fp);
				if (rtnval != '*') {
					tmpLine[i++] = rtnval;
					continue;
				}
			}
			
			tmpLine[--i]=0;
			i = 0;
			tmp = strchr(tmpLine, '=');
			
			if (( tmp != NULL ) && (flag == 1)) {
				if (strstr(tmpLine,value) != NULL) {
					if (strstr(tmp, " "))
						strtok(tmp, " ");
					else if(strstr(tmp, "\t")) {
						strtok(tmp, "\t");
					}

					strcpy (tmpstr, tmp + 1);
					fclose (fp);
					return tmpstr;
				}
			} else {
				strcpy(tmpstr,"[");
				strcat(tmpstr,section);
				strcat(tmpstr,"]");
				if (strcmp(tmpstr,tmpLine) == 0) {
					flag = 1;
				}
			}

		}
	}
	fclose ( fp );
	return "";
}
#endif //_INIFILE_H_
