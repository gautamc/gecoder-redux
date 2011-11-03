/* Copyright (c) 2005-2007 Diego Pettenò <flameeyes@gmail.com>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include "cwrapper.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

test_wrapper_t *cwrapper_alloc() {
  test_wrapper_t *instance = malloc(sizeof(struct test_wrapper_s));

  instance->integer = 1985;
  instance->string = malloc(256);
  instance->string[0] = '\0';

  fprintf(stderr, "created: %p\n", instance);

  return instance;
}

uint32_t cwrapper_get_integer(test_wrapper_t *instance) {
  fprintf(stderr, "instance: %p\n", instance);
  return instance->integer;
}

const char *cwrapper_get_string(test_wrapper_t *instance) {
  fprintf(stderr, "instance: %p\n", instance);
  return instance->string;
}

int cwrapper_set_string(test_wrapper_t *instance, const char *string) {
  fprintf(stderr, "instance: %p\n", instance);
  if (strlen(string) > 255) return 0;

  strncpy(instance->string, string, 255);

  return 1;
}

void cwrapper_set_integer(test_wrapper_t *instance, uint32_t integer) {
  fprintf(stderr, "instance: %p\n", instance);
  instance->integer = integer;
}

uint32_t cwrapper_get_default_integer() {
  return 1985;
}

void cwrapper_free(test_wrapper_t *instance) {
  fprintf(stderr, "instance: %p\n", instance);
  free(instance->string);
  free(instance);
}
