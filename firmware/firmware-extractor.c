#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

int is_base64(const char c) {
	if ( (c >= 'A' && c <= 'Z') || 
		(c >= 'a' && c <= 'z') || 
          (c >= '0' && c <= '9') ||
	      c == '+' || 
	      c == '/' || 
	      c == '=') return 1;
	return 0;
}

void cleanup_base64(char *inp, const unsigned int size) {
	unsigned int i;
    char *tinp1,*tinp2;
	tinp1 = inp;
     tinp2 = inp;
     for (i = 0; i < size; i++) {
     	if (is_base64(*tinp2)) {
          	*tinp1++ = *tinp2++;
          }
          else {
          	*tinp1 = *tinp2++;
          }
     }
     *(tinp1) = 0;
}

unsigned char decode_base64_char(const char c) {
	if (c >= 'A' && c <= 'Z') return c - 'A';
	if (c >= 'a' && c <= 'z') return c - 'a' + 26;
	if (c >= '0' && c <= '9') return c - '0' + 52;
	if (c == '+') return 62;
     if (c == '=') return 0;
	return 63;   
}

void decode_base64(const char *inp, unsigned int isize, 
			char *out, unsigned int *osize) {
    unsigned int i;
     char *tinp = (char*)inp; 
     char *tout;
     *osize = isize / 4 * 3;
    tout = tinp;
     for(i = 0; i < isize >> 2; i++) {
		*tout++ = (decode_base64_char(*tinp++) << 2) | (decode_base64_char(*tinp) >> 4);
          *tout++ = (decode_base64_char(*tinp++) << 4) | (decode_base64_char(*tinp) >> 2);
          *tout++ = (decode_base64_char(*tinp++) << 6) | decode_base64_char(*tinp++);
	}
     if (*(tinp-1) == '=') (*osize)--;
     if (*(tinp-2) == '=') (*osize)--;
}


char * find_string(char * string, char * sub_string)
{
    size_t sub_s_len;

    sub_s_len = strlen(sub_string);

    while (*string)
    {
        if (strncmp(string, sub_string, sub_s_len) == 0)
        {
            return string;
        }
        string++;
    }

    return NULL;
}

int main(int argc, const char ** argv)
{
    FILE * iphone_mtprops;
    size_t file_len;
    char * buffer;
    char * p;

    char * a_speed_firmware;
    size_t a_speed_fw_len;
    size_t final_a_speed_fw_len;
    char * firmware;
    size_t fw_len;
    size_t final_fw_len;

    FILE * output;

    iphone_mtprops = fopen("iPhone.mtprops", "r");
    assert(iphone_mtprops != NULL);
    fseek(iphone_mtprops, 0, SEEK_END);
    file_len = ftell(iphone_mtprops);

    buffer = (char *)malloc(sizeof(char) * file_len);
    fseek(iphone_mtprops, 0, SEEK_SET);
    fread(buffer, file_len, 1, iphone_mtprops);

    fclose(iphone_mtprops);

    p = find_string(buffer, "<key>A-Speed Firmware</key>");
    assert(p != NULL);

    while (*p)
    {
        if (*p == '\n')
        {
            break;
        }
        p++;
    }
    while (*p)
    {
        if (*p == '>')
        {
            break;
        }
        p++;
    }

    p++;

    a_speed_firmware = p;

    while (*p)
    {
        if (*p == '<')
        {
            break;
        }
        p++;
    }
    a_speed_fw_len = p - a_speed_firmware;

    p = find_string(p, "<key>Firmware</key>");
    assert(p != NULL);

    while (*p)
    {
        if (*p == '\n')
        {
            break;
        }
        p++;
    }
    while (*p)
    {
        if (*p == '>')
        {
            break;
        }
        p++;
    }

    p++;

    firmware = p;

    while (*p)
    {
        if (*p == '<')
        {
            break;
        }
        p++;
    }
    fw_len = p - firmware;



    cleanup_base64(firmware, fw_len);
    decode_base64(firmware, fw_len, firmware, (unsigned int *)&final_fw_len);

    output = fopen("zephyr_main.bin", "a+");
    fwrite(firmware, final_fw_len, 1, output);
    fclose(output);





    cleanup_base64(a_speed_firmware, a_speed_fw_len);
    decode_base64(a_speed_firmware, a_speed_fw_len, a_speed_firmware, (unsigned int *)&final_a_speed_fw_len);

    output = fopen("zephyr_aspeed.bin", "a+");
    fwrite(a_speed_firmware, final_a_speed_fw_len, 1, output);
    fclose(output);



    free(buffer);


    return 0;
}

