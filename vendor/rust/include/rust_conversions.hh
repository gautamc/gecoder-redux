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

#ifndef __RUST_CONVERSIONS__
#define __RUST_CONVERSIONS__

#include <stdint.h>
#include <ruby.h>

/* Macros for 1.9 compatibility */
#ifndef RUBY_19
#ifndef RFLOAT_VALUE
#define RFLOAT_VALUE(v) (RFLOAT(v)->value)
#endif
#ifndef RARRAY_LEN
#define RARRAY_LEN(v) (RARRAY(v)->len)
#endif
#ifndef RARRAY_PTR
#define RARRAY_PTR(v) (RARRAY(v)->ptr)
#endif
#ifndef RSTRING_LEN
#define RSTRING_LEN(v) (RSTRING(v)->len)
#endif
#ifndef RSTRING_PTR
#define RSTRING_PTR(v) (RSTRING(v)->ptr)
#endif
#endif

/* Standard conversions for integer values */

static inline uint32_t ruby2uint(VALUE rval, int argn = -1) {
  return NUM2UINT(rval);
}

static inline int32_t ruby2int(VALUE rval, int argn = -1) {
  return NUM2INT(rval);
}

static inline VALUE cxx2ruby(int32_t val) {
  return INT2NUM(val);
}

static inline VALUE cxx2ruby(uint32_t val) {
  return INT2NUM(val);
}

static inline VALUE cxx2ruby(double val) {
  return rb_float_new(val);
}

/* Standard conversions for stdint-provided types */
/* TODO: replace these with something more comples but that properly
   handle a try to convert a number too big to stay into the size
   requested.
*/
#define ruby2uint32_t ruby2uint
#define ruby2uint16_t ruby2uint
#define ruby2uint8_t  ruby2uint

#define ruby2int32_t  ruby2int
#define ruby2int16_t  ruby2int
#define ruby2int8_t   ruby2int

/* Conversion for common types (like strings */

static inline int *ruby2intArray(VALUE rval, int argn = -1) {
  int i;
  RArray *array = RARRAY(rval);
  int* ret = (int*)malloc(RARRAY_LEN(array)*sizeof(int)); // FIXME: Leak!!!
  for(i = 0; i < RARRAY_LEN(array); i++)
  {
    ret[i] = NUM2INT(RARRAY_PTR(array)[i]);
  }
  return ret;
}

static inline char *ruby2charPtr(VALUE rval, int argn = -1) {
  Check_Type(rval, T_STRING);
  return StringValuePtr(rval);
}

static inline VALUE cxx2ruby(const char *val) {
  if ( ! val ) return Qnil;
  return rb_str_new2(val);
}

static inline VALUE cxx2ruby(const std::string &str) {
  return rb_str_new2(str.c_str());
}

/* Booleans conversion */

static inline VALUE cxx2ruby(bool val) {
  return val ? Qtrue : Qfalse;
}

static inline bool ruby2bool(VALUE rval, int argn = -1) {
  return !( rval == Qnil || rval == Qfalse );
}

#endif
