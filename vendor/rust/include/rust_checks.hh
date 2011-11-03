/* Copyright (c) 2007 David Cuadrado <krawek@gmail.com>
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

#ifndef __RUST_CHECKS__
#define __RUST_CHECKS__

#include <ruby.h>

static inline void rust_CheckType(VALUE *a)
{
	Check_Type(a[0], NUM2INT(a[1]));
}

static inline bool isType(VALUE val, int type)
{
  int result;
  if( type == 0x0 ) return false;
  
  VALUE args[2];
  args[0] = (VALUE)val;
  args[1] = INT2FIX(type);
  
  rb_protect( (VALUE(*)(VALUE))rust_CheckType, (VALUE)args, &result);
  return result == 0;
}


static inline bool is_object(VALUE val)
{
  return isType(val, T_OBJECT);
}

static inline bool is_class(VALUE val)
{
  return isType(val, T_CLASS);
}

static inline bool is_module(VALUE val)
{
  return isType(val, T_MODULE);
}

static inline bool is_fLoat(VALUE val)
{
  return isType(val, T_FLOAT);
}

static inline bool is_string(VALUE val)
{
  return isType(val, T_STRING);
}

static inline bool is_regexp(VALUE val)
{
  return isType(val, T_REGEXP);
}

static inline bool is_array(VALUE val)
{
  return isType(val, T_ARRAY);
}

static inline bool is_int(VALUE val)
{
  return isType(val, T_FIXNUM) || 
  	(isType(val, T_BIGNUM) && NUM2INT(val) < INT_MAX);
}

static inline bool is_hash(VALUE val)
{
  return isType(val, T_HASH);
}

static inline bool is_symbol(VALUE val)
{
  return isType(val, T_SYMBOL);
}

static inline bool is_bool(VALUE val)
{
  return val == Qtrue || val == Qfalse;
}

static inline bool is_charPtr(VALUE val)
{
  char *c = 0;
  c = reinterpret_cast<char *>(DATA_PTR(val));
  
  return c != 0; // FIXME
}




#endif 

