
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "gtest/gtest.h"


const char * multi =
  "\n"
  "    _  _     _  _  _  _  _ \n"
  "  | _| _||_||_ |_   ||_||_|\n"
  "  ||_  _|  | _||_|  ||_| _|\n"
  "\n"
  "    _  _     _  _  _  _  _ \n"
  "  | _| _||_||_ |_   ||_||_|\n"
  "  ||_  _|  | _||_|  ||_| _|\n"
  "\n";

const char* const lookupt[] = {
    " _ | ||_|", "     |  |", " _  _||_ ", " _  _| _|", "   |_|  |",
    " _ |_  _|", " _ |_ |_|", " _   |  |", " _ |_||_|", " _ |_| _|"
};

int lookup (const char * inp) {
  int num = -1;

  for (int i=0; i<10; i++) {
    if (strcmp(lookupt[i],inp) == 0) {
      num = i;
    }
  }
  return num;
}

int * parse (const char *inp) {
  // split input on \n
  char *token;
  char *in = strdup(inp);
  char *working = (char *) malloc(strlen(in));
  while ((token = strsep(&in, "\n")) != NULL) {
    if (strcmp(token,"") != 0) {
      strcat(working, strdup(token));
    }
  }
  free(in);

  // now with a long string we can pull blocks of 3*3
  div_t num_lines = div(strlen(working),(27*3));
  int *result = (int *) malloc(num_lines.quot * 9 * sizeof(int));
  if (result == NULL) {
    fprintf(stderr,"oom?\n");
    exit(1);
  }
  char *w = working;
  int count = 0;
  int line = 0;

  while (*working != '\0') {

    char num[9+1] = "";
    strncat(num, working, 3);
    strncat(num, working+27, 3);
    strncat(num, working+(27*2), 3);
    result[(line*9)+count] = lookup(num);

    if ((count+1) % 9 == 0) {
      if (*(working+3+(27*2)) != '\0') {
        working = working + 3 + (27*2); // end of the line so skip to next block
      }
      count = 0;
      line += 1;
    } else {
      working = working + 3;
      count += 1;
    }

  }

  free(w);

  return result;
}

TEST(story1,FindingNumbers){
  ASSERT_EQ(lookup("     |  |"),1);
  ASSERT_EQ(lookup("     |   "),-1);
}
TEST(story1,ValidLine){
  int expect[] = {1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9};
  int num_lines = 2;
  int *result = parse(multi);

  for (int j=0; j<2*9; j++) {
    ASSERT_EQ(expect[j],result[j]);
  }

  free(result);
}

int main(int argc, char **argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
