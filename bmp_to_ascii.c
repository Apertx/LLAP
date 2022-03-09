/* Author: Apertx
 * Compile: C4droid
 */

#include<fcntl.h>
#include<unistd.h>

unsigned long int
drawAscii(int fd, char *buf, unsigned char widthv) {
  const char *ASCII_ART = " .:,-^\"~_<=(/+si%YoSx*@8O$0XuK&#";
  char data[0x36];

  unsigned short int width;
  unsigned short int height;
  unsigned short int pixel;
  unsigned long int pixptr;
  unsigned short int offset;
  unsigned short int wi;
  unsigned short int hi;
  float widthr;
  float heightr;
  unsigned char ci;

  read(fd, data, 0x36);
  offset = *(data + 0x0A) - 0x36;
  read(fd, buf, offset);
  width = *(data + 0x12);
  height = *(data + 0x16);
  widthr = (float) width / widthv;
  heightr = height / widthr;
  pixptr = (2 * width + 1) * (height - 1);

  for(hi = 0; hi < height; hi += 1) {
    for(wi = 0; wi < width; wi += 1) {
      pixel = 0;
      for(ci = 0; ci < 3; ci++) {
	read(fd, data, 1);
	pixel += *data;
      }
      read(fd, data, 1);
      *(buf + pixptr) = ASCII_ART[pixel / 24];
      pixptr++;
      *(buf + pixptr) = ASCII_ART[pixel / 24];
      pixptr++;
    }
    *(buf + pixptr) = '\n';
    pixptr -= 4 * width + 1;
  }
  close(fd);
  return 2 * width * height + height;
}

int
main(void) {
  char buf[0x10000];
  unsigned long int len =
    drawAscii(open("/sdcard/images.bmp", O_RDONLY), buf, 120);
  write(1, buf, len);
  return 0;
}
