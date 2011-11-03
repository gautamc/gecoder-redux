
#include <string>

#include "gecode.hh"

#ifdef DEBUG
#include <stdio.h> /* Used for fprintf */
#endif

namespace Rust_gecode {

#include <rust_conversions.hh>
#include <rust_checks.hh>



bool is_Gecode_IntArgs(VALUE arr)
{
  return is_array(arr);
}

Gecode::IntArgs ruby2Gecode_IntArgs(VALUE arr, int argn = -1);
Gecode::IntArgs ruby2Gecode_IntArgs(VALUE arr, int argn)
{
  RArray *array = RARRAY(arr);
  Gecode::IntArgs intargs(RARRAY_LEN(array));
  for(int i = 0; i < RARRAY_LEN(array); i++)
  {
    intargs[i] = NUM2INT(RARRAY_PTR(array)[i]);
  }
  
  return intargs;
}

  static void Gecode_MSpace_custom_mark(void *p) {
    Gecode_MSpace_mark(p);
    ((Gecode::MSpace*)p)->gc_mark();
  }
  
  static void Gecode_MIntVarArray_custom_mark(void *p) {
    Gecode_MIntVarArray_mark(p);
    ((Gecode::MIntVarArray*)p)->gc_mark();
  }
  
  static void Gecode_MBoolVarArray_custom_mark(void *p) {
    Gecode_MBoolVarArray_mark(p);
    ((Gecode::MBoolVarArray*)p)->gc_mark();
  }
  
  static void Gecode_MSetVarArray_custom_mark(void *p) {
    Gecode_MSetVarArray_mark(p);
    ((Gecode::MSetVarArray*)p)->gc_mark();
  }



VALUE rGecodeRaw;

Gecode::IntVarBranch ruby2Gecode_IntVarBranch(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::INT_VAR_NONE:
case Gecode::INT_VAR_MIN_MIN:
case Gecode::INT_VAR_MIN_MAX:
case Gecode::INT_VAR_MAX_MIN:
case Gecode::INT_VAR_MAX_MAX:
case Gecode::INT_VAR_SIZE_MIN:
case Gecode::INT_VAR_SIZE_MAX:
case Gecode::INT_VAR_DEGREE_MAX:
case Gecode::INT_VAR_DEGREE_MIN:
case Gecode::INT_VAR_REGRET_MIN_MIN:
case Gecode::INT_VAR_REGRET_MIN_MAX:
case Gecode::INT_VAR_REGRET_MAX_MIN:
case Gecode::INT_VAR_REGRET_MAX_MAX:
      return static_cast<Gecode::IntVarBranch>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum IntVarBranch is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum IntVarBranch is out of bound", cval);
      return static_cast<Gecode::IntVarBranch>(-1);
  }
}

bool is_Gecode_IntVarBranch(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::INT_VAR_NONE:
case Gecode::INT_VAR_MIN_MIN:
case Gecode::INT_VAR_MIN_MAX:
case Gecode::INT_VAR_MAX_MIN:
case Gecode::INT_VAR_MAX_MAX:
case Gecode::INT_VAR_SIZE_MIN:
case Gecode::INT_VAR_SIZE_MAX:
case Gecode::INT_VAR_DEGREE_MAX:
case Gecode::INT_VAR_DEGREE_MIN:
case Gecode::INT_VAR_REGRET_MIN_MIN:
case Gecode::INT_VAR_REGRET_MIN_MAX:
case Gecode::INT_VAR_REGRET_MAX_MIN:
case Gecode::INT_VAR_REGRET_MAX_MAX:
        return true;
    }
  }
  
  return false;
}

Gecode::IntValBranch ruby2Gecode_IntValBranch(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::INT_VAL_MIN:
case Gecode::INT_VAL_MED:
case Gecode::INT_VAL_MAX:
case Gecode::INT_VAL_SPLIT_MIN:
case Gecode::INT_VAL_SPLIT_MAX:
      return static_cast<Gecode::IntValBranch>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum IntValBranch is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum IntValBranch is out of bound", cval);
      return static_cast<Gecode::IntValBranch>(-1);
  }
}

bool is_Gecode_IntValBranch(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::INT_VAL_MIN:
case Gecode::INT_VAL_MED:
case Gecode::INT_VAL_MAX:
case Gecode::INT_VAL_SPLIT_MIN:
case Gecode::INT_VAL_SPLIT_MAX:
        return true;
    }
  }
  
  return false;
}

Gecode::SetVarBranch ruby2Gecode_SetVarBranch(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::SET_VAR_NONE:
case Gecode::SET_VAR_MIN_CARD:
case Gecode::SET_VAR_MAX_CARD:
case Gecode::SET_VAR_MIN_UNKNOWN_ELEM:
case Gecode::SET_VAR_MAX_UNKNOWN_ELEM:
      return static_cast<Gecode::SetVarBranch>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum SetVarBranch is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum SetVarBranch is out of bound", cval);
      return static_cast<Gecode::SetVarBranch>(-1);
  }
}

bool is_Gecode_SetVarBranch(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::SET_VAR_NONE:
case Gecode::SET_VAR_MIN_CARD:
case Gecode::SET_VAR_MAX_CARD:
case Gecode::SET_VAR_MIN_UNKNOWN_ELEM:
case Gecode::SET_VAR_MAX_UNKNOWN_ELEM:
        return true;
    }
  }
  
  return false;
}

Gecode::SetValBranch ruby2Gecode_SetValBranch(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::SET_VAL_MIN:
case Gecode::SET_VAL_MAX:
      return static_cast<Gecode::SetValBranch>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum SetValBranch is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum SetValBranch is out of bound", cval);
      return static_cast<Gecode::SetValBranch>(-1);
  }
}

bool is_Gecode_SetValBranch(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::SET_VAL_MIN:
case Gecode::SET_VAL_MAX:
        return true;
    }
  }
  
  return false;
}

Gecode::IntRelType ruby2Gecode_IntRelType(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::IRT_EQ:
case Gecode::IRT_NQ:
case Gecode::IRT_LQ:
case Gecode::IRT_LE:
case Gecode::IRT_GQ:
case Gecode::IRT_GR:
      return static_cast<Gecode::IntRelType>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum IntRelType is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum IntRelType is out of bound", cval);
      return static_cast<Gecode::IntRelType>(-1);
  }
}

bool is_Gecode_IntRelType(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::IRT_EQ:
case Gecode::IRT_NQ:
case Gecode::IRT_LQ:
case Gecode::IRT_LE:
case Gecode::IRT_GQ:
case Gecode::IRT_GR:
        return true;
    }
  }
  
  return false;
}

Gecode::BoolOpType ruby2Gecode_BoolOpType(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::BOT_AND:
case Gecode::BOT_OR:
case Gecode::BOT_IMP:
case Gecode::BOT_EQV:
case Gecode::BOT_XOR:
      return static_cast<Gecode::BoolOpType>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum BoolOpType is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum BoolOpType is out of bound", cval);
      return static_cast<Gecode::BoolOpType>(-1);
  }
}

bool is_Gecode_BoolOpType(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::BOT_AND:
case Gecode::BOT_OR:
case Gecode::BOT_IMP:
case Gecode::BOT_EQV:
case Gecode::BOT_XOR:
        return true;
    }
  }
  
  return false;
}

Gecode::SetRelType ruby2Gecode_SetRelType(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::SRT_EQ:
case Gecode::SRT_NQ:
case Gecode::SRT_SUB:
case Gecode::SRT_SUP:
case Gecode::SRT_DISJ:
case Gecode::SRT_CMPL:
      return static_cast<Gecode::SetRelType>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum SetRelType is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum SetRelType is out of bound", cval);
      return static_cast<Gecode::SetRelType>(-1);
  }
}

bool is_Gecode_SetRelType(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::SRT_EQ:
case Gecode::SRT_NQ:
case Gecode::SRT_SUB:
case Gecode::SRT_SUP:
case Gecode::SRT_DISJ:
case Gecode::SRT_CMPL:
        return true;
    }
  }
  
  return false;
}

Gecode::SetOpType ruby2Gecode_SetOpType(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::SOT_UNION:
case Gecode::SOT_DUNION:
case Gecode::SOT_INTER:
case Gecode::SOT_MINUS:
      return static_cast<Gecode::SetOpType>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum SetOpType is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum SetOpType is out of bound", cval);
      return static_cast<Gecode::SetOpType>(-1);
  }
}

bool is_Gecode_SetOpType(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::SOT_UNION:
case Gecode::SOT_DUNION:
case Gecode::SOT_INTER:
case Gecode::SOT_MINUS:
        return true;
    }
  }
  
  return false;
}

Gecode::IntConLevel ruby2Gecode_IntConLevel(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::ICL_VAL:
case Gecode::ICL_BND:
case Gecode::ICL_DOM:
case Gecode::ICL_DEF:
      return static_cast<Gecode::IntConLevel>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum IntConLevel is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum IntConLevel is out of bound", cval);
      return static_cast<Gecode::IntConLevel>(-1);
  }
}

bool is_Gecode_IntConLevel(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::ICL_VAL:
case Gecode::ICL_BND:
case Gecode::ICL_DOM:
case Gecode::ICL_DEF:
        return true;
    }
  }
  
  return false;
}

Gecode::PropKind ruby2Gecode_PropKind(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::PK_DEF:
case Gecode::PK_SPEED:
case Gecode::PK_MEMORY:
      return static_cast<Gecode::PropKind>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum PropKind is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum PropKind is out of bound", cval);
      return static_cast<Gecode::PropKind>(-1);
  }
}

bool is_Gecode_PropKind(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::PK_DEF:
case Gecode::PK_SPEED:
case Gecode::PK_MEMORY:
        return true;
    }
  }
  
  return false;
}

Gecode::SpaceStatus ruby2Gecode_SpaceStatus(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::SS_FAILED:
case Gecode::SS_SOLVED:
case Gecode::SS_BRANCH:
      return static_cast<Gecode::SpaceStatus>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum SpaceStatus is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum SpaceStatus is out of bound", cval);
      return static_cast<Gecode::SpaceStatus>(-1);
  }
}

bool is_Gecode_SpaceStatus(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::SS_FAILED:
case Gecode::SS_SOLVED:
case Gecode::SS_BRANCH:
        return true;
    }
  }
  
  return false;
}

Gecode::IntAssign ruby2Gecode_IntAssign(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::INT_ASSIGN_MIN:
case Gecode::INT_ASSIGN_MED:
case Gecode::INT_ASSIGN_MAX:
      return static_cast<Gecode::IntAssign>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum IntAssign is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum IntAssign is out of bound", cval);
      return static_cast<Gecode::IntAssign>(-1);
  }
}

bool is_Gecode_IntAssign(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::INT_ASSIGN_MIN:
case Gecode::INT_ASSIGN_MED:
case Gecode::INT_ASSIGN_MAX:
        return true;
    }
  }
  
  return false;
}

VALUE rGecode_MIntVarArray;

bool is_Gecode_MIntVarArray(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MIntVarArray *obj = 0;
    
    Data_Get_Struct(val, Gecode::MIntVarArray, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MIntVarArray) == Qtrue;
  }
  
  return false;
}

Gecode::MIntVarArray* ruby2Gecode_MIntVarArrayPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MIntVarArray(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MIntVarArray given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MIntVarArray given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MIntVarArray* ptr;
   Data_Get_Struct(rval, Gecode::MIntVarArray, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MIntVarArray* >(ptr);

   TGecode_MIntVarArrayMap::iterator it = Gecode_MIntVarArrayMap.find(rval);

   if ( it == Gecode_MIntVarArrayMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MIntVarArray instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MIntVarArray* >((*it).second);
}

Gecode::MIntVarArray& ruby2Gecode_MIntVarArray(VALUE rval, int argn) {
  return *ruby2Gecode_MIntVarArrayPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MIntVarArray* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MIntVarArrayMap::iterator it, eend = Gecode_MIntVarArrayMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MIntVarArray %p\n", instance);
#endif

  for(it = Gecode_MIntVarArrayMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MIntVarArray*)instance ) break;

   if ( it != Gecode_MIntVarArrayMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MIntVarArray;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MIntVarArray_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MIntVarArray_custom_mark, Gecode_MIntVarArray_free, (void*)instance);
      }
      
      Gecode_MIntVarArrayMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MIntVarArray_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MIntVarArray_custom_mark, Gecode_MIntVarArray_free, 0);
}

TGecode_MIntVarArrayMap Gecode_MIntVarArrayMap;

static void Gecode_MIntVarArray_free(void *p) {
	Gecode_MIntVarArray_free_map_entry(p);
  delete (Gecode::MIntVarArray*)p;
}

static void Gecode_MIntVarArray_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MIntVarArray) \n", p);
#endif

  TGecode_MIntVarArrayMap::iterator it, eend = Gecode_MIntVarArrayMap.end();
  for(it = Gecode_MIntVarArrayMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MIntVarArray*)p ) {
        Gecode_MIntVarArrayMap.erase(it); break;
     }
}

static void Gecode_MIntVarArray_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MIntVarArray) \n", p);
#endif
}

VALUE fGecode_MIntVarArrayMIntVarArray ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MIntVarArray* tmp;
  Data_Get_Struct(self, Gecode::MIntVarArray, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 2: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MIntVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
           tmp = new Gecode::MIntVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4));
           ok = true;
}}}}
     } break;
     case 3: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
           tmp = new Gecode::MIntVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3));
           ok = true;
}}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::MIntVarArray();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_MIntVarArrayMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MIntVarArray (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_MIntVarArray_at ( VALUE self , VALUE index ) {
  Gecode::MIntVarArray* tmp = ruby2Gecode_MIntVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::IntVar(tmp->at(ruby2int(index, 1))), true );

}


VALUE fGecode_Gecode_MIntVarArray_atop ( VALUE self , VALUE index ) {
  Gecode::MIntVarArray* tmp = ruby2Gecode_MIntVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::IntVar((*tmp) [ ruby2int(index, 1) ] ), true );

}


VALUE fGecode_Gecode_MIntVarArray_ateqop ( VALUE self , VALUE index, VALUE val ) {
  Gecode::MIntVarArray* tmp = ruby2Gecode_MIntVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::IntVar((*tmp) [ ruby2int(index, 1) ] = ruby2Gecode_IntVar(val, 2)), true );

}


VALUE fGecodeRaw_Gecode_MIntVarArray_enlargeArray ( VALUE self , VALUE home, VALUE n ) {
  Gecode::MIntVarArray* tmp = ruby2Gecode_MIntVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->enlargeArray(ruby2Gecode_MSpacePtr(home, 1),ruby2int(n, 2)); return Qnil;

}


VALUE fGecodeRaw_Gecode_MIntVarArray_size ( VALUE self  ) {
  Gecode::MIntVarArray* tmp = ruby2Gecode_MIntVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->size()) );

}


VALUE fGecodeRaw_Gecode_MIntVarArray_debug ( VALUE self  ) {
  Gecode::MIntVarArray* tmp = ruby2Gecode_MIntVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->debug(); return Qnil;

}


VALUE rGecode_MBoolVarArray;

bool is_Gecode_MBoolVarArray(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MBoolVarArray *obj = 0;
    
    Data_Get_Struct(val, Gecode::MBoolVarArray, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MBoolVarArray) == Qtrue;
  }
  
  return false;
}

Gecode::MBoolVarArray* ruby2Gecode_MBoolVarArrayPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MBoolVarArray(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MBoolVarArray given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MBoolVarArray given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MBoolVarArray* ptr;
   Data_Get_Struct(rval, Gecode::MBoolVarArray, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MBoolVarArray* >(ptr);

   TGecode_MBoolVarArrayMap::iterator it = Gecode_MBoolVarArrayMap.find(rval);

   if ( it == Gecode_MBoolVarArrayMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MBoolVarArray instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MBoolVarArray* >((*it).second);
}

Gecode::MBoolVarArray& ruby2Gecode_MBoolVarArray(VALUE rval, int argn) {
  return *ruby2Gecode_MBoolVarArrayPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MBoolVarArray* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MBoolVarArrayMap::iterator it, eend = Gecode_MBoolVarArrayMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MBoolVarArray %p\n", instance);
#endif

  for(it = Gecode_MBoolVarArrayMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MBoolVarArray*)instance ) break;

   if ( it != Gecode_MBoolVarArrayMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MBoolVarArray;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MBoolVarArray_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MBoolVarArray_custom_mark, Gecode_MBoolVarArray_free, (void*)instance);
      }
      
      Gecode_MBoolVarArrayMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MBoolVarArray_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MBoolVarArray_custom_mark, Gecode_MBoolVarArray_free, 0);
}

TGecode_MBoolVarArrayMap Gecode_MBoolVarArrayMap;

static void Gecode_MBoolVarArray_free(void *p) {
	Gecode_MBoolVarArray_free_map_entry(p);
  delete (Gecode::MBoolVarArray*)p;
}

static void Gecode_MBoolVarArray_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MBoolVarArray) \n", p);
#endif

  TGecode_MBoolVarArrayMap::iterator it, eend = Gecode_MBoolVarArrayMap.end();
  for(it = Gecode_MBoolVarArrayMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MBoolVarArray*)p ) {
        Gecode_MBoolVarArrayMap.erase(it); break;
     }
}

static void Gecode_MBoolVarArray_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MBoolVarArray) \n", p);
#endif
}

VALUE fGecode_MBoolVarArrayMBoolVarArray ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MBoolVarArray* tmp;
  Data_Get_Struct(self, Gecode::MBoolVarArray, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 2: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MBoolVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::MBoolVarArray();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_MBoolVarArrayMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MBoolVarArray (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_MBoolVarArray_at ( VALUE self , VALUE index ) {
  Gecode::MBoolVarArray* tmp = ruby2Gecode_MBoolVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::BoolVar(tmp->at(ruby2int(index, 1))), true );

}


VALUE fGecode_Gecode_MBoolVarArray_atop ( VALUE self , VALUE index ) {
  Gecode::MBoolVarArray* tmp = ruby2Gecode_MBoolVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::BoolVar((*tmp) [ ruby2int(index, 1) ] ), true );

}


VALUE fGecode_Gecode_MBoolVarArray_ateqop ( VALUE self , VALUE index, VALUE val ) {
  Gecode::MBoolVarArray* tmp = ruby2Gecode_MBoolVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::BoolVar((*tmp) [ ruby2int(index, 1) ] = ruby2Gecode_BoolVar(val, 2)), true );

}


VALUE fGecodeRaw_Gecode_MBoolVarArray_enlargeArray ( VALUE self , VALUE home, VALUE n ) {
  Gecode::MBoolVarArray* tmp = ruby2Gecode_MBoolVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->enlargeArray(ruby2Gecode_MSpacePtr(home, 1),ruby2int(n, 2)); return Qnil;

}


VALUE fGecodeRaw_Gecode_MBoolVarArray_size ( VALUE self  ) {
  Gecode::MBoolVarArray* tmp = ruby2Gecode_MBoolVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->size()) );

}


VALUE fGecodeRaw_Gecode_MBoolVarArray_debug ( VALUE self  ) {
  Gecode::MBoolVarArray* tmp = ruby2Gecode_MBoolVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->debug(); return Qnil;

}


VALUE rGecode_MSetVarArray;

bool is_Gecode_MSetVarArray(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MSetVarArray *obj = 0;
    
    Data_Get_Struct(val, Gecode::MSetVarArray, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MSetVarArray) == Qtrue;
  }
  
  return false;
}

Gecode::MSetVarArray* ruby2Gecode_MSetVarArrayPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MSetVarArray(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MSetVarArray given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MSetVarArray given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MSetVarArray* ptr;
   Data_Get_Struct(rval, Gecode::MSetVarArray, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MSetVarArray* >(ptr);

   TGecode_MSetVarArrayMap::iterator it = Gecode_MSetVarArrayMap.find(rval);

   if ( it == Gecode_MSetVarArrayMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MSetVarArray instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MSetVarArray* >((*it).second);
}

Gecode::MSetVarArray& ruby2Gecode_MSetVarArray(VALUE rval, int argn) {
  return *ruby2Gecode_MSetVarArrayPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MSetVarArray* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MSetVarArrayMap::iterator it, eend = Gecode_MSetVarArrayMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MSetVarArray %p\n", instance);
#endif

  for(it = Gecode_MSetVarArrayMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MSetVarArray*)instance ) break;

   if ( it != Gecode_MSetVarArrayMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MSetVarArray;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MSetVarArray_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MSetVarArray_custom_mark, Gecode_MSetVarArray_free, (void*)instance);
      }
      
      Gecode_MSetVarArrayMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MSetVarArray_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MSetVarArray_custom_mark, Gecode_MSetVarArray_free, 0);
}

TGecode_MSetVarArrayMap Gecode_MSetVarArrayMap;

static void Gecode_MSetVarArray_free(void *p) {
	Gecode_MSetVarArray_free_map_entry(p);
  delete (Gecode::MSetVarArray*)p;
}

static void Gecode_MSetVarArray_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MSetVarArray) \n", p);
#endif

  TGecode_MSetVarArrayMap::iterator it, eend = Gecode_MSetVarArrayMap.end();
  for(it = Gecode_MSetVarArrayMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MSetVarArray*)p ) {
        Gecode_MSetVarArrayMap.erase(it); break;
     }
}

static void Gecode_MSetVarArray_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MSetVarArray) \n", p);
#endif
}

VALUE fGecode_MSetVarArrayMSetVarArray ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MSetVarArray* tmp;
  Data_Get_Struct(self, Gecode::MSetVarArray, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 2: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
     } break;
     case 8: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
      if( is_int(argv[6]) ) {
      if( is_int(argv[7]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6),ruby2int(argv[6], 7),ruby2int(argv[7], 8));
           ok = true;
}}}}}}}}
     } break;
     case 7: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
      if( is_int(argv[6]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6),ruby2int(argv[6], 7));
           ok = true;
}}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntSet(argv[4]) ) {
      if( is_int(argv[5]) ) {
      if( is_int(argv[6]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntSet(argv[4], 5),ruby2int(argv[5], 6),ruby2int(argv[6], 7));
           ok = true;
}}}}}}}
     } break;
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntSet(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntSet(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
// Case 4
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntSet(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntSet(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
// Case 5
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
// Case 6
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntSet(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntSet(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::MSetVarArray();
           ok = true;

     } break;
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntSet(argv[4]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntSet(argv[4], 5));
           ok = true;
}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 4
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntSet(argv[4]) ) {
           tmp = new Gecode::MSetVarArray(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntSet(argv[4], 5));
           ok = true;
}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_MSetVarArrayMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MSetVarArray (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_MSetVarArray_at ( VALUE self , VALUE index ) {
  Gecode::MSetVarArray* tmp = ruby2Gecode_MSetVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::SetVar(tmp->at(ruby2int(index, 1))), true );

}


VALUE fGecode_Gecode_MSetVarArray_atop ( VALUE self , VALUE index ) {
  Gecode::MSetVarArray* tmp = ruby2Gecode_MSetVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::SetVar((*tmp) [ ruby2int(index, 1) ] ), true );

}


VALUE fGecode_Gecode_MSetVarArray_ateqop ( VALUE self , VALUE index, VALUE val ) {
  Gecode::MSetVarArray* tmp = ruby2Gecode_MSetVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::SetVar((*tmp) [ ruby2int(index, 1) ] = ruby2Gecode_SetVar(val, 2)), true );

}


VALUE fGecodeRaw_Gecode_MSetVarArray_enlargeArray ( VALUE self , VALUE home, VALUE n ) {
  Gecode::MSetVarArray* tmp = ruby2Gecode_MSetVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->enlargeArray(ruby2Gecode_MSpacePtr(home, 1),ruby2int(n, 2)); return Qnil;

}


VALUE fGecodeRaw_Gecode_MSetVarArray_size ( VALUE self  ) {
  Gecode::MSetVarArray* tmp = ruby2Gecode_MSetVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->size()) );

}


VALUE fGecodeRaw_Gecode_MSetVarArray_debug ( VALUE self  ) {
  Gecode::MSetVarArray* tmp = ruby2Gecode_MSetVarArrayPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->debug(); return Qnil;

}


VALUE rGecode_TupleSet;

bool is_Gecode_TupleSet(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::TupleSet *obj = 0;
    
    Data_Get_Struct(val, Gecode::TupleSet, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_TupleSet) == Qtrue;
  }
  
  return false;
}

Gecode::TupleSet* ruby2Gecode_TupleSetPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_TupleSet(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::TupleSet given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::TupleSet given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::TupleSet* ptr;
   Data_Get_Struct(rval, Gecode::TupleSet, ptr);

   if ( ptr ) return dynamic_cast< Gecode::TupleSet* >(ptr);

   TGecode_TupleSetMap::iterator it = Gecode_TupleSetMap.find(rval);

   if ( it == Gecode_TupleSetMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::TupleSet instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::TupleSet* >((*it).second);
}

Gecode::TupleSet& ruby2Gecode_TupleSet(VALUE rval, int argn) {
  return *ruby2Gecode_TupleSetPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::TupleSet* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_TupleSetMap::iterator it, eend = Gecode_TupleSetMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::TupleSet %p\n", instance);
#endif

  for(it = Gecode_TupleSetMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::TupleSet*)instance ) break;

   if ( it != Gecode_TupleSetMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_TupleSet;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_TupleSet_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_TupleSet_mark, Gecode_TupleSet_free, (void*)instance);
      }
      
      Gecode_TupleSetMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_TupleSet_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_TupleSet_mark, Gecode_TupleSet_free, 0);
}

TGecode_TupleSetMap Gecode_TupleSetMap;

static void Gecode_TupleSet_free(void *p) {
	Gecode_TupleSet_free_map_entry(p);
  delete (Gecode::TupleSet*)p;
}

static void Gecode_TupleSet_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_TupleSet) \n", p);
#endif

  TGecode_TupleSetMap::iterator it, eend = Gecode_TupleSetMap.end();
  for(it = Gecode_TupleSetMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::TupleSet*)p ) {
        Gecode_TupleSetMap.erase(it); break;
     }
}

static void Gecode_TupleSet_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_TupleSet) \n", p);
#endif
}

VALUE fGecode_TupleSetTupleSet ( VALUE self  ) {
  Gecode::TupleSet* tmp;
  Data_Get_Struct(self, Gecode::TupleSet, tmp);

  /* The exception is thrown already by ruby2* if not found */

  tmp = new Gecode::TupleSet();
;

  DATA_PTR(self) = tmp;
  Gecode_TupleSetMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::TupleSet (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_TupleSet_add ( VALUE self , VALUE tuple ) {
  Gecode::TupleSet* tmp = ruby2Gecode_TupleSetPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->add(ruby2Gecode_IntArgs(tuple, 1)); return Qnil;

}


VALUE fGecodeRaw_Gecode_TupleSet_finalize ( VALUE self  ) {
  Gecode::TupleSet* tmp = ruby2Gecode_TupleSetPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->finalize(); return Qnil;

}


VALUE fGecodeRaw_Gecode_TupleSet_finalized ( VALUE self  ) {
  Gecode::TupleSet* tmp = ruby2Gecode_TupleSetPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->finalized()) );

}


VALUE fGecodeRaw_Gecode_TupleSet_tuples ( VALUE self  ) {
  Gecode::TupleSet* tmp = ruby2Gecode_TupleSetPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->tuples()) );

}


VALUE rGecode_MSpace;

bool is_Gecode_MSpace(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MSpace *obj = 0;
    
    Data_Get_Struct(val, Gecode::MSpace, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MSpace) == Qtrue;
  }
  
  return false;
}

Gecode::MSpace* ruby2Gecode_MSpacePtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MSpace(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MSpace given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MSpace given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MSpace* ptr;
   Data_Get_Struct(rval, Gecode::MSpace, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MSpace* >(ptr);

   TGecode_MSpaceMap::iterator it = Gecode_MSpaceMap.find(rval);

   if ( it == Gecode_MSpaceMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MSpace instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MSpace* >((*it).second);
}

Gecode::MSpace& ruby2Gecode_MSpace(VALUE rval, int argn) {
  return *ruby2Gecode_MSpacePtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MSpace* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MSpaceMap::iterator it, eend = Gecode_MSpaceMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MSpace %p\n", instance);
#endif

  for(it = Gecode_MSpaceMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MSpace*)instance ) break;

   if ( it != Gecode_MSpaceMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MSpace;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MSpace_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MSpace_custom_mark, Gecode_MSpace_free, (void*)instance);
      }
      
      Gecode_MSpaceMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MSpace_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MSpace_custom_mark, Gecode_MSpace_free, 0);
}

TGecode_MSpaceMap Gecode_MSpaceMap;

static void Gecode_MSpace_free(void *p) {
	Gecode_MSpace_free_map_entry(p);
  delete (Gecode::MSpace*)p;
}

static void Gecode_MSpace_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MSpace) \n", p);
#endif

  TGecode_MSpaceMap::iterator it, eend = Gecode_MSpaceMap.end();
  for(it = Gecode_MSpaceMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MSpace*)p ) {
        Gecode_MSpaceMap.erase(it); break;
     }
}

static void Gecode_MSpace_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MSpace) \n", p);
#endif
}

VALUE fGecode_MSpaceMSpace ( VALUE self  ) {
  Gecode::MSpace* tmp;
  Data_Get_Struct(self, Gecode::MSpace, tmp);

  /* The exception is thrown already by ruby2* if not found */

  tmp = new Gecode::MSpace();
;

  DATA_PTR(self) = tmp;
  Gecode_MSpaceMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MSpace (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_MSpace_constrain ( VALUE self , VALUE s ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->constrain(ruby2Gecode_MSpacePtr(s, 1)); return Qnil;

}


VALUE fGecodeRaw_Gecode_MSpace_new_int_var ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_Gecode_IntSet(argv[0]) ) {
           return cxx2ruby( static_cast<int>(tmp->new_int_var(ruby2Gecode_IntSet(argv[0], 1))) );
           ok = true;
}
     } break;
     case 2: {
// Case 0
      if( is_int(argv[0]) ) {
      if( is_int(argv[1]) ) {
           return cxx2ruby( static_cast<int>(tmp->new_int_var(ruby2int(argv[0], 1),ruby2int(argv[1], 2))) );
           ok = true;
}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecodeRaw_Gecode_MSpace_new_bool_var ( VALUE self  ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->new_bool_var()) );

}


VALUE fGecodeRaw_Gecode_MSpace_new_set_var ( VALUE self , VALUE glb, VALUE lub, VALUE cardMin, VALUE cardMax ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->new_set_var(ruby2Gecode_IntSet(glb, 1),ruby2Gecode_IntSet(lub, 2),ruby2int(cardMin, 3),ruby2int(cardMax, 4))) );

}


VALUE fGecodeRaw_Gecode_MSpace_int_var ( VALUE self , VALUE id ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<Gecode::IntVar*>(tmp->int_var(ruby2int(id, 1))) );

}


VALUE fGecodeRaw_Gecode_MSpace_bool_var ( VALUE self , VALUE id ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<Gecode::BoolVar*>(tmp->bool_var(ruby2int(id, 1))) );

}


VALUE fGecodeRaw_Gecode_MSpace_set_var ( VALUE self , VALUE id ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<Gecode::SetVar*>(tmp->set_var(ruby2int(id, 1))) );

}


VALUE fGecodeRaw_Gecode_MSpace_clone ( VALUE self , VALUE shared ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<Gecode::MSpace *>(tmp->clone(ruby2bool(shared, 1))) );

}


VALUE fGecodeRaw_Gecode_MSpace_status ( VALUE self  ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->status()) );

}


VALUE fGecodeRaw_Gecode_MSpace_propagators ( VALUE self  ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->propagators()) );

}


VALUE fGecodeRaw_Gecode_MSpace_branchings ( VALUE self  ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->branchings()) );

}


VALUE fGecodeRaw_Gecode_MSpace_failed ( VALUE self  ) {
  Gecode::MSpace* tmp = ruby2Gecode_MSpacePtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->failed()) );

}


VALUE rIntLimits;



VALUE rSetLimits;




VALUE rGecode_IntSet;

bool is_Gecode_IntSet(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::IntSet *obj = 0;
    
    Data_Get_Struct(val, Gecode::IntSet, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_IntSet) == Qtrue;
  }
  
  return false;
}

Gecode::IntSet* ruby2Gecode_IntSetPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_IntSet(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::IntSet given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::IntSet given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::IntSet* ptr;
   Data_Get_Struct(rval, Gecode::IntSet, ptr);

   if ( ptr ) return dynamic_cast< Gecode::IntSet* >(ptr);

   TGecode_IntSetMap::iterator it = Gecode_IntSetMap.find(rval);

   if ( it == Gecode_IntSetMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::IntSet instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::IntSet* >((*it).second);
}

Gecode::IntSet& ruby2Gecode_IntSet(VALUE rval, int argn) {
  return *ruby2Gecode_IntSetPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::IntSet* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_IntSetMap::iterator it, eend = Gecode_IntSetMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::IntSet %p\n", instance);
#endif

  for(it = Gecode_IntSetMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::IntSet*)instance ) break;

   if ( it != Gecode_IntSetMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_IntSet;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_IntSet_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_IntSet_mark, Gecode_IntSet_free, (void*)instance);
      }
      
      Gecode_IntSetMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_IntSet_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_IntSet_mark, Gecode_IntSet_free, 0);
}

TGecode_IntSetMap Gecode_IntSetMap;

static void Gecode_IntSet_free(void *p) {
	Gecode_IntSet_free_map_entry(p);
  delete (Gecode::IntSet*)p;
}

static void Gecode_IntSet_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_IntSet) \n", p);
#endif

  TGecode_IntSetMap::iterator it, eend = Gecode_IntSetMap.end();
  for(it = Gecode_IntSetMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::IntSet*)p ) {
        Gecode_IntSetMap.erase(it); break;
     }
}

static void Gecode_IntSet_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_IntSet) \n", p);
#endif
}

VALUE fGecode_IntSetIntSet ( int argc, VALUE *argv, VALUE self ) {
  Gecode::IntSet* tmp;
  Data_Get_Struct(self, Gecode::IntSet, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 2: {
// Case 0
      if( is_array(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::IntSet(ruby2intArray(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 1
      if( is_int(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::IntSet(ruby2int(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_IntSetMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::IntSet (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_IntSet_size ( VALUE self  ) {
  Gecode::IntSet* tmp = ruby2Gecode_IntSetPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->size()) );

}


VALUE fGecodeRaw_Gecode_IntSet_width ( VALUE self , VALUE i ) {
  Gecode::IntSet* tmp = ruby2Gecode_IntSetPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<unsigned int>(tmp->width(ruby2int(i, 1))) );

}


VALUE fGecodeRaw_Gecode_IntSet_max ( VALUE self , VALUE i ) {
  Gecode::IntSet* tmp = ruby2Gecode_IntSetPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->max(ruby2int(i, 1))) );

}


VALUE fGecodeRaw_Gecode_IntSet_min ( VALUE self , VALUE i ) {
  Gecode::IntSet* tmp = ruby2Gecode_IntSetPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->min(ruby2int(i, 1))) );

}



VALUE rGecode_IntVar;

bool is_Gecode_IntVar(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::IntVar *obj = 0;
    
    Data_Get_Struct(val, Gecode::IntVar, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_IntVar) == Qtrue;
  }
  
  return false;
}

Gecode::IntVar* ruby2Gecode_IntVarPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_IntVar(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::IntVar given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::IntVar given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::IntVar* ptr;
   Data_Get_Struct(rval, Gecode::IntVar, ptr);

   if ( ptr ) return dynamic_cast< Gecode::IntVar* >(ptr);

   TGecode_IntVarMap::iterator it = Gecode_IntVarMap.find(rval);

   if ( it == Gecode_IntVarMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::IntVar instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::IntVar* >((*it).second);
}

Gecode::IntVar& ruby2Gecode_IntVar(VALUE rval, int argn) {
  return *ruby2Gecode_IntVarPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::IntVar* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_IntVarMap::iterator it, eend = Gecode_IntVarMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::IntVar %p\n", instance);
#endif

  for(it = Gecode_IntVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::IntVar*)instance ) break;

   if ( it != Gecode_IntVarMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_IntVar;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_IntVar_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_IntVar_mark, Gecode_IntVar_free, (void*)instance);
      }
      
      Gecode_IntVarMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_IntVar_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_IntVar_mark, Gecode_IntVar_free, 0);
}

TGecode_IntVarMap Gecode_IntVarMap;

static void Gecode_IntVar_free(void *p) {
	Gecode_IntVar_free_map_entry(p);
  delete (Gecode::IntVar*)p;
}

static void Gecode_IntVar_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_IntVar) \n", p);
#endif

  TGecode_IntVarMap::iterator it, eend = Gecode_IntVarMap.end();
  for(it = Gecode_IntVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::IntVar*)p ) {
        Gecode_IntVarMap.erase(it); break;
     }
}

static void Gecode_IntVar_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_IntVar) \n", p);
#endif
}

VALUE fGecode_IntVarIntVar ( int argc, VALUE *argv, VALUE self ) {
  Gecode::IntVar* tmp;
  Data_Get_Struct(self, Gecode::IntVar, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 2: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
           tmp = new Gecode::IntVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2));
           ok = true;
}}
     } break;
     case 3: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
           tmp = new Gecode::IntVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3));
           ok = true;
}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_IntVarMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::IntVar (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_IntVar_max ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->max()) );

}


VALUE fGecodeRaw_Gecode_IntVar_min ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->min()) );

}


VALUE fGecodeRaw_Gecode_IntVar_med ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->med()) );

}


VALUE fGecodeRaw_Gecode_IntVar_val ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->val()) );

}


VALUE fGecodeRaw_Gecode_IntVar_size ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<unsigned int>(tmp->size()) );

}


VALUE fGecodeRaw_Gecode_IntVar_width ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<unsigned int>(tmp->width()) );

}


VALUE fGecodeRaw_Gecode_IntVar_degree ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<unsigned int>(tmp->degree()) );

}


VALUE fGecodeRaw_Gecode_IntVar_range ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->range()) );

}


VALUE fGecodeRaw_Gecode_IntVar_assigned ( VALUE self  ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->assigned()) );

}


VALUE fGecodeRaw_Gecode_IntVar_in ( VALUE self , VALUE n ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->in(ruby2int(n, 1))) );

}


VALUE fGecodeRaw_Gecode_IntVar_update ( VALUE self , VALUE home, VALUE share, VALUE x ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->update(ruby2Gecode_MSpacePtr(home, 1),ruby2bool(share, 2),ruby2Gecode_IntVar(x, 3)); return Qnil;

}


VALUE fGecode_Gecode_IntVar_plusop ( VALUE self , VALUE i ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) + ruby2int(i, 1) ), true );

}


VALUE fGecode_Gecode_IntVar_minusop ( VALUE self , VALUE i ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) - ruby2int(i, 1) ), true );

}


VALUE fGecode_Gecode_IntVar_multop ( VALUE self , VALUE i ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) * ruby2int(i, 1) ), true );

}


VALUE fGecode_Gecode_IntVar_notequalop ( VALUE self , VALUE other ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinRel<Gecode::IntVar>((*tmp) != ruby2Gecode_IntVar(other, 1) ), true );

}


VALUE fGecode_Gecode_IntVar_equalop ( VALUE self , VALUE other ) {
  Gecode::IntVar* tmp = ruby2Gecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinRel<Gecode::IntVar>((*tmp) == ruby2Gecode_IntVar(other, 1) ), true );

}


VALUE rGecode_BoolVar;

bool is_Gecode_BoolVar(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::BoolVar *obj = 0;
    
    Data_Get_Struct(val, Gecode::BoolVar, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_BoolVar) == Qtrue;
  }
  
  return false;
}

Gecode::BoolVar* ruby2Gecode_BoolVarPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_BoolVar(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::BoolVar given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::BoolVar given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::BoolVar* ptr;
   Data_Get_Struct(rval, Gecode::BoolVar, ptr);

   if ( ptr ) return dynamic_cast< Gecode::BoolVar* >(ptr);

   TGecode_BoolVarMap::iterator it = Gecode_BoolVarMap.find(rval);

   if ( it == Gecode_BoolVarMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::BoolVar instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::BoolVar* >((*it).second);
}

Gecode::BoolVar& ruby2Gecode_BoolVar(VALUE rval, int argn) {
  return *ruby2Gecode_BoolVarPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::BoolVar* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_BoolVarMap::iterator it, eend = Gecode_BoolVarMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::BoolVar %p\n", instance);
#endif

  for(it = Gecode_BoolVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::BoolVar*)instance ) break;

   if ( it != Gecode_BoolVarMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_BoolVar;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_BoolVar_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_BoolVar_mark, Gecode_BoolVar_free, (void*)instance);
      }
      
      Gecode_BoolVarMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_BoolVar_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_BoolVar_mark, Gecode_BoolVar_free, 0);
}

TGecode_BoolVarMap Gecode_BoolVarMap;

static void Gecode_BoolVar_free(void *p) {
	Gecode_BoolVar_free_map_entry(p);
  delete (Gecode::BoolVar*)p;
}

static void Gecode_BoolVar_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_BoolVar) \n", p);
#endif

  TGecode_BoolVarMap::iterator it, eend = Gecode_BoolVarMap.end();
  for(it = Gecode_BoolVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::BoolVar*)p ) {
        Gecode_BoolVarMap.erase(it); break;
     }
}

static void Gecode_BoolVar_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_BoolVar) \n", p);
#endif
}

VALUE fGecode_BoolVarBoolVar ( int argc, VALUE *argv, VALUE self ) {
  Gecode::BoolVar* tmp;
  Data_Get_Struct(self, Gecode::BoolVar, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 3: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
           tmp = new Gecode::BoolVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3));
           ok = true;
}}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::BoolVar();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_BoolVarMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::BoolVar (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_BoolVar_max ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->max()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_min ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->min()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_med ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->med()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_val ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->val()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_size ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<unsigned int>(tmp->size()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_width ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<unsigned int>(tmp->width()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_degree ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<unsigned int>(tmp->degree()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_range ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->range()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_assigned ( VALUE self  ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->assigned()) );

}


VALUE fGecodeRaw_Gecode_BoolVar_in ( VALUE self , VALUE n ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->in(ruby2int(n, 1))) );

}


VALUE fGecodeRaw_Gecode_BoolVar_update ( VALUE self , VALUE home, VALUE share, VALUE x ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->update(ruby2Gecode_MSpacePtr(home, 1),ruby2bool(share, 2),ruby2Gecode_BoolVar(x, 3)); return Qnil;

}


VALUE fGecode_Gecode_BoolVar_plusop ( VALUE self , VALUE i ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) + ruby2int(i, 1) ), true );

}


VALUE fGecode_Gecode_BoolVar_minusop ( VALUE self , VALUE i ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) - ruby2int(i, 1) ), true );

}


VALUE fGecode_Gecode_BoolVar_multop ( VALUE self , VALUE i ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) * ruby2int(i, 1) ), true );

}


VALUE fGecode_Gecode_BoolVar_notequalop ( VALUE self , VALUE other ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinRel<Gecode::BoolVar>((*tmp) != ruby2Gecode_BoolVar(other, 1) ), true );

}


VALUE fGecode_Gecode_BoolVar_equalop ( VALUE self , VALUE other ) {
  Gecode::BoolVar* tmp = ruby2Gecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinRel<Gecode::BoolVar>((*tmp) == ruby2Gecode_BoolVar(other, 1) ), true );

}


VALUE rGecode_SetVar;

bool is_Gecode_SetVar(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::SetVar *obj = 0;
    
    Data_Get_Struct(val, Gecode::SetVar, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_SetVar) == Qtrue;
  }
  
  return false;
}

Gecode::SetVar* ruby2Gecode_SetVarPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_SetVar(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::SetVar given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::SetVar given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::SetVar* ptr;
   Data_Get_Struct(rval, Gecode::SetVar, ptr);

   if ( ptr ) return dynamic_cast< Gecode::SetVar* >(ptr);

   TGecode_SetVarMap::iterator it = Gecode_SetVarMap.find(rval);

   if ( it == Gecode_SetVarMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::SetVar instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::SetVar* >((*it).second);
}

Gecode::SetVar& ruby2Gecode_SetVar(VALUE rval, int argn) {
  return *ruby2Gecode_SetVarPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::SetVar* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_SetVarMap::iterator it, eend = Gecode_SetVarMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::SetVar %p\n", instance);
#endif

  for(it = Gecode_SetVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::SetVar*)instance ) break;

   if ( it != Gecode_SetVarMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_SetVar;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_SetVar_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_SetVar_mark, Gecode_SetVar_free, (void*)instance);
      }
      
      Gecode_SetVarMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_SetVar_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_SetVar_mark, Gecode_SetVar_free, 0);
}

TGecode_SetVarMap Gecode_SetVarMap;

static void Gecode_SetVar_free(void *p) {
	Gecode_SetVar_free_map_entry(p);
  delete (Gecode::SetVar*)p;
}

static void Gecode_SetVar_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_SetVar) \n", p);
#endif

  TGecode_SetVarMap::iterator it, eend = Gecode_SetVarMap.end();
  for(it = Gecode_SetVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::SetVar*)p ) {
        Gecode_SetVarMap.erase(it); break;
     }
}

static void Gecode_SetVar_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_SetVar) \n", p);
#endif
}

VALUE fGecode_SetVarSetVar ( int argc, VALUE *argv, VALUE self ) {
  Gecode::SetVar* tmp;
  Data_Get_Struct(self, Gecode::SetVar, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1));
           ok = true;
}
     } break;
     case 7: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
      if( is_int(argv[6]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6),ruby2int(argv[6], 7));
           ok = true;
}}}}}}}
     } break;
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_int(argv[5]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2int(argv[4], 5),ruby2int(argv[5], 6));
           ok = true;
}}}}}}
     } break;
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 4
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 5
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
// Case 6
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_int(argv[4]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2int(argv[4], 5));
           ok = true;
}}}}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::SetVar();
           ok = true;

     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_int(argv[3]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2int(argv[3], 4));
           ok = true;
}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4));
           ok = true;
}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4));
           ok = true;
}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4));
           ok = true;
}}}}
// Case 4
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
           tmp = new Gecode::SetVar(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4));
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_SetVarMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::SetVar (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_SetVar_glbSize ( int argc, VALUE *argv, VALUE self ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 0: {
// Case 0
           return cxx2ruby( static_cast<int>(tmp->glbSize()) );
           ok = true;

// Case 1
           return cxx2ruby( static_cast<int>(tmp->glbSize()) );
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecodeRaw_Gecode_SetVar_lubSize ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->lubSize()) );

}


VALUE fGecodeRaw_Gecode_SetVar_unknownSize ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->unknownSize()) );

}


VALUE fGecodeRaw_Gecode_SetVar_cardMin ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->cardMin()) );

}


VALUE fGecodeRaw_Gecode_SetVar_cardMax ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->cardMax()) );

}


VALUE fGecodeRaw_Gecode_SetVar_lubMin ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->lubMin()) );

}


VALUE fGecodeRaw_Gecode_SetVar_lubMax ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->lubMax()) );

}


VALUE fGecodeRaw_Gecode_SetVar_glbMin ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->glbMin()) );

}


VALUE fGecodeRaw_Gecode_SetVar_glbMax ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<int>(tmp->glbMax()) );

}


VALUE fGecodeRaw_Gecode_SetVar_contains ( VALUE self , VALUE i ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->contains(ruby2int(i, 1))) );

}


VALUE fGecodeRaw_Gecode_SetVar_notContains ( VALUE self , VALUE i ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->notContains(ruby2int(i, 1))) );

}


VALUE fGecodeRaw_Gecode_SetVar_assigned ( VALUE self  ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->assigned()) );

}


VALUE fGecodeRaw_Gecode_SetVar_update ( VALUE self , VALUE home, VALUE shared, VALUE x ) {
  Gecode::SetVar* tmp = ruby2Gecode_SetVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  tmp->update(ruby2Gecode_MSpacePtr(home, 1),ruby2bool(shared, 2),ruby2Gecode_SetVar(x, 3)); return Qnil;

}


VALUE rGecode_MDFS;

bool is_Gecode_MDFS(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MDFS *obj = 0;
    
    Data_Get_Struct(val, Gecode::MDFS, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MDFS) == Qtrue;
  }
  
  return false;
}

Gecode::MDFS* ruby2Gecode_MDFSPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MDFS(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MDFS given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MDFS given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MDFS* ptr;
   Data_Get_Struct(rval, Gecode::MDFS, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MDFS* >(ptr);

   TGecode_MDFSMap::iterator it = Gecode_MDFSMap.find(rval);

   if ( it == Gecode_MDFSMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MDFS instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MDFS* >((*it).second);
}

Gecode::MDFS& ruby2Gecode_MDFS(VALUE rval, int argn) {
  return *ruby2Gecode_MDFSPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MDFS* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MDFSMap::iterator it, eend = Gecode_MDFSMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MDFS %p\n", instance);
#endif

  for(it = Gecode_MDFSMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MDFS*)instance ) break;

   if ( it != Gecode_MDFSMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MDFS;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MDFS_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MDFS_mark, Gecode_MDFS_free, (void*)instance);
      }
      
      Gecode_MDFSMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MDFS_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MDFS_mark, Gecode_MDFS_free, 0);
}

TGecode_MDFSMap Gecode_MDFSMap;

static void Gecode_MDFS_free(void *p) {
	Gecode_MDFS_free_map_entry(p);
  delete (Gecode::MDFS*)p;
}

static void Gecode_MDFS_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MDFS) \n", p);
#endif

  TGecode_MDFSMap::iterator it, eend = Gecode_MDFSMap.end();
  for(it = Gecode_MDFSMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MDFS*)p ) {
        Gecode_MDFSMap.erase(it); break;
     }
}

static void Gecode_MDFS_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MDFS) \n", p);
#endif
}

VALUE fGecode_MDFSMDFS ( VALUE self , VALUE s, VALUE o ) {
  Gecode::MDFS* tmp;
  Data_Get_Struct(self, Gecode::MDFS, tmp);

  /* The exception is thrown already by ruby2* if not found */

  tmp = new Gecode::MDFS(ruby2Gecode_MSpacePtr(s, 1),ruby2Gecode_Search_Options(o, 2));
;

  DATA_PTR(self) = tmp;
  Gecode_MDFSMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MDFS (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_MDFS_next ( VALUE self  ) {
  Gecode::MDFS* tmp = ruby2Gecode_MDFSPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<Gecode::MSpace *>(tmp->next()) );

}


VALUE fGecodeRaw_Gecode_MDFS_stopped ( VALUE self  ) {
  Gecode::MDFS* tmp = ruby2Gecode_MDFSPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->stopped()) );

}


VALUE fGecodeRaw_Gecode_MDFS_statistics ( VALUE self  ) {
  Gecode::MDFS* tmp = ruby2Gecode_MDFSPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::Search::Statistics(tmp->statistics()), true );

}


VALUE rGecode_MBAB;

bool is_Gecode_MBAB(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MBAB *obj = 0;
    
    Data_Get_Struct(val, Gecode::MBAB, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MBAB) == Qtrue;
  }
  
  return false;
}

Gecode::MBAB* ruby2Gecode_MBABPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MBAB(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MBAB given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MBAB given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MBAB* ptr;
   Data_Get_Struct(rval, Gecode::MBAB, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MBAB* >(ptr);

   TGecode_MBABMap::iterator it = Gecode_MBABMap.find(rval);

   if ( it == Gecode_MBABMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MBAB instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MBAB* >((*it).second);
}

Gecode::MBAB& ruby2Gecode_MBAB(VALUE rval, int argn) {
  return *ruby2Gecode_MBABPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MBAB* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MBABMap::iterator it, eend = Gecode_MBABMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MBAB %p\n", instance);
#endif

  for(it = Gecode_MBABMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MBAB*)instance ) break;

   if ( it != Gecode_MBABMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MBAB;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MBAB_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MBAB_mark, Gecode_MBAB_free, (void*)instance);
      }
      
      Gecode_MBABMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MBAB_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MBAB_mark, Gecode_MBAB_free, 0);
}

TGecode_MBABMap Gecode_MBABMap;

static void Gecode_MBAB_free(void *p) {
	Gecode_MBAB_free_map_entry(p);
  delete (Gecode::MBAB*)p;
}

static void Gecode_MBAB_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MBAB) \n", p);
#endif

  TGecode_MBABMap::iterator it, eend = Gecode_MBABMap.end();
  for(it = Gecode_MBABMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MBAB*)p ) {
        Gecode_MBABMap.erase(it); break;
     }
}

static void Gecode_MBAB_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MBAB) \n", p);
#endif
}

VALUE fGecode_MBABMBAB ( VALUE self , VALUE s, VALUE o ) {
  Gecode::MBAB* tmp;
  Data_Get_Struct(self, Gecode::MBAB, tmp);

  /* The exception is thrown already by ruby2* if not found */

  tmp = new Gecode::MBAB(ruby2Gecode_MSpacePtr(s, 1),ruby2Gecode_Search_Options(o, 2));
;

  DATA_PTR(self) = tmp;
  Gecode_MBABMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MBAB (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecodeRaw_Gecode_MBAB_next ( VALUE self  ) {
  Gecode::MBAB* tmp = ruby2Gecode_MBABPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<Gecode::MSpace *>(tmp->next()) );

}


VALUE fGecodeRaw_Gecode_MBAB_stopped ( VALUE self  ) {
  Gecode::MBAB* tmp = ruby2Gecode_MBABPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( static_cast<bool>(tmp->stopped()) );

}


VALUE fGecodeRaw_Gecode_MBAB_statistics ( VALUE self  ) {
  Gecode::MBAB* tmp = ruby2Gecode_MBABPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::Search::Statistics(tmp->statistics()), true );

}


VALUE rGecode_DFA;

bool is_Gecode_DFA(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::DFA *obj = 0;
    
    Data_Get_Struct(val, Gecode::DFA, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_DFA) == Qtrue;
  }
  
  return false;
}

Gecode::DFA* ruby2Gecode_DFAPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_DFA(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::DFA given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::DFA given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::DFA* ptr;
   Data_Get_Struct(rval, Gecode::DFA, ptr);

   if ( ptr ) return dynamic_cast< Gecode::DFA* >(ptr);

   TGecode_DFAMap::iterator it = Gecode_DFAMap.find(rval);

   if ( it == Gecode_DFAMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::DFA instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::DFA* >((*it).second);
}

Gecode::DFA& ruby2Gecode_DFA(VALUE rval, int argn) {
  return *ruby2Gecode_DFAPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::DFA* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_DFAMap::iterator it, eend = Gecode_DFAMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::DFA %p\n", instance);
#endif

  for(it = Gecode_DFAMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::DFA*)instance ) break;

   if ( it != Gecode_DFAMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_DFA;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_DFA_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_DFA_mark, Gecode_DFA_free, (void*)instance);
      }
      
      Gecode_DFAMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_DFA_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_DFA_mark, Gecode_DFA_free, 0);
}

TGecode_DFAMap Gecode_DFAMap;

static void Gecode_DFA_free(void *p) {
	Gecode_DFA_free_map_entry(p);
  delete (Gecode::DFA*)p;
}

static void Gecode_DFA_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_DFA) \n", p);
#endif

  TGecode_DFAMap::iterator it, eend = Gecode_DFAMap.end();
  for(it = Gecode_DFAMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::DFA*)p ) {
        Gecode_DFAMap.erase(it); break;
     }
}

static void Gecode_DFA_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_DFA) \n", p);
#endif
}

VALUE fGecode_DFADFA ( VALUE self  ) {
  Gecode::DFA* tmp;
  Data_Get_Struct(self, Gecode::DFA, tmp);

  /* The exception is thrown already by ruby2* if not found */

  tmp = new Gecode::DFA();
;

  DATA_PTR(self) = tmp;
  Gecode_DFAMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::DFA (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE rGecode_REG;

bool is_Gecode_REG(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::REG *obj = 0;
    
    Data_Get_Struct(val, Gecode::REG, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_REG) == Qtrue;
  }
  
  return false;
}

Gecode::REG* ruby2Gecode_REGPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_REG(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::REG given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::REG given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::REG* ptr;
   Data_Get_Struct(rval, Gecode::REG, ptr);

   if ( ptr ) return dynamic_cast< Gecode::REG* >(ptr);

   TGecode_REGMap::iterator it = Gecode_REGMap.find(rval);

   if ( it == Gecode_REGMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::REG instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::REG* >((*it).second);
}

Gecode::REG& ruby2Gecode_REG(VALUE rval, int argn) {
  return *ruby2Gecode_REGPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::REG* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_REGMap::iterator it, eend = Gecode_REGMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::REG %p\n", instance);
#endif

  for(it = Gecode_REGMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::REG*)instance ) break;

   if ( it != Gecode_REGMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_REG;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_REG_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_REG_mark, Gecode_REG_free, (void*)instance);
      }
      
      Gecode_REGMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_REG_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_REG_mark, Gecode_REG_free, 0);
}

TGecode_REGMap Gecode_REGMap;

static void Gecode_REG_free(void *p) {
	Gecode_REG_free_map_entry(p);
  delete (Gecode::REG*)p;
}

static void Gecode_REG_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_REG) \n", p);
#endif

  TGecode_REGMap::iterator it, eend = Gecode_REGMap.end();
  for(it = Gecode_REGMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::REG*)p ) {
        Gecode_REGMap.erase(it); break;
     }
}

static void Gecode_REG_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_REG) \n", p);
#endif
}

VALUE fGecode_REGREG ( int argc, VALUE *argv, VALUE self ) {
  Gecode::REG* tmp;
  Data_Get_Struct(self, Gecode::REG, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_int(argv[0]) ) {
           tmp = new Gecode::REG(ruby2int(argv[0], 1));
           ok = true;
}
// Case 1
      if( is_Gecode_IntArgs(argv[0]) ) {
           tmp = new Gecode::REG(ruby2Gecode_IntArgs(argv[0], 1));
           ok = true;
}
// Case 2
      if( is_Gecode_REG(argv[0]) ) {
           tmp = new Gecode::REG(ruby2Gecode_REG(argv[0], 1));
           ok = true;
}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::REG();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_REGMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::REG (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fGecode_Gecode_REG_plusop ( int argc, VALUE *argv, VALUE self ) {
  Gecode::REG* tmp = ruby2Gecode_REGPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 0: {
// Case 0
           return cxx2ruby( new Gecode::REG(+ (*tmp)), true );
           ok = true;

     } break;
     case 1: {
// Case 0
      if( is_Gecode_REG(argv[0]) ) {
           return cxx2ruby( new Gecode::REG((*tmp) + ruby2Gecode_REG(argv[0], 1) ), true );
           ok = true;
}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecode_Gecode_REG_undefop_0959 ( VALUE self , VALUE r ) {
  Gecode::REG* tmp = ruby2Gecode_REGPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::REG((*tmp) += ruby2Gecode_REG(r, 1) ), true );

}


VALUE fGecode_Gecode_REG_undefop_0251 ( VALUE self , VALUE r ) {
  Gecode::REG* tmp = ruby2Gecode_REGPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::REG((*tmp) | ruby2Gecode_REG(r, 1) ), true );

}


VALUE fGecode_Gecode_REG_undefop_0426 ( VALUE self , VALUE r ) {
  Gecode::REG* tmp = ruby2Gecode_REGPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::REG((*tmp) |= ruby2Gecode_REG(r, 1) ), true );

}


VALUE fGecode_Gecode_REG_multop ( VALUE self  ) {
  Gecode::REG* tmp = ruby2Gecode_REGPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::REG(* (*tmp)), true );

}


VALUE fGecode_Gecode_REG_parenthesisop ( int argc, VALUE *argv, VALUE self ) {
  Gecode::REG* tmp = ruby2Gecode_REGPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_int(argv[0]) ) {
           return cxx2ruby( new Gecode::REG((*tmp) ( ruby2int(argv[0], 1) ) ), true );
           ok = true;
}
     } break;
     case 2: {
// Case 0
      if( is_int(argv[0]) ) {
      if( is_int(argv[1]) ) {
           return cxx2ruby( new Gecode::REG((*tmp) ( ruby2int(argv[0], 1),ruby2int(argv[1], 2) ) ), true );
           ok = true;
}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE rSearch;

VALUE rGecode_Search_MStop;

bool is_Gecode_Search_MStop(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::Search::MStop *obj = 0;
    
    Data_Get_Struct(val, Gecode::Search::MStop, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_Search_MStop) == Qtrue;
  }
  
  return false;
}

Gecode::Search::MStop* ruby2Gecode_Search_MStopPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_Search_MStop(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::Search::MStop given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::Search::MStop given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::Search::MStop* ptr;
   Data_Get_Struct(rval, Gecode::Search::MStop, ptr);

   if ( ptr ) return dynamic_cast< Gecode::Search::MStop* >(ptr);

   TGecode_Search_MStopMap::iterator it = Gecode_Search_MStopMap.find(rval);

   if ( it == Gecode_Search_MStopMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::Search::MStop instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::Search::MStop* >((*it).second);
}

Gecode::Search::MStop& ruby2Gecode_Search_MStop(VALUE rval, int argn) {
  return *ruby2Gecode_Search_MStopPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::Search::MStop* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_Search_MStopMap::iterator it, eend = Gecode_Search_MStopMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::Search::MStop %p\n", instance);
#endif

  for(it = Gecode_Search_MStopMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::Search::MStop*)instance ) break;

   if ( it != Gecode_Search_MStopMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_Search_MStop;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_Search_MStop_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_Search_MStop_mark, Gecode_Search_MStop_free, (void*)instance);
      }
      
      Gecode_Search_MStopMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_Search_MStop_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_Search_MStop_mark, Gecode_Search_MStop_free, 0);
}

TGecode_Search_MStopMap Gecode_Search_MStopMap;

static void Gecode_Search_MStop_free(void *p) {
	Gecode_Search_MStop_free_map_entry(p);
  delete (Gecode::Search::MStop*)p;
}

static void Gecode_Search_MStop_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_Search_MStop) \n", p);
#endif

  TGecode_Search_MStopMap::iterator it, eend = Gecode_Search_MStopMap.end();
  for(it = Gecode_Search_MStopMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::Search::MStop*)p ) {
        Gecode_Search_MStopMap.erase(it); break;
     }
}

static void Gecode_Search_MStop_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_Search_MStop) \n", p);
#endif
}

VALUE fGecode_Search_MStopMStop ( int argc, VALUE *argv, VALUE self ) {
  Gecode::Search::MStop* tmp;
  Data_Get_Struct(self, Gecode::Search::MStop, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 3: {
// Case 0
      if( is_int(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_int(argv[2]) ) {
           tmp = new Gecode::Search::MStop(ruby2int(argv[0], 1),ruby2int(argv[1], 2),ruby2int(argv[2], 3));
           ok = true;
}}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::Search::MStop();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_Search_MStopMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::Search::MStop (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE rGecode_Search_Statistics;

bool is_Gecode_Search_Statistics(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::Search::Statistics *obj = 0;
    
    Data_Get_Struct(val, Gecode::Search::Statistics, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_Search_Statistics) == Qtrue;
  }
  
  return false;
}

Gecode::Search::Statistics* ruby2Gecode_Search_StatisticsPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_Search_Statistics(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::Search::Statistics given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::Search::Statistics given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::Search::Statistics* ptr;
   Data_Get_Struct(rval, Gecode::Search::Statistics, ptr);

   if ( ptr ) return dynamic_cast< Gecode::Search::Statistics* >(ptr);

   TGecode_Search_StatisticsMap::iterator it = Gecode_Search_StatisticsMap.find(rval);

   if ( it == Gecode_Search_StatisticsMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::Search::Statistics instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::Search::Statistics* >((*it).second);
}

Gecode::Search::Statistics& ruby2Gecode_Search_Statistics(VALUE rval, int argn) {
  return *ruby2Gecode_Search_StatisticsPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::Search::Statistics* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_Search_StatisticsMap::iterator it, eend = Gecode_Search_StatisticsMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::Search::Statistics %p\n", instance);
#endif

  for(it = Gecode_Search_StatisticsMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::Search::Statistics*)instance ) break;

   if ( it != Gecode_Search_StatisticsMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_Search_Statistics;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_Search_Statistics_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_Search_Statistics_mark, Gecode_Search_Statistics_free, (void*)instance);
      }
      
      Gecode_Search_StatisticsMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_Search_Statistics_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_Search_Statistics_mark, Gecode_Search_Statistics_free, 0);
}

TGecode_Search_StatisticsMap Gecode_Search_StatisticsMap;

static void Gecode_Search_Statistics_free(void *p) {
	Gecode_Search_Statistics_free_map_entry(p);
  delete (Gecode::Search::Statistics*)p;
}

static void Gecode_Search_Statistics_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_Search_Statistics) \n", p);
#endif

  TGecode_Search_StatisticsMap::iterator it, eend = Gecode_Search_StatisticsMap.end();
  for(it = Gecode_Search_StatisticsMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::Search::Statistics*)p ) {
        Gecode_Search_StatisticsMap.erase(it); break;
     }
}

static void Gecode_Search_Statistics_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_Search_Statistics) \n", p);
#endif
}

VALUE fGecode_Search_StatisticsStatistics ( VALUE self  ) {
  Gecode::Search::Statistics* tmp;
  Data_Get_Struct(self, Gecode::Search::Statistics, tmp);

  /* The exception is thrown already by ruby2* if not found */

  tmp = new Gecode::Search::Statistics();
;

  DATA_PTR(self) = tmp;
  Gecode_Search_StatisticsMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::Search::Statistics (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE setGecode_Search_Statisticsmemory(VALUE self, VALUE val) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  tmp->memory = ruby2int(val);
  return Qnil;
}

VALUE getGecode_Search_Statisticsmemory(VALUE self) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  return cxx2ruby(static_cast<int>(tmp->memory));
}


VALUE setGecode_Search_Statisticspropagate(VALUE self, VALUE val) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  tmp->propagate = ruby2int(val);
  return Qnil;
}

VALUE getGecode_Search_Statisticspropagate(VALUE self) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  return cxx2ruby(static_cast<int>(tmp->propagate));
}


VALUE setGecode_Search_Statisticsfail(VALUE self, VALUE val) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  tmp->fail = ruby2int(val);
  return Qnil;
}

VALUE getGecode_Search_Statisticsfail(VALUE self) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  return cxx2ruby(static_cast<int>(tmp->fail));
}


VALUE setGecode_Search_Statisticsclone(VALUE self, VALUE val) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  tmp->clone = ruby2int(val);
  return Qnil;
}

VALUE getGecode_Search_Statisticsclone(VALUE self) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  return cxx2ruby(static_cast<int>(tmp->clone));
}


VALUE setGecode_Search_Statisticscommit(VALUE self, VALUE val) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  tmp->commit = ruby2int(val);
  return Qnil;
}

VALUE getGecode_Search_Statisticscommit(VALUE self) {
  Gecode::Search::Statistics* tmp = ruby2Gecode_Search_StatisticsPtr(self);
  if ( ! tmp ) return Qnil;
  
  return cxx2ruby(static_cast<int>(tmp->commit));
}


VALUE rGecode_Search_Options;

bool is_Gecode_Search_Options(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::Search::Options *obj = 0;
    
    Data_Get_Struct(val, Gecode::Search::Options, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_Search_Options) == Qtrue;
  }
  
  return false;
}

Gecode::Search::Options* ruby2Gecode_Search_OptionsPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_Search_Options(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::Search::Options given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::Search::Options given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::Search::Options* ptr;
   Data_Get_Struct(rval, Gecode::Search::Options, ptr);

   if ( ptr ) return dynamic_cast< Gecode::Search::Options* >(ptr);

   TGecode_Search_OptionsMap::iterator it = Gecode_Search_OptionsMap.find(rval);

   if ( it == Gecode_Search_OptionsMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::Search::Options instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::Search::Options* >((*it).second);
}

Gecode::Search::Options& ruby2Gecode_Search_Options(VALUE rval, int argn) {
  return *ruby2Gecode_Search_OptionsPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::Search::Options* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_Search_OptionsMap::iterator it, eend = Gecode_Search_OptionsMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::Search::Options %p\n", instance);
#endif

  for(it = Gecode_Search_OptionsMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::Search::Options*)instance ) break;

   if ( it != Gecode_Search_OptionsMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_Search_Options;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_Search_Options_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_Search_Options_mark, Gecode_Search_Options_free, (void*)instance);
      }
      
      Gecode_Search_OptionsMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_Search_Options_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_Search_Options_mark, Gecode_Search_Options_free, 0);
}

TGecode_Search_OptionsMap Gecode_Search_OptionsMap;

static void Gecode_Search_Options_free(void *p) {
	Gecode_Search_Options_free_map_entry(p);
  delete (Gecode::Search::Options*)p;
}

static void Gecode_Search_Options_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_Search_Options) \n", p);
#endif

  TGecode_Search_OptionsMap::iterator it, eend = Gecode_Search_OptionsMap.end();
  for(it = Gecode_Search_OptionsMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::Search::Options*)p ) {
        Gecode_Search_OptionsMap.erase(it); break;
     }
}

static void Gecode_Search_Options_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_Search_Options) \n", p);
#endif
}

VALUE fGecode_Search_OptionsOptions ( VALUE self  ) {
  Gecode::Search::Options* tmp;
  Data_Get_Struct(self, Gecode::Search::Options, tmp);

  /* The exception is thrown already by ruby2* if not found */

  tmp = new Gecode::Search::Options();
;

  DATA_PTR(self) = tmp;
  Gecode_Search_OptionsMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::Search::Options (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE setGecode_Search_Optionsc_d(VALUE self, VALUE val) {
  Gecode::Search::Options* tmp = ruby2Gecode_Search_OptionsPtr(self);
  if ( ! tmp ) return Qnil;
  
  tmp->c_d = ruby2int(val);
  return Qnil;
}

VALUE getGecode_Search_Optionsc_d(VALUE self) {
  Gecode::Search::Options* tmp = ruby2Gecode_Search_OptionsPtr(self);
  if ( ! tmp ) return Qnil;
  
  return cxx2ruby(static_cast<int>(tmp->c_d));
}


VALUE setGecode_Search_Optionsa_d(VALUE self, VALUE val) {
  Gecode::Search::Options* tmp = ruby2Gecode_Search_OptionsPtr(self);
  if ( ! tmp ) return Qnil;
  
  tmp->a_d = ruby2int(val);
  return Qnil;
}

VALUE getGecode_Search_Optionsa_d(VALUE self) {
  Gecode::Search::Options* tmp = ruby2Gecode_Search_OptionsPtr(self);
  if ( ! tmp ) return Qnil;
  
  return cxx2ruby(static_cast<int>(tmp->a_d));
}


VALUE setGecode_Search_Optionsstop(VALUE self, VALUE val) {
  Gecode::Search::Options* tmp = ruby2Gecode_Search_OptionsPtr(self);
  if ( ! tmp ) return Qnil;
  
  tmp->stop = ruby2Gecode_Search_MStopPtr(val);
  return Qnil;
}

VALUE getGecode_Search_Optionsstop(VALUE self) {
  Gecode::Search::Options* tmp = ruby2Gecode_Search_OptionsPtr(self);
  if ( ! tmp ) return Qnil;
  
  return cxx2ruby(static_cast<Gecode::Search::MStop*>(tmp->stop));
}


VALUE rConfig;



VALUE rMiniModel;

VALUE rGecode_MiniModel_LinExprGecode_IntVar;

bool is_Gecode_MiniModel_LinExprGecode_IntVar(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MiniModel::LinExpr<Gecode::IntVar> *obj = 0;
    
    Data_Get_Struct(val, Gecode::MiniModel::LinExpr<Gecode::IntVar>, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MiniModel_LinExprGecode_IntVar) == Qtrue;
  }
  
  return false;
}

Gecode::MiniModel::LinExpr<Gecode::IntVar>* ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MiniModel_LinExprGecode_IntVar(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::LinExpr<Gecode::IntVar> given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::LinExpr<Gecode::IntVar> given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MiniModel::LinExpr<Gecode::IntVar>* ptr;
   Data_Get_Struct(rval, Gecode::MiniModel::LinExpr<Gecode::IntVar>, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MiniModel::LinExpr<Gecode::IntVar>* >(ptr);

   TGecode_MiniModel_LinExprGecode_IntVarMap::iterator it = Gecode_MiniModel_LinExprGecode_IntVarMap.find(rval);

   if ( it == Gecode_MiniModel_LinExprGecode_IntVarMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MiniModel::LinExpr<Gecode::IntVar> instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MiniModel::LinExpr<Gecode::IntVar>* >((*it).second);
}

Gecode::MiniModel::LinExpr<Gecode::IntVar>& ruby2Gecode_MiniModel_LinExprGecode_IntVar(VALUE rval, int argn) {
  return *ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MiniModel::LinExpr<Gecode::IntVar>* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MiniModel_LinExprGecode_IntVarMap::iterator it, eend = Gecode_MiniModel_LinExprGecode_IntVarMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MiniModel::LinExpr<Gecode::IntVar> %p\n", instance);
#endif

  for(it = Gecode_MiniModel_LinExprGecode_IntVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::LinExpr<Gecode::IntVar>*)instance ) break;

   if ( it != Gecode_MiniModel_LinExprGecode_IntVarMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MiniModel_LinExprGecode_IntVar;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MiniModel_LinExprGecode_IntVar_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MiniModel_LinExprGecode_IntVar_mark, Gecode_MiniModel_LinExprGecode_IntVar_free, (void*)instance);
      }
      
      Gecode_MiniModel_LinExprGecode_IntVarMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MiniModel_LinExprGecode_IntVar_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MiniModel_LinExprGecode_IntVar_mark, Gecode_MiniModel_LinExprGecode_IntVar_free, 0);
}

TGecode_MiniModel_LinExprGecode_IntVarMap Gecode_MiniModel_LinExprGecode_IntVarMap;

static void Gecode_MiniModel_LinExprGecode_IntVar_free(void *p) {
	Gecode_MiniModel_LinExprGecode_IntVar_free_map_entry(p);
  delete (Gecode::MiniModel::LinExpr<Gecode::IntVar>*)p;
}

static void Gecode_MiniModel_LinExprGecode_IntVar_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MiniModel_LinExprGecode_IntVar) \n", p);
#endif

  TGecode_MiniModel_LinExprGecode_IntVarMap::iterator it, eend = Gecode_MiniModel_LinExprGecode_IntVarMap.end();
  for(it = Gecode_MiniModel_LinExprGecode_IntVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::LinExpr<Gecode::IntVar>*)p ) {
        Gecode_MiniModel_LinExprGecode_IntVarMap.erase(it); break;
     }
}

static void Gecode_MiniModel_LinExprGecode_IntVar_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MiniModel_LinExprGecode_IntVar) \n", p);
#endif
}

VALUE fGecode_MiniModel_LinExprGecode_IntVarLinExprGecode_IntVar ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinExpr<Gecode::IntVar>* tmp;
  Data_Get_Struct(self, Gecode::MiniModel::LinExpr<Gecode::IntVar>, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 2: {
// Case 0
      if( is_Gecode_IntVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>(ruby2Gecode_IntVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 1
      if( is_Gecode_IntVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>(ruby2Gecode_IntVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 2
      if( is_Gecode_IntVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>(ruby2Gecode_IntVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 3
      if( is_Gecode_IntVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>(ruby2Gecode_IntVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 4
      if( is_Gecode_IntVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>(ruby2Gecode_IntVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 5
      if( is_Gecode_IntVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>(ruby2Gecode_IntVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 6
      if( is_Gecode_IntVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>(ruby2Gecode_IntVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 7
      if( is_Gecode_IntVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>(ruby2Gecode_IntVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::MiniModel::LinExpr<Gecode::IntVar>();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_MiniModel_LinExprGecode_IntVarMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MiniModel::LinExpr<Gecode::IntVar> (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fMiniModel_Gecode_MiniModel_LinExprGecode_IntVar_post ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinExpr<Gecode::IntVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_Gecode_BoolVar(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2Gecode_BoolVar(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_plusop ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinExpr<Gecode::IntVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_Gecode_IntVar(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) + ruby2Gecode_IntVar(argv[0], 1) ), true );
           ok = true;
}
// Case 1
      if( is_int(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) + ruby2int(argv[0], 1) ), true );
           ok = true;
}
// Case 2
      if( is_Gecode_MiniModel_LinExprGecode_IntVar(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) + ruby2Gecode_MiniModel_LinExprGecode_IntVar(argv[0], 1) ), true );
           ok = true;
}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_minusop ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinExpr<Gecode::IntVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_Gecode_IntVar(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) - ruby2Gecode_IntVar(argv[0], 1) ), true );
           ok = true;
}
// Case 1
      if( is_int(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) - ruby2int(argv[0], 1) ), true );
           ok = true;
}
// Case 2
      if( is_Gecode_MiniModel_LinExprGecode_IntVar(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) - ruby2Gecode_MiniModel_LinExprGecode_IntVar(argv[0], 1) ), true );
           ok = true;
}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_multop ( VALUE self , VALUE c ) {
  Gecode::MiniModel::LinExpr<Gecode::IntVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::IntVar>((*tmp) * ruby2int(c, 1) ), true );

}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_equalop ( VALUE self , VALUE other ) {
  Gecode::MiniModel::LinExpr<Gecode::IntVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinRel<Gecode::IntVar>((*tmp) == ruby2Gecode_MiniModel_LinExprGecode_IntVar(other, 1) ), true );

}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_notequalop ( VALUE self , VALUE other ) {
  Gecode::MiniModel::LinExpr<Gecode::IntVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinRel<Gecode::IntVar>((*tmp) != ruby2Gecode_MiniModel_LinExprGecode_IntVar(other, 1) ), true );

}


VALUE rGecode_MiniModel_LinExprGecode_BoolVar;

bool is_Gecode_MiniModel_LinExprGecode_BoolVar(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MiniModel::LinExpr<Gecode::BoolVar> *obj = 0;
    
    Data_Get_Struct(val, Gecode::MiniModel::LinExpr<Gecode::BoolVar>, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MiniModel_LinExprGecode_BoolVar) == Qtrue;
  }
  
  return false;
}

Gecode::MiniModel::LinExpr<Gecode::BoolVar>* ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MiniModel_LinExprGecode_BoolVar(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::LinExpr<Gecode::BoolVar> given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::LinExpr<Gecode::BoolVar> given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MiniModel::LinExpr<Gecode::BoolVar>* ptr;
   Data_Get_Struct(rval, Gecode::MiniModel::LinExpr<Gecode::BoolVar>, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MiniModel::LinExpr<Gecode::BoolVar>* >(ptr);

   TGecode_MiniModel_LinExprGecode_BoolVarMap::iterator it = Gecode_MiniModel_LinExprGecode_BoolVarMap.find(rval);

   if ( it == Gecode_MiniModel_LinExprGecode_BoolVarMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MiniModel::LinExpr<Gecode::BoolVar> instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MiniModel::LinExpr<Gecode::BoolVar>* >((*it).second);
}

Gecode::MiniModel::LinExpr<Gecode::BoolVar>& ruby2Gecode_MiniModel_LinExprGecode_BoolVar(VALUE rval, int argn) {
  return *ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MiniModel::LinExpr<Gecode::BoolVar>* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MiniModel_LinExprGecode_BoolVarMap::iterator it, eend = Gecode_MiniModel_LinExprGecode_BoolVarMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MiniModel::LinExpr<Gecode::BoolVar> %p\n", instance);
#endif

  for(it = Gecode_MiniModel_LinExprGecode_BoolVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::LinExpr<Gecode::BoolVar>*)instance ) break;

   if ( it != Gecode_MiniModel_LinExprGecode_BoolVarMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MiniModel_LinExprGecode_BoolVar;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MiniModel_LinExprGecode_BoolVar_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MiniModel_LinExprGecode_BoolVar_mark, Gecode_MiniModel_LinExprGecode_BoolVar_free, (void*)instance);
      }
      
      Gecode_MiniModel_LinExprGecode_BoolVarMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MiniModel_LinExprGecode_BoolVar_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MiniModel_LinExprGecode_BoolVar_mark, Gecode_MiniModel_LinExprGecode_BoolVar_free, 0);
}

TGecode_MiniModel_LinExprGecode_BoolVarMap Gecode_MiniModel_LinExprGecode_BoolVarMap;

static void Gecode_MiniModel_LinExprGecode_BoolVar_free(void *p) {
	Gecode_MiniModel_LinExprGecode_BoolVar_free_map_entry(p);
  delete (Gecode::MiniModel::LinExpr<Gecode::BoolVar>*)p;
}

static void Gecode_MiniModel_LinExprGecode_BoolVar_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MiniModel_LinExprGecode_BoolVar) \n", p);
#endif

  TGecode_MiniModel_LinExprGecode_BoolVarMap::iterator it, eend = Gecode_MiniModel_LinExprGecode_BoolVarMap.end();
  for(it = Gecode_MiniModel_LinExprGecode_BoolVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::LinExpr<Gecode::BoolVar>*)p ) {
        Gecode_MiniModel_LinExprGecode_BoolVarMap.erase(it); break;
     }
}

static void Gecode_MiniModel_LinExprGecode_BoolVar_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MiniModel_LinExprGecode_BoolVar) \n", p);
#endif
}

VALUE fGecode_MiniModel_LinExprGecode_BoolVarLinExprGecode_BoolVar ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinExpr<Gecode::BoolVar>* tmp;
  Data_Get_Struct(self, Gecode::MiniModel::LinExpr<Gecode::BoolVar>, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 2: {
// Case 0
      if( is_Gecode_BoolVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>(ruby2Gecode_BoolVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 1
      if( is_Gecode_BoolVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>(ruby2Gecode_BoolVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 2
      if( is_Gecode_BoolVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>(ruby2Gecode_BoolVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 3
      if( is_Gecode_BoolVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>(ruby2Gecode_BoolVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 4
      if( is_Gecode_BoolVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>(ruby2Gecode_BoolVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 5
      if( is_Gecode_BoolVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>(ruby2Gecode_BoolVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 6
      if( is_Gecode_BoolVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>(ruby2Gecode_BoolVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
// Case 7
      if( is_Gecode_BoolVar(argv[0]) ) {
      if( is_int(argv[1]) ) {
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>(ruby2Gecode_BoolVar(argv[0], 1),ruby2int(argv[1], 2));
           ok = true;
}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::MiniModel::LinExpr<Gecode::BoolVar>();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_MiniModel_LinExprGecode_BoolVarMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MiniModel::LinExpr<Gecode::BoolVar> (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fMiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_post ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinExpr<Gecode::BoolVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_Gecode_BoolVar(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2Gecode_BoolVar(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_plusop ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinExpr<Gecode::BoolVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_Gecode_BoolVar(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) + ruby2Gecode_BoolVar(argv[0], 1) ), true );
           ok = true;
}
// Case 1
      if( is_int(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) + ruby2int(argv[0], 1) ), true );
           ok = true;
}
// Case 2
      if( is_Gecode_MiniModel_LinExprGecode_BoolVar(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) + ruby2Gecode_MiniModel_LinExprGecode_BoolVar(argv[0], 1) ), true );
           ok = true;
}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_minusop ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinExpr<Gecode::BoolVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_Gecode_BoolVar(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) - ruby2Gecode_BoolVar(argv[0], 1) ), true );
           ok = true;
}
// Case 1
      if( is_int(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) - ruby2int(argv[0], 1) ), true );
           ok = true;
}
// Case 2
      if( is_Gecode_MiniModel_LinExprGecode_BoolVar(argv[0]) ) {
           return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) - ruby2Gecode_MiniModel_LinExprGecode_BoolVar(argv[0], 1) ), true );
           ok = true;
}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_multop ( VALUE self , VALUE c ) {
  Gecode::MiniModel::LinExpr<Gecode::BoolVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinExpr<Gecode::BoolVar>((*tmp) * ruby2int(c, 1) ), true );

}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_equalop ( VALUE self , VALUE other ) {
  Gecode::MiniModel::LinExpr<Gecode::BoolVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinRel<Gecode::BoolVar>((*tmp) == ruby2Gecode_MiniModel_LinExprGecode_BoolVar(other, 1) ), true );

}


VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_notequalop ( VALUE self , VALUE other ) {
  Gecode::MiniModel::LinExpr<Gecode::BoolVar>* tmp = ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
  return cxx2ruby( new Gecode::MiniModel::LinRel<Gecode::BoolVar>((*tmp) != ruby2Gecode_MiniModel_LinExprGecode_BoolVar(other, 1) ), true );

}


VALUE rGecode_MiniModel_BoolExpr;

bool is_Gecode_MiniModel_BoolExpr(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MiniModel::BoolExpr *obj = 0;
    
    Data_Get_Struct(val, Gecode::MiniModel::BoolExpr, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MiniModel_BoolExpr) == Qtrue;
  }
  
  return false;
}

Gecode::MiniModel::BoolExpr* ruby2Gecode_MiniModel_BoolExprPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MiniModel_BoolExpr(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::BoolExpr given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::BoolExpr given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MiniModel::BoolExpr* ptr;
   Data_Get_Struct(rval, Gecode::MiniModel::BoolExpr, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MiniModel::BoolExpr* >(ptr);

   TGecode_MiniModel_BoolExprMap::iterator it = Gecode_MiniModel_BoolExprMap.find(rval);

   if ( it == Gecode_MiniModel_BoolExprMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MiniModel::BoolExpr instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MiniModel::BoolExpr* >((*it).second);
}

Gecode::MiniModel::BoolExpr& ruby2Gecode_MiniModel_BoolExpr(VALUE rval, int argn) {
  return *ruby2Gecode_MiniModel_BoolExprPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MiniModel::BoolExpr* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MiniModel_BoolExprMap::iterator it, eend = Gecode_MiniModel_BoolExprMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MiniModel::BoolExpr %p\n", instance);
#endif

  for(it = Gecode_MiniModel_BoolExprMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::BoolExpr*)instance ) break;

   if ( it != Gecode_MiniModel_BoolExprMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MiniModel_BoolExpr;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MiniModel_BoolExpr_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MiniModel_BoolExpr_mark, Gecode_MiniModel_BoolExpr_free, (void*)instance);
      }
      
      Gecode_MiniModel_BoolExprMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MiniModel_BoolExpr_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MiniModel_BoolExpr_mark, Gecode_MiniModel_BoolExpr_free, 0);
}

TGecode_MiniModel_BoolExprMap Gecode_MiniModel_BoolExprMap;

static void Gecode_MiniModel_BoolExpr_free(void *p) {
	Gecode_MiniModel_BoolExpr_free_map_entry(p);
  delete (Gecode::MiniModel::BoolExpr*)p;
}

static void Gecode_MiniModel_BoolExpr_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MiniModel_BoolExpr) \n", p);
#endif

  TGecode_MiniModel_BoolExprMap::iterator it, eend = Gecode_MiniModel_BoolExprMap.end();
  for(it = Gecode_MiniModel_BoolExprMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::BoolExpr*)p ) {
        Gecode_MiniModel_BoolExprMap.erase(it); break;
     }
}

static void Gecode_MiniModel_BoolExpr_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MiniModel_BoolExpr) \n", p);
#endif
}

Gecode::MiniModel::BoolExpr::NodeType ruby2Gecode_MiniModel_BoolExpr_NodeType(VALUE rval, int argn) {
  int cval = ruby2int(rval, argn);

  switch(cval) {
    case Gecode::MiniModel::BoolExpr::NT_VAR:
case Gecode::MiniModel::BoolExpr::NT_NOT:
case Gecode::MiniModel::BoolExpr::NT_AND:
case Gecode::MiniModel::BoolExpr::NT_OR:
case Gecode::MiniModel::BoolExpr::NT_IMP:
case Gecode::MiniModel::BoolExpr::NT_XOR:
case Gecode::MiniModel::BoolExpr::NT_EQV:
case Gecode::MiniModel::BoolExpr::NT_RLIN_INT:
case Gecode::MiniModel::BoolExpr::NT_RLIN_BOOL:
      return static_cast<Gecode::MiniModel::BoolExpr::NodeType>(cval);
    default:
      if( argn > 0)
        rb_raise(rb_eArgError, "value %d for enum NodeType is out of bound for argument %d", cval, argn);
      else
        rb_raise(rb_eArgError, "value %d for enum NodeType is out of bound", cval);
      return static_cast<Gecode::MiniModel::BoolExpr::NodeType>(-1);
  }
}

bool is_Gecode_MiniModel_BoolExpr_NodeType(VALUE rval) {
  if( is_int(rval) )
  {
    switch(ruby2int(rval))
    {
      case Gecode::MiniModel::BoolExpr::NT_VAR:
case Gecode::MiniModel::BoolExpr::NT_NOT:
case Gecode::MiniModel::BoolExpr::NT_AND:
case Gecode::MiniModel::BoolExpr::NT_OR:
case Gecode::MiniModel::BoolExpr::NT_IMP:
case Gecode::MiniModel::BoolExpr::NT_XOR:
case Gecode::MiniModel::BoolExpr::NT_EQV:
case Gecode::MiniModel::BoolExpr::NT_RLIN_INT:
case Gecode::MiniModel::BoolExpr::NT_RLIN_BOOL:
        return true;
    }
  }
  
  return false;
}

VALUE fGecode_MiniModel_BoolExprBoolExpr ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::BoolExpr* tmp;
  Data_Get_Struct(self, Gecode::MiniModel::BoolExpr, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 1: {
// Case 0
      if( is_Gecode_BoolVar(argv[0]) ) {
           tmp = new Gecode::MiniModel::BoolExpr(ruby2Gecode_BoolVar(argv[0], 1));
           ok = true;
}
// Case 1
      if( is_Gecode_MiniModel_LinRelGecode_IntVar(argv[0]) ) {
           tmp = new Gecode::MiniModel::BoolExpr(ruby2Gecode_MiniModel_LinRelGecode_IntVar(argv[0], 1));
           ok = true;
}
// Case 2
      if( is_Gecode_MiniModel_LinRelGecode_BoolVar(argv[0]) ) {
           tmp = new Gecode::MiniModel::BoolExpr(ruby2Gecode_MiniModel_LinRelGecode_BoolVar(argv[0], 1));
           ok = true;
}
// Case 3
      if( is_Gecode_MiniModel_BoolExpr(argv[0]) ) {
           tmp = new Gecode::MiniModel::BoolExpr(ruby2Gecode_MiniModel_BoolExpr(argv[0], 1));
           ok = true;
}
     } break;
     case 3: {
// Case 0
      if( is_Gecode_MiniModel_BoolExpr(argv[0]) ) {
      if( is_Gecode_MiniModel_BoolExpr_NodeType(argv[1]) ) {
      if( is_Gecode_MiniModel_BoolExpr(argv[2]) ) {
           tmp = new Gecode::MiniModel::BoolExpr(ruby2Gecode_MiniModel_BoolExpr(argv[0], 1),ruby2Gecode_MiniModel_BoolExpr_NodeType(argv[1], 2),ruby2Gecode_MiniModel_BoolExpr(argv[2], 3));
           ok = true;
}}}
     } break;
     case 2: {
// Case 0
      if( is_Gecode_MiniModel_BoolExpr(argv[0]) ) {
      if( is_Gecode_MiniModel_BoolExpr_NodeType(argv[1]) ) {
           tmp = new Gecode::MiniModel::BoolExpr(ruby2Gecode_MiniModel_BoolExpr(argv[0], 1),ruby2Gecode_MiniModel_BoolExpr_NodeType(argv[1], 2));
           ok = true;
}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_MiniModel_BoolExprMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MiniModel::BoolExpr (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fMiniModel_Gecode_MiniModel_BoolExpr_post ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::BoolExpr* tmp = ruby2Gecode_MiniModel_BoolExprPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_bool(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2bool(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;
     case 3: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntConLevel(argv[1]) ) {
      if( is_Gecode_PropKind(argv[2]) ) {
           return cxx2ruby( new Gecode::BoolVar(tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntConLevel(argv[1], 2),ruby2Gecode_PropKind(argv[2], 3))), true );
           ok = true;
}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE rGecode_MiniModel_BoolRel;

bool is_Gecode_MiniModel_BoolRel(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MiniModel::BoolRel *obj = 0;
    
    Data_Get_Struct(val, Gecode::MiniModel::BoolRel, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MiniModel_BoolRel) == Qtrue;
  }
  
  return false;
}

Gecode::MiniModel::BoolRel* ruby2Gecode_MiniModel_BoolRelPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MiniModel_BoolRel(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::BoolRel given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::BoolRel given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MiniModel::BoolRel* ptr;
   Data_Get_Struct(rval, Gecode::MiniModel::BoolRel, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MiniModel::BoolRel* >(ptr);

   TGecode_MiniModel_BoolRelMap::iterator it = Gecode_MiniModel_BoolRelMap.find(rval);

   if ( it == Gecode_MiniModel_BoolRelMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MiniModel::BoolRel instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MiniModel::BoolRel* >((*it).second);
}

Gecode::MiniModel::BoolRel& ruby2Gecode_MiniModel_BoolRel(VALUE rval, int argn) {
  return *ruby2Gecode_MiniModel_BoolRelPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MiniModel::BoolRel* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MiniModel_BoolRelMap::iterator it, eend = Gecode_MiniModel_BoolRelMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MiniModel::BoolRel %p\n", instance);
#endif

  for(it = Gecode_MiniModel_BoolRelMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::BoolRel*)instance ) break;

   if ( it != Gecode_MiniModel_BoolRelMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MiniModel_BoolRel;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MiniModel_BoolRel_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MiniModel_BoolRel_mark, Gecode_MiniModel_BoolRel_free, (void*)instance);
      }
      
      Gecode_MiniModel_BoolRelMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MiniModel_BoolRel_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MiniModel_BoolRel_mark, Gecode_MiniModel_BoolRel_free, 0);
}

TGecode_MiniModel_BoolRelMap Gecode_MiniModel_BoolRelMap;

static void Gecode_MiniModel_BoolRel_free(void *p) {
	Gecode_MiniModel_BoolRel_free_map_entry(p);
  delete (Gecode::MiniModel::BoolRel*)p;
}

static void Gecode_MiniModel_BoolRel_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MiniModel_BoolRel) \n", p);
#endif

  TGecode_MiniModel_BoolRelMap::iterator it, eend = Gecode_MiniModel_BoolRelMap.end();
  for(it = Gecode_MiniModel_BoolRelMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::BoolRel*)p ) {
        Gecode_MiniModel_BoolRelMap.erase(it); break;
     }
}

static void Gecode_MiniModel_BoolRel_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MiniModel_BoolRel) \n", p);
#endif
}

VALUE fGecode_MiniModel_BoolRelBoolRel ( VALUE self , VALUE e, VALUE t ) {
  Gecode::MiniModel::BoolRel* tmp;
  Data_Get_Struct(self, Gecode::MiniModel::BoolRel, tmp);

  /* The exception is thrown already by ruby2* if not found */

  tmp = new Gecode::MiniModel::BoolRel(ruby2Gecode_MiniModel_BoolExpr(e, 1),ruby2bool(t, 2));
;

  DATA_PTR(self) = tmp;
  Gecode_MiniModel_BoolRelMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MiniModel::BoolRel (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE rGecode_MiniModel_LinRelGecode_IntVar;

bool is_Gecode_MiniModel_LinRelGecode_IntVar(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MiniModel::LinRel<Gecode::IntVar> *obj = 0;
    
    Data_Get_Struct(val, Gecode::MiniModel::LinRel<Gecode::IntVar>, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MiniModel_LinRelGecode_IntVar) == Qtrue;
  }
  
  return false;
}

Gecode::MiniModel::LinRel<Gecode::IntVar>* ruby2Gecode_MiniModel_LinRelGecode_IntVarPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MiniModel_LinRelGecode_IntVar(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::LinRel<Gecode::IntVar> given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::LinRel<Gecode::IntVar> given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MiniModel::LinRel<Gecode::IntVar>* ptr;
   Data_Get_Struct(rval, Gecode::MiniModel::LinRel<Gecode::IntVar>, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MiniModel::LinRel<Gecode::IntVar>* >(ptr);

   TGecode_MiniModel_LinRelGecode_IntVarMap::iterator it = Gecode_MiniModel_LinRelGecode_IntVarMap.find(rval);

   if ( it == Gecode_MiniModel_LinRelGecode_IntVarMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MiniModel::LinRel<Gecode::IntVar> instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MiniModel::LinRel<Gecode::IntVar>* >((*it).second);
}

Gecode::MiniModel::LinRel<Gecode::IntVar>& ruby2Gecode_MiniModel_LinRelGecode_IntVar(VALUE rval, int argn) {
  return *ruby2Gecode_MiniModel_LinRelGecode_IntVarPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MiniModel::LinRel<Gecode::IntVar>* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MiniModel_LinRelGecode_IntVarMap::iterator it, eend = Gecode_MiniModel_LinRelGecode_IntVarMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MiniModel::LinRel<Gecode::IntVar> %p\n", instance);
#endif

  for(it = Gecode_MiniModel_LinRelGecode_IntVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::LinRel<Gecode::IntVar>*)instance ) break;

   if ( it != Gecode_MiniModel_LinRelGecode_IntVarMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MiniModel_LinRelGecode_IntVar;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MiniModel_LinRelGecode_IntVar_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MiniModel_LinRelGecode_IntVar_mark, Gecode_MiniModel_LinRelGecode_IntVar_free, (void*)instance);
      }
      
      Gecode_MiniModel_LinRelGecode_IntVarMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MiniModel_LinRelGecode_IntVar_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MiniModel_LinRelGecode_IntVar_mark, Gecode_MiniModel_LinRelGecode_IntVar_free, 0);
}

TGecode_MiniModel_LinRelGecode_IntVarMap Gecode_MiniModel_LinRelGecode_IntVarMap;

static void Gecode_MiniModel_LinRelGecode_IntVar_free(void *p) {
	Gecode_MiniModel_LinRelGecode_IntVar_free_map_entry(p);
  delete (Gecode::MiniModel::LinRel<Gecode::IntVar>*)p;
}

static void Gecode_MiniModel_LinRelGecode_IntVar_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MiniModel_LinRelGecode_IntVar) \n", p);
#endif

  TGecode_MiniModel_LinRelGecode_IntVarMap::iterator it, eend = Gecode_MiniModel_LinRelGecode_IntVarMap.end();
  for(it = Gecode_MiniModel_LinRelGecode_IntVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::LinRel<Gecode::IntVar>*)p ) {
        Gecode_MiniModel_LinRelGecode_IntVarMap.erase(it); break;
     }
}

static void Gecode_MiniModel_LinRelGecode_IntVar_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MiniModel_LinRelGecode_IntVar) \n", p);
#endif
}

VALUE fGecode_MiniModel_LinRelGecode_IntVarLinRelGecode_IntVar ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinRel<Gecode::IntVar>* tmp;
  Data_Get_Struct(self, Gecode::MiniModel::LinRel<Gecode::IntVar>, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 3: {
// Case 0
      if( is_Gecode_MiniModel_LinExprGecode_IntVar(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_Gecode_MiniModel_LinExprGecode_IntVar(argv[2]) ) {
           tmp = new Gecode::MiniModel::LinRel<Gecode::IntVar>(ruby2Gecode_MiniModel_LinExprGecode_IntVar(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2Gecode_MiniModel_LinExprGecode_IntVar(argv[2], 3));
           ok = true;
}}}
// Case 1
      if( is_Gecode_MiniModel_LinExprGecode_IntVar(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_int(argv[2]) ) {
           tmp = new Gecode::MiniModel::LinRel<Gecode::IntVar>(ruby2Gecode_MiniModel_LinExprGecode_IntVar(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2int(argv[2], 3));
           ok = true;
}}}
// Case 2
      if( is_int(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_Gecode_MiniModel_LinExprGecode_IntVar(argv[2]) ) {
           tmp = new Gecode::MiniModel::LinRel<Gecode::IntVar>(ruby2int(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2Gecode_MiniModel_LinExprGecode_IntVar(argv[2], 3));
           ok = true;
}}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::MiniModel::LinRel<Gecode::IntVar>();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_MiniModel_LinRelGecode_IntVarMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MiniModel::LinRel<Gecode::IntVar> (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fMiniModel_Gecode_MiniModel_LinRelGecode_IntVar_post ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinRel<Gecode::IntVar>* tmp = ruby2Gecode_MiniModel_LinRelGecode_IntVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolVar(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolVar(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_bool(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2bool(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE rGecode_MiniModel_LinRelGecode_BoolVar;

bool is_Gecode_MiniModel_LinRelGecode_BoolVar(VALUE val)
{
  if ( isType(val, T_DATA) )
  {
    Gecode::MiniModel::LinRel<Gecode::BoolVar> *obj = 0;
    
    Data_Get_Struct(val, Gecode::MiniModel::LinRel<Gecode::BoolVar>, obj);
    
    if( obj == 0 ) return false;
    
    return rb_obj_is_kind_of(val, rGecode_MiniModel_LinRelGecode_BoolVar) == Qtrue;
  }
  
  return false;
}

Gecode::MiniModel::LinRel<Gecode::BoolVar>* ruby2Gecode_MiniModel_LinRelGecode_BoolVarPtr(VALUE rval, int argn) {
   if(rval == Qnil || rval == 0) return 0;

   if( ! is_Gecode_MiniModel_LinRelGecode_BoolVar(rval) )
   {
     VALUE klass = rb_funcall(rval, rb_intern("class"), 0);
     
     if( argn > 0)
       rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::LinRel<Gecode::BoolVar> given %s for argument %d", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     else
		rb_raise(rb_eArgError, "Expecting Gecode::MiniModel::LinRel<Gecode::BoolVar> given %s", RSTRING_PTR(RSTRING(rb_funcall(klass, rb_intern("to_s"), 0))), argn);
     return 0;
   }
   
   Gecode::MiniModel::LinRel<Gecode::BoolVar>* ptr;
   Data_Get_Struct(rval, Gecode::MiniModel::LinRel<Gecode::BoolVar>, ptr);

   if ( ptr ) return dynamic_cast< Gecode::MiniModel::LinRel<Gecode::BoolVar>* >(ptr);

   TGecode_MiniModel_LinRelGecode_BoolVarMap::iterator it = Gecode_MiniModel_LinRelGecode_BoolVarMap.find(rval);

   if ( it == Gecode_MiniModel_LinRelGecode_BoolVarMap.end() ) {
      rb_raise(rb_eRuntimeError, "Unable to find Gecode::MiniModel::LinRel<Gecode::BoolVar> instance for value %x (type %d)\n", rval, TYPE(rval));
      return NULL;
   }

   return dynamic_cast< Gecode::MiniModel::LinRel<Gecode::BoolVar>* >((*it).second);
}

Gecode::MiniModel::LinRel<Gecode::BoolVar>& ruby2Gecode_MiniModel_LinRelGecode_BoolVar(VALUE rval, int argn) {
  return *ruby2Gecode_MiniModel_LinRelGecode_BoolVarPtr(rval, argn);
}

VALUE cxx2ruby(Gecode::MiniModel::LinRel<Gecode::BoolVar>* instance, bool free, bool create_new_if_needed) {
  if ( instance == NULL ) return Qnil;

  TGecode_MiniModel_LinRelGecode_BoolVarMap::iterator it, eend = Gecode_MiniModel_LinRelGecode_BoolVarMap.end();

#ifdef DEBUG      
  fprintf(stderr, "rust: searching for Gecode::MiniModel::LinRel<Gecode::BoolVar> %p\n", instance);
#endif

  for(it = Gecode_MiniModel_LinRelGecode_BoolVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::LinRel<Gecode::BoolVar>*)instance ) break;

   if ( it != Gecode_MiniModel_LinRelGecode_BoolVarMap.end() )
      return (*it).first;
   else {
#ifdef DEBUG      
      fprintf(stderr, "rust: failed to find match for %p\n", instance);
#endif
      if(!create_new_if_needed) return Qnil;
   
      VALUE klass = rGecode_MiniModel_LinRelGecode_BoolVar;


      
      VALUE rval;
      if( !free )
      {
        rval = Data_Wrap_Struct(klass, 0, Gecode_MiniModel_LinRelGecode_BoolVar_free_map_entry, (void*)instance);
      }
      else
      {
        rval = Data_Wrap_Struct(klass, Gecode_MiniModel_LinRelGecode_BoolVar_mark, Gecode_MiniModel_LinRelGecode_BoolVar_free, (void*)instance);
      }
      
      Gecode_MiniModel_LinRelGecode_BoolVarMap[rval] = instance;

#ifdef DEBUG      
      fprintf(stderr, "rust: wrapping instance %p in value %x (type %d)\n", instance, rval, TYPE(rval));
#endif

      return rval;
   }
}

static VALUE Gecode_MiniModel_LinRelGecode_BoolVar_alloc(VALUE self) {
   return Data_Wrap_Struct(self, Gecode_MiniModel_LinRelGecode_BoolVar_mark, Gecode_MiniModel_LinRelGecode_BoolVar_free, 0);
}

TGecode_MiniModel_LinRelGecode_BoolVarMap Gecode_MiniModel_LinRelGecode_BoolVarMap;

static void Gecode_MiniModel_LinRelGecode_BoolVar_free(void *p) {
	Gecode_MiniModel_LinRelGecode_BoolVar_free_map_entry(p);
  delete (Gecode::MiniModel::LinRel<Gecode::BoolVar>*)p;
}

static void Gecode_MiniModel_LinRelGecode_BoolVar_free_map_entry(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Freeing %p (Gecode_MiniModel_LinRelGecode_BoolVar) \n", p);
#endif

  TGecode_MiniModel_LinRelGecode_BoolVarMap::iterator it, eend = Gecode_MiniModel_LinRelGecode_BoolVarMap.end();
  for(it = Gecode_MiniModel_LinRelGecode_BoolVarMap.begin(); it != eend; it++)
     if ( (*it).second == (Gecode::MiniModel::LinRel<Gecode::BoolVar>*)p ) {
        Gecode_MiniModel_LinRelGecode_BoolVarMap.erase(it); break;
     }
}

static void Gecode_MiniModel_LinRelGecode_BoolVar_mark(void *p) {
#ifdef DEBUG      
  fprintf(stderr, "rust: Marking %p (Gecode_MiniModel_LinRelGecode_BoolVar) \n", p);
#endif
}

VALUE fGecode_MiniModel_LinRelGecode_BoolVarLinRelGecode_BoolVar ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinRel<Gecode::BoolVar>* tmp;
  Data_Get_Struct(self, Gecode::MiniModel::LinRel<Gecode::BoolVar>, tmp);

  /* The exception is thrown already by ruby2* if not found */

    bool ok = false;
  
  switch(argc) {
     case 3: {
// Case 0
      if( is_Gecode_MiniModel_LinExprGecode_BoolVar(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_Gecode_MiniModel_LinExprGecode_BoolVar(argv[2]) ) {
           tmp = new Gecode::MiniModel::LinRel<Gecode::BoolVar>(ruby2Gecode_MiniModel_LinExprGecode_BoolVar(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2Gecode_MiniModel_LinExprGecode_BoolVar(argv[2], 3));
           ok = true;
}}}
// Case 1
      if( is_Gecode_MiniModel_LinExprGecode_BoolVar(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_int(argv[2]) ) {
           tmp = new Gecode::MiniModel::LinRel<Gecode::BoolVar>(ruby2Gecode_MiniModel_LinExprGecode_BoolVar(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2int(argv[2], 3));
           ok = true;
}}}
// Case 2
      if( is_int(argv[0]) ) {
      if( is_Gecode_IntRelType(argv[1]) ) {
      if( is_Gecode_MiniModel_LinExprGecode_BoolVar(argv[2]) ) {
           tmp = new Gecode::MiniModel::LinRel<Gecode::BoolVar>(ruby2int(argv[0], 1),ruby2Gecode_IntRelType(argv[1], 2),ruby2Gecode_MiniModel_LinExprGecode_BoolVar(argv[2], 3));
           ok = true;
}}}
     } break;
     case 0: {
// Case 0
           tmp = new Gecode::MiniModel::LinRel<Gecode::BoolVar>();
           ok = true;

     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  };

  DATA_PTR(self) = tmp;
  Gecode_MiniModel_LinRelGecode_BoolVarMap[self] = tmp;

#ifdef DEBUG
  fprintf(stderr, "rust: creating new instance of Gecode::MiniModel::LinRel<Gecode::BoolVar> (%p) with value %x\n", tmp, self);
#endif

  return self;
}


VALUE fMiniModel_Gecode_MiniModel_LinRelGecode_BoolVar_post ( int argc, VALUE *argv, VALUE self ) {
  Gecode::MiniModel::LinRel<Gecode::BoolVar>* tmp = ruby2Gecode_MiniModel_LinRelGecode_BoolVarPtr(self);
  if ( ! tmp ) return Qnil;

  
    bool ok = false;
  
  switch(argc) {
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolVar(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolVar(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_bool(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           tmp->post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2bool(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
}


VALUE fGecodeRawabs ( VALUE self , VALUE home, VALUE x0, VALUE x1, VALUE icl, VALUE pk ) {
  Gecode::abs(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_IntVar(x0, 2),ruby2Gecode_IntVar(x1, 3),ruby2Gecode_IntConLevel(icl, 4),ruby2Gecode_PropKind(pk, 5)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawmax ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::max(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 1)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 3: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
           Gecode::max(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_IntVar(argv[2], 3)); return Qnil;
           ok = true;
}}}
     } break;
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::max(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawmin ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::min(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 1)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 3: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
           Gecode::min(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_IntVar(argv[2], 3)); return Qnil;
           ok = true;
}}}
     } break;
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::min(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawmult ( VALUE self , VALUE home, VALUE x0, VALUE x1, VALUE x2, VALUE icl, VALUE pk ) {
  Gecode::mult(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_IntVar(x0, 2),ruby2Gecode_IntVar(x1, 3),ruby2Gecode_IntVar(x2, 4),ruby2Gecode_IntConLevel(icl, 5),ruby2Gecode_PropKind(pk, 6)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawsqr ( VALUE self , VALUE home, VALUE x0, VALUE x1, VALUE icl, VALUE pk ) {
  Gecode::sqr(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_IntVar(x0, 2),ruby2Gecode_IntVar(x1, 3),ruby2Gecode_IntConLevel(icl, 4),ruby2Gecode_PropKind(pk, 5)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawsqrt ( VALUE self , VALUE home, VALUE x0, VALUE x1, VALUE icl, VALUE pk ) {
  Gecode::sqrt(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_IntVar(x0, 2),ruby2Gecode_IntVar(x1, 3),ruby2Gecode_IntConLevel(icl, 4),ruby2Gecode_PropKind(pk, 5)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawbranch ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_IntVarBranch(argv[2]) ) {
      if( is_Gecode_IntValBranch(argv[3]) ) {
           Gecode::branch(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVarBranch(argv[2], 3),ruby2Gecode_IntValBranch(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MSetVarArray(argv[1]) ) {
      if( is_Gecode_SetVarBranch(argv[2]) ) {
      if( is_Gecode_SetValBranch(argv[3]) ) {
           Gecode::branch(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MSetVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_SetVarBranch(argv[2], 3),ruby2Gecode_SetValBranch(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVarBranch(argv[2]) ) {
      if( is_Gecode_IntValBranch(argv[3]) ) {
           Gecode::branch(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVarBranch(argv[2], 3),ruby2Gecode_IntValBranch(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawassign ( VALUE self , VALUE home, VALUE iva, VALUE vals ) {
  Gecode::assign(ruby2Gecode_MSpacePtr(home, 1),*ruby2Gecode_MIntVarArrayPtr(iva, 1)->ptr(),ruby2Gecode_IntAssign(vals, 3)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawchannel ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_BoolVar(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::channel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_BoolVar(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::channel(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::channel(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;
     case 3: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_MSetVarArray(argv[2]) ) {
           Gecode::channel(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),*ruby2Gecode_MSetVarArrayPtr(argv[2], 3)->ptr()); return Qnil;
           ok = true;
}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_SetVar(argv[2]) ) {
           Gecode::channel(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_SetVar(argv[2], 3)); return Qnil;
           ok = true;
}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawcount ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 7: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntRelType(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::count(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntRelType(argv[3], 4),ruby2int(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntRelType(argv[3]) ) {
      if( is_Gecode_IntVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::count(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2int(argv[2], 3),ruby2Gecode_IntRelType(argv[3], 4),ruby2Gecode_IntVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntRelType(argv[3]) ) {
      if( is_Gecode_IntVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::count(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntRelType(argv[3], 4),ruby2Gecode_IntVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntRelType(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::count(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2int(argv[2], 3),ruby2Gecode_IntRelType(argv[3], 4),ruby2int(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawdistinct ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntArgs(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::distinct(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntArgs(argv[1], 2),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           Gecode::distinct(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawdom ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),*reinterpret_cast<Gecode::IntVarArgs *>(ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_Gecode_BoolVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2Gecode_BoolVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_Gecode_BoolVar(argv[5]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5),ruby2Gecode_BoolVar(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntSet(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntSet(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),*reinterpret_cast<Gecode::IntVarArgs *>(ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()),ruby2Gecode_IntSet(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_int(argv[4]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2int(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 4
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 7: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2int(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
           Gecode::dom(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawelement ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::element(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntArgs(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::element(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntArgs(argv[1], 2),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MSetVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
           Gecode::element(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MSetVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawlinear ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 7: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntArgs(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_IntRelType(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntArgs(argv[1], 2),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_IntRelType(argv[3], 4),ruby2int(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntArgs(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_IntRelType(argv[3]) ) {
      if( is_Gecode_IntVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntArgs(argv[1], 2),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_IntRelType(argv[3], 4),ruby2Gecode_IntVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
     } break;
     case 8: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntArgs(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_IntRelType(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_Gecode_BoolVar(argv[5]) ) {
      if( is_Gecode_IntConLevel(argv[6]) ) {
      if( is_Gecode_PropKind(argv[7]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntArgs(argv[1], 2),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_IntRelType(argv[3], 4),ruby2int(argv[4], 5),ruby2Gecode_BoolVar(argv[5], 6),ruby2Gecode_IntConLevel(argv[6], 7),ruby2Gecode_PropKind(argv[7], 8)); return Qnil;
           ok = true;
}}}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntArgs(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_IntRelType(argv[3]) ) {
      if( is_Gecode_IntVar(argv[4]) ) {
      if( is_Gecode_BoolVar(argv[5]) ) {
      if( is_Gecode_IntConLevel(argv[6]) ) {
      if( is_Gecode_PropKind(argv[7]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntArgs(argv[1], 2),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_IntRelType(argv[3], 4),ruby2Gecode_IntVar(argv[4], 5),ruby2Gecode_BoolVar(argv[5], 6),ruby2Gecode_IntConLevel(argv[6], 7),ruby2Gecode_PropKind(argv[7], 8)); return Qnil;
           ok = true;
}}}}}}}}
     } break;
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::linear(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawextensional ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_TupleSet(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::extensional(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_TupleSet(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_REG(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::extensional(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_REG(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_REG(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::extensional(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_REG(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_TupleSet(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::extensional(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_TupleSet(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawbab ( VALUE self , VALUE home, VALUE o ) {
  return cxx2ruby( static_cast<Gecode::MSpace*>(Gecode::bab(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_Search_Options(o, 2))) );

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawrel ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_MIntVarArray(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),*ruby2Gecode_MIntVarArrayPtr(argv[3], 4)->ptr(),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolVar(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolVar(argv[1], 2),ruby2Gecode_IntRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolVar(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_BoolVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolVar(argv[1], 2),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_BoolVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 4
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolOpType(argv[1]) ) {
      if( is_Gecode_MBoolVarArray(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolOpType(argv[1], 2),*ruby2Gecode_MBoolVarArrayPtr(argv[2], 2)->ptr(),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 5
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolOpType(argv[1]) ) {
      if( is_Gecode_MBoolVarArray(argv[2]) ) {
      if( is_Gecode_BoolVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolOpType(argv[1], 2),*ruby2Gecode_MBoolVarArrayPtr(argv[2], 2)->ptr(),ruby2Gecode_BoolVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 6
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MBoolVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_MBoolVarArray(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),*ruby2Gecode_MBoolVarArrayPtr(argv[3], 4)->ptr(),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 7
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_Gecode_SetOpType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
      if( is_Gecode_SetRelType(argv[4]) ) {
      if( is_Gecode_SetVar(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2Gecode_SetOpType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4),ruby2Gecode_SetRelType(argv[4], 5),ruby2Gecode_SetVar(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 8
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetOpType(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_Gecode_SetRelType(argv[4]) ) {
      if( is_Gecode_SetVar(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetOpType(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2Gecode_SetRelType(argv[4], 5),ruby2Gecode_SetVar(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 9
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetOpType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
      if( is_Gecode_SetRelType(argv[4]) ) {
      if( is_Gecode_IntSet(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetOpType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4),ruby2Gecode_SetRelType(argv[4], 5),ruby2Gecode_IntSet(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 10
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntSet(argv[1]) ) {
      if( is_Gecode_SetOpType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
      if( is_Gecode_SetRelType(argv[4]) ) {
      if( is_Gecode_IntSet(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntSet(argv[1], 2),ruby2Gecode_SetOpType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4),ruby2Gecode_SetRelType(argv[4], 5),ruby2Gecode_IntSet(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 11
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetOpType(argv[2]) ) {
      if( is_Gecode_IntSet(argv[3]) ) {
      if( is_Gecode_SetRelType(argv[4]) ) {
      if( is_Gecode_IntSet(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetOpType(argv[2], 3),ruby2Gecode_IntSet(argv[3], 4),ruby2Gecode_SetRelType(argv[4], 5),ruby2Gecode_IntSet(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 12
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetOpType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
      if( is_Gecode_SetRelType(argv[4]) ) {
      if( is_Gecode_SetVar(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetOpType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4),ruby2Gecode_SetRelType(argv[4], 5),ruby2Gecode_SetVar(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 13
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;
     case 7: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntRelType(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolVar(argv[1]) ) {
      if( is_Gecode_BoolOpType(argv[2]) ) {
      if( is_Gecode_BoolVar(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolVar(argv[1], 2),ruby2Gecode_BoolOpType(argv[2], 3),ruby2Gecode_BoolVar(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolVar(argv[1]) ) {
      if( is_Gecode_BoolOpType(argv[2]) ) {
      if( is_Gecode_BoolVar(argv[3]) ) {
      if( is_int(argv[4]) ) {
      if( is_Gecode_IntConLevel(argv[5]) ) {
      if( is_Gecode_PropKind(argv[6]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolVar(argv[1], 2),ruby2Gecode_BoolOpType(argv[2], 3),ruby2Gecode_BoolVar(argv[3], 4),ruby2int(argv[4], 5),ruby2Gecode_IntConLevel(argv[5], 6),ruby2Gecode_PropKind(argv[6], 7)); return Qnil;
           ok = true;
}}}}}}}
     } break;
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
      if( is_Gecode_BoolVar(argv[4]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4),ruby2Gecode_BoolVar(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntRelType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetOpType(argv[1]) ) {
      if( is_Gecode_MSetVarArray(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetOpType(argv[1], 2),*ruby2Gecode_MSetVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_SetVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetOpType(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetOpType(argv[1], 2),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_SetVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 4
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 5
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 6
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_SetRelType(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
           Gecode::rel(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_SetRelType(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawsorted ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_MIntVarArray(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::sorted(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),*ruby2Gecode_MIntVarArrayPtr(argv[3], 4)->ptr(),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_MIntVarArray(argv[2]) ) {
      if( is_Gecode_IntConLevel(argv[3]) ) {
      if( is_Gecode_PropKind(argv[4]) ) {
           Gecode::sorted(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr(),ruby2Gecode_IntConLevel(argv[3], 4),ruby2Gecode_PropKind(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawpost ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_BoolVar(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           return cxx2ruby( new Gecode::BoolVar(Gecode::post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_BoolVar(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4))), true );
           ok = true;
}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MiniModel_BoolRel(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           Gecode::post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_MiniModel_BoolRel(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           return cxx2ruby( new Gecode::IntVar(Gecode::post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_IntVar(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4))), true );
           ok = true;
}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_int(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           return cxx2ruby( new Gecode::IntVar(Gecode::post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2int(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4))), true );
           ok = true;
}}}}
// Case 4
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MiniModel_LinExprGecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           return cxx2ruby( new Gecode::IntVar(Gecode::post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_MiniModel_LinExprGecode_IntVar(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4))), true );
           ok = true;
}}}}
// Case 5
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MiniModel_LinRelGecode_IntVar(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           Gecode::post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_MiniModel_LinRelGecode_IntVar(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 6
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_bool(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           Gecode::post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2bool(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4)); return Qnil;
           ok = true;
}}}}
// Case 7
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MiniModel_BoolExpr(argv[1]) ) {
      if( is_Gecode_IntConLevel(argv[2]) ) {
      if( is_Gecode_PropKind(argv[3]) ) {
           return cxx2ruby( new Gecode::BoolVar(Gecode::post(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_MiniModel_BoolExpr(argv[1], 2),ruby2Gecode_IntConLevel(argv[2], 3),ruby2Gecode_PropKind(argv[3], 4))), true );
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawatmost ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::atmost(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::atmost(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2int(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::atmost(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::atmost(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawatleast ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::atleast(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::atleast(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2int(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::atleast(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::atleast(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawexactly ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::exactly(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 1
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::exactly(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2int(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 2
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
      if( is_Gecode_IntVar(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::exactly(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntVar(argv[2], 3),ruby2Gecode_IntVar(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
// Case 3
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::exactly(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2int(argv[2], 3),ruby2int(argv[3], 4),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawlex ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 6: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_MIntVarArray(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
      if( is_Gecode_PropKind(argv[5]) ) {
           Gecode::lex(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),*ruby2Gecode_MIntVarArrayPtr(argv[3], 4)->ptr(),ruby2Gecode_IntConLevel(argv[4], 5),ruby2Gecode_PropKind(argv[5], 6)); return Qnil;
           ok = true;
}}}}}}
     } break;
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MIntVarArray(argv[1]) ) {
      if( is_Gecode_IntRelType(argv[2]) ) {
      if( is_Gecode_MIntVarArray(argv[3]) ) {
      if( is_Gecode_IntConLevel(argv[4]) ) {
           Gecode::lex(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_IntRelType(argv[2], 3),*ruby2Gecode_MIntVarArrayPtr(argv[3], 4)->ptr(),ruby2Gecode_IntConLevel(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawcardinality ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 3: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_Gecode_IntVar(argv[2]) ) {
           Gecode::cardinality(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2Gecode_IntVar(argv[2], 3)); return Qnil;
           ok = true;
}}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_SetVar(argv[1]) ) {
      if( is_int(argv[2]) ) {
      if( is_int(argv[3]) ) {
           Gecode::cardinality(ruby2Gecode_MSpacePtr(argv[0], 1),ruby2Gecode_SetVar(argv[1], 2),ruby2int(argv[2], 3),ruby2int(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawconvex ( VALUE self , VALUE home, VALUE s ) {
  Gecode::convex(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_SetVar(s, 2)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawconvexHull ( VALUE self , VALUE home, VALUE x, VALUE y ) {
  Gecode::convexHull(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_SetVar(x, 2),ruby2Gecode_SetVar(y, 3)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawatmostOne ( VALUE self , VALUE home, VALUE x, VALUE c ) {
  Gecode::atmostOne(ruby2Gecode_MSpacePtr(home, 1),*ruby2Gecode_MSetVarArrayPtr(x, 2)->ptr(),ruby2int(c, 3)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawmatch ( VALUE self , VALUE home, VALUE s, VALUE x ) {
  Gecode::match(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_SetVar(s, 2),*ruby2Gecode_MIntVarArrayPtr(x, 3)->ptr()); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawweights ( VALUE self , VALUE home, VALUE elements, VALUE weights, VALUE x, VALUE y ) {
  Gecode::weights(ruby2Gecode_MSpacePtr(home, 1),ruby2Gecode_IntArgs(elements, 2),ruby2Gecode_IntArgs(weights, 3),ruby2Gecode_SetVar(x, 4),ruby2Gecode_IntVar(y, 5)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawelementsUnion ( VALUE self , VALUE home, VALUE x, VALUE y, VALUE z ) {
  Gecode::elementsUnion(ruby2Gecode_MSpacePtr(home, 1),*ruby2Gecode_MSetVarArrayPtr(x, 2)->ptr(),ruby2Gecode_SetVar(y, 3),ruby2Gecode_SetVar(z, 4)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawelementsInter ( int argc, VALUE *argv, VALUE self ) {
    bool ok = false;
  
  switch(argc) {
     case 5: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MSetVarArray(argv[1]) ) {
      if( is_Gecode_SetVar(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
      if( is_Gecode_IntSet(argv[4]) ) {
           Gecode::elementsInter(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MSetVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_SetVar(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4),ruby2Gecode_IntSet(argv[4], 5)); return Qnil;
           ok = true;
}}}}}
     } break;
     case 4: {
// Case 0
      if( is_Gecode_MSpace(argv[0]) ) {
      if( is_Gecode_MSetVarArray(argv[1]) ) {
      if( is_Gecode_SetVar(argv[2]) ) {
      if( is_Gecode_SetVar(argv[3]) ) {
           Gecode::elementsInter(ruby2Gecode_MSpacePtr(argv[0], 1),*ruby2Gecode_MSetVarArrayPtr(argv[1], 2)->ptr(),ruby2Gecode_SetVar(argv[2], 3),ruby2Gecode_SetVar(argv[3], 4)); return Qnil;
           ok = true;
}}}}
     } break;

  default: ok = false; break;
  }
  
  if ( !ok )
  {
	rb_raise(rb_eArgError, "Mandatory parameters missing");
	return Qnil;
  }
  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawelementsDisjoint ( VALUE self , VALUE home, VALUE x, VALUE y ) {
  Gecode::elementsDisjoint(ruby2Gecode_MSpacePtr(home, 1),*ruby2Gecode_MSetVarArrayPtr(x, 2)->ptr(),ruby2Gecode_SetVar(y, 3)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawsequence ( VALUE self , VALUE home, VALUE x ) {
  Gecode::sequence(ruby2Gecode_MSpacePtr(home, 1),*ruby2Gecode_MSetVarArrayPtr(x, 2)->ptr()); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


VALUE fGecodeRawsequentialUnion ( VALUE self , VALUE home, VALUE y, VALUE x ) {
  Gecode::sequentialUnion(ruby2Gecode_MSpacePtr(home, 1),*ruby2Gecode_MSetVarArrayPtr(y, 2)->ptr(),ruby2Gecode_SetVar(x, 3)); return Qnil;

  
  rb_raise(rb_eArgError, "Mandatory parameters missing");   return Qnil; 
}


}

using namespace Rust_gecode;

extern "C" {

#ifdef HAVE_VISIBILITY
void Init_gecode() __attribute__((visibility("default")));
#endif

void Init_gecode() {
rGecodeRaw = rb_define_module("GecodeRaw");
rb_define_const(rGecodeRaw, "INT_VAR_NONE", cxx2ruby(Gecode::INT_VAR_NONE));
rb_define_const(rGecodeRaw, "INT_VAR_MIN_MIN", cxx2ruby(Gecode::INT_VAR_MIN_MIN));
rb_define_const(rGecodeRaw, "INT_VAR_MIN_MAX", cxx2ruby(Gecode::INT_VAR_MIN_MAX));
rb_define_const(rGecodeRaw, "INT_VAR_MAX_MIN", cxx2ruby(Gecode::INT_VAR_MAX_MIN));
rb_define_const(rGecodeRaw, "INT_VAR_MAX_MAX", cxx2ruby(Gecode::INT_VAR_MAX_MAX));
rb_define_const(rGecodeRaw, "INT_VAR_SIZE_MIN", cxx2ruby(Gecode::INT_VAR_SIZE_MIN));
rb_define_const(rGecodeRaw, "INT_VAR_SIZE_MAX", cxx2ruby(Gecode::INT_VAR_SIZE_MAX));
rb_define_const(rGecodeRaw, "INT_VAR_DEGREE_MAX", cxx2ruby(Gecode::INT_VAR_DEGREE_MAX));
rb_define_const(rGecodeRaw, "INT_VAR_DEGREE_MIN", cxx2ruby(Gecode::INT_VAR_DEGREE_MIN));
rb_define_const(rGecodeRaw, "INT_VAR_REGRET_MIN_MIN", cxx2ruby(Gecode::INT_VAR_REGRET_MIN_MIN));
rb_define_const(rGecodeRaw, "INT_VAR_REGRET_MIN_MAX", cxx2ruby(Gecode::INT_VAR_REGRET_MIN_MAX));
rb_define_const(rGecodeRaw, "INT_VAR_REGRET_MAX_MIN", cxx2ruby(Gecode::INT_VAR_REGRET_MAX_MIN));
rb_define_const(rGecodeRaw, "INT_VAR_REGRET_MAX_MAX", cxx2ruby(Gecode::INT_VAR_REGRET_MAX_MAX));
rb_define_const(rGecodeRaw, "INT_VAL_MIN", cxx2ruby(Gecode::INT_VAL_MIN));
rb_define_const(rGecodeRaw, "INT_VAL_MED", cxx2ruby(Gecode::INT_VAL_MED));
rb_define_const(rGecodeRaw, "INT_VAL_MAX", cxx2ruby(Gecode::INT_VAL_MAX));
rb_define_const(rGecodeRaw, "INT_VAL_SPLIT_MIN", cxx2ruby(Gecode::INT_VAL_SPLIT_MIN));
rb_define_const(rGecodeRaw, "INT_VAL_SPLIT_MAX", cxx2ruby(Gecode::INT_VAL_SPLIT_MAX));
rb_define_const(rGecodeRaw, "SET_VAR_NONE", cxx2ruby(Gecode::SET_VAR_NONE));
rb_define_const(rGecodeRaw, "SET_VAR_MIN_CARD", cxx2ruby(Gecode::SET_VAR_MIN_CARD));
rb_define_const(rGecodeRaw, "SET_VAR_MAX_CARD", cxx2ruby(Gecode::SET_VAR_MAX_CARD));
rb_define_const(rGecodeRaw, "SET_VAR_MIN_UNKNOWN_ELEM", cxx2ruby(Gecode::SET_VAR_MIN_UNKNOWN_ELEM));
rb_define_const(rGecodeRaw, "SET_VAR_MAX_UNKNOWN_ELEM", cxx2ruby(Gecode::SET_VAR_MAX_UNKNOWN_ELEM));
rb_define_const(rGecodeRaw, "SET_VAL_MIN", cxx2ruby(Gecode::SET_VAL_MIN));
rb_define_const(rGecodeRaw, "SET_VAL_MAX", cxx2ruby(Gecode::SET_VAL_MAX));
rb_define_const(rGecodeRaw, "IRT_EQ", cxx2ruby(Gecode::IRT_EQ));
rb_define_const(rGecodeRaw, "IRT_NQ", cxx2ruby(Gecode::IRT_NQ));
rb_define_const(rGecodeRaw, "IRT_LQ", cxx2ruby(Gecode::IRT_LQ));
rb_define_const(rGecodeRaw, "IRT_LE", cxx2ruby(Gecode::IRT_LE));
rb_define_const(rGecodeRaw, "IRT_GQ", cxx2ruby(Gecode::IRT_GQ));
rb_define_const(rGecodeRaw, "IRT_GR", cxx2ruby(Gecode::IRT_GR));
rb_define_const(rGecodeRaw, "BOT_AND", cxx2ruby(Gecode::BOT_AND));
rb_define_const(rGecodeRaw, "BOT_OR", cxx2ruby(Gecode::BOT_OR));
rb_define_const(rGecodeRaw, "BOT_IMP", cxx2ruby(Gecode::BOT_IMP));
rb_define_const(rGecodeRaw, "BOT_EQV", cxx2ruby(Gecode::BOT_EQV));
rb_define_const(rGecodeRaw, "BOT_XOR", cxx2ruby(Gecode::BOT_XOR));
rb_define_const(rGecodeRaw, "SRT_EQ", cxx2ruby(Gecode::SRT_EQ));
rb_define_const(rGecodeRaw, "SRT_NQ", cxx2ruby(Gecode::SRT_NQ));
rb_define_const(rGecodeRaw, "SRT_SUB", cxx2ruby(Gecode::SRT_SUB));
rb_define_const(rGecodeRaw, "SRT_SUP", cxx2ruby(Gecode::SRT_SUP));
rb_define_const(rGecodeRaw, "SRT_DISJ", cxx2ruby(Gecode::SRT_DISJ));
rb_define_const(rGecodeRaw, "SRT_CMPL", cxx2ruby(Gecode::SRT_CMPL));
rb_define_const(rGecodeRaw, "SOT_UNION", cxx2ruby(Gecode::SOT_UNION));
rb_define_const(rGecodeRaw, "SOT_DUNION", cxx2ruby(Gecode::SOT_DUNION));
rb_define_const(rGecodeRaw, "SOT_INTER", cxx2ruby(Gecode::SOT_INTER));
rb_define_const(rGecodeRaw, "SOT_MINUS", cxx2ruby(Gecode::SOT_MINUS));
rb_define_const(rGecodeRaw, "ICL_VAL", cxx2ruby(Gecode::ICL_VAL));
rb_define_const(rGecodeRaw, "ICL_BND", cxx2ruby(Gecode::ICL_BND));
rb_define_const(rGecodeRaw, "ICL_DOM", cxx2ruby(Gecode::ICL_DOM));
rb_define_const(rGecodeRaw, "ICL_DEF", cxx2ruby(Gecode::ICL_DEF));
rb_define_const(rGecodeRaw, "PK_DEF", cxx2ruby(Gecode::PK_DEF));
rb_define_const(rGecodeRaw, "PK_SPEED", cxx2ruby(Gecode::PK_SPEED));
rb_define_const(rGecodeRaw, "PK_MEMORY", cxx2ruby(Gecode::PK_MEMORY));
rb_define_const(rGecodeRaw, "SS_FAILED", cxx2ruby(Gecode::SS_FAILED));
rb_define_const(rGecodeRaw, "SS_SOLVED", cxx2ruby(Gecode::SS_SOLVED));
rb_define_const(rGecodeRaw, "SS_BRANCH", cxx2ruby(Gecode::SS_BRANCH));
rb_define_const(rGecodeRaw, "INT_ASSIGN_MIN", cxx2ruby(Gecode::INT_ASSIGN_MIN));
rb_define_const(rGecodeRaw, "INT_ASSIGN_MED", cxx2ruby(Gecode::INT_ASSIGN_MED));
rb_define_const(rGecodeRaw, "INT_ASSIGN_MAX", cxx2ruby(Gecode::INT_ASSIGN_MAX));

  rGecode_MIntVarArray = rb_define_class_under(rGecodeRaw,
    "IntVarArray", rb_cObject);
  rb_define_alloc_func(rGecode_MIntVarArray, Gecode_MIntVarArray_alloc);

  rb_define_module_function(rGecode_MIntVarArray, "initialize",
    RUBY_METHOD_FUNC(fGecode_MIntVarArrayMIntVarArray), -1);

  


  rb_define_method(rGecode_MIntVarArray, "at",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MIntVarArray_at), 1);

  


  rb_define_method(rGecode_MIntVarArray, "[]",
    RUBY_METHOD_FUNC(fGecode_Gecode_MIntVarArray_atop), 1);

  


  rb_define_method(rGecode_MIntVarArray, "[]=",
    RUBY_METHOD_FUNC(fGecode_Gecode_MIntVarArray_ateqop), 2);

  


  rb_define_method(rGecode_MIntVarArray, "enlargeArray",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MIntVarArray_enlargeArray), 2);

  
  rb_define_alias(rGecode_MIntVarArray, "enlarge_array", "enlargeArray");



  rb_define_method(rGecode_MIntVarArray, "size",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MIntVarArray_size), 0);

  


  rb_define_method(rGecode_MIntVarArray, "debug",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MIntVarArray_debug), 0);

  


  rGecode_MBoolVarArray = rb_define_class_under(rGecodeRaw,
    "BoolVarArray", rb_cObject);
  rb_define_alloc_func(rGecode_MBoolVarArray, Gecode_MBoolVarArray_alloc);

  rb_define_module_function(rGecode_MBoolVarArray, "initialize",
    RUBY_METHOD_FUNC(fGecode_MBoolVarArrayMBoolVarArray), -1);

  


  rb_define_method(rGecode_MBoolVarArray, "at",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MBoolVarArray_at), 1);

  


  rb_define_method(rGecode_MBoolVarArray, "[]",
    RUBY_METHOD_FUNC(fGecode_Gecode_MBoolVarArray_atop), 1);

  


  rb_define_method(rGecode_MBoolVarArray, "[]=",
    RUBY_METHOD_FUNC(fGecode_Gecode_MBoolVarArray_ateqop), 2);

  


  rb_define_method(rGecode_MBoolVarArray, "enlargeArray",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MBoolVarArray_enlargeArray), 2);

  
  rb_define_alias(rGecode_MBoolVarArray, "enlarge_array", "enlargeArray");



  rb_define_method(rGecode_MBoolVarArray, "size",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MBoolVarArray_size), 0);

  


  rb_define_method(rGecode_MBoolVarArray, "debug",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MBoolVarArray_debug), 0);

  


  rGecode_MSetVarArray = rb_define_class_under(rGecodeRaw,
    "SetVarArray", rb_cObject);
  rb_define_alloc_func(rGecode_MSetVarArray, Gecode_MSetVarArray_alloc);

  rb_define_module_function(rGecode_MSetVarArray, "initialize",
    RUBY_METHOD_FUNC(fGecode_MSetVarArrayMSetVarArray), -1);

  


  rb_define_method(rGecode_MSetVarArray, "at",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSetVarArray_at), 1);

  


  rb_define_method(rGecode_MSetVarArray, "[]",
    RUBY_METHOD_FUNC(fGecode_Gecode_MSetVarArray_atop), 1);

  


  rb_define_method(rGecode_MSetVarArray, "[]=",
    RUBY_METHOD_FUNC(fGecode_Gecode_MSetVarArray_ateqop), 2);

  


  rb_define_method(rGecode_MSetVarArray, "enlargeArray",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSetVarArray_enlargeArray), 2);

  
  rb_define_alias(rGecode_MSetVarArray, "enlarge_array", "enlargeArray");



  rb_define_method(rGecode_MSetVarArray, "size",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSetVarArray_size), 0);

  


  rb_define_method(rGecode_MSetVarArray, "debug",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSetVarArray_debug), 0);

  


  rGecode_TupleSet = rb_define_class_under(rGecodeRaw,
    "TupleSet", rb_cObject);
  rb_define_alloc_func(rGecode_TupleSet, Gecode_TupleSet_alloc);

  rb_define_module_function(rGecode_TupleSet, "initialize",
    RUBY_METHOD_FUNC(fGecode_TupleSetTupleSet), 0);

  


  rb_define_method(rGecode_TupleSet, "add",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_TupleSet_add), 1);

  


  rb_define_method(rGecode_TupleSet, "finalize",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_TupleSet_finalize), 0);

  


  rb_define_method(rGecode_TupleSet, "finalized",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_TupleSet_finalized), 0);

  


  rb_define_method(rGecode_TupleSet, "tuples",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_TupleSet_tuples), 0);

  


  rGecode_MSpace = rb_define_class_under(rGecodeRaw,
    "Space", rb_cObject);
  rb_define_alloc_func(rGecode_MSpace, Gecode_MSpace_alloc);

  rb_define_module_function(rGecode_MSpace, "initialize",
    RUBY_METHOD_FUNC(fGecode_MSpaceMSpace), 0);

  


  rb_define_method(rGecode_MSpace, "constrain",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_constrain), 1);

  


  rb_define_method(rGecode_MSpace, "new_int_var",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_new_int_var), -1);

  


  rb_define_method(rGecode_MSpace, "new_bool_var",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_new_bool_var), 0);

  


  rb_define_method(rGecode_MSpace, "new_set_var",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_new_set_var), 4);

  


  rb_define_method(rGecode_MSpace, "int_var",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_int_var), 1);

  


  rb_define_method(rGecode_MSpace, "bool_var",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_bool_var), 1);

  


  rb_define_method(rGecode_MSpace, "set_var",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_set_var), 1);

  


  rb_define_method(rGecode_MSpace, "clone",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_clone), 1);

  


  rb_define_method(rGecode_MSpace, "status",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_status), 0);

  


  rb_define_method(rGecode_MSpace, "propagators",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_propagators), 0);

  


  rb_define_method(rGecode_MSpace, "branchings",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_branchings), 0);

  


  rb_define_method(rGecode_MSpace, "failed",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MSpace_failed), 0);

  

rIntLimits = rb_define_module_under(rGecodeRaw, "IntLimits");
rb_define_const(rIntLimits, "MAX", cxx2ruby(Gecode::Int::Limits::max));

rb_define_const(rIntLimits, "MIN", cxx2ruby(Gecode::Int::Limits::min));

rSetLimits = rb_define_module_under(rGecodeRaw, "SetLimits");
rb_define_const(rSetLimits, "MAX", cxx2ruby(Gecode::Set::Limits::max));

rb_define_const(rSetLimits, "MIN", cxx2ruby(Gecode::Set::Limits::min));

rb_define_const(rSetLimits, "CARD", cxx2ruby(Gecode::Set::Limits::card));


  rGecode_IntSet = rb_define_class_under(rGecodeRaw,
    "IntSet", rb_cObject);
  rb_define_alloc_func(rGecode_IntSet, Gecode_IntSet_alloc);

  rb_define_module_function(rGecode_IntSet, "initialize",
    RUBY_METHOD_FUNC(fGecode_IntSetIntSet), -1);

  


  rb_define_method(rGecode_IntSet, "size",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntSet_size), 0);

  


  rb_define_method(rGecode_IntSet, "width",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntSet_width), 1);

  


  rb_define_method(rGecode_IntSet, "max",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntSet_max), 1);

  


  rb_define_method(rGecode_IntSet, "min",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntSet_min), 1);

  

rb_define_const(rGecode_IntSet, "Empty", cxx2ruby((Gecode::IntSet *)&Gecode::IntSet::empty));


  rGecode_IntVar = rb_define_class_under(rGecodeRaw,
    "IntVar", rb_cObject);
  rb_define_alloc_func(rGecode_IntVar, Gecode_IntVar_alloc);

  rb_define_module_function(rGecode_IntVar, "initialize",
    RUBY_METHOD_FUNC(fGecode_IntVarIntVar), -1);

  


  rb_define_method(rGecode_IntVar, "max",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_max), 0);

  


  rb_define_method(rGecode_IntVar, "min",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_min), 0);

  


  rb_define_method(rGecode_IntVar, "med",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_med), 0);

  


  rb_define_method(rGecode_IntVar, "val",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_val), 0);

  


  rb_define_method(rGecode_IntVar, "size",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_size), 0);

  


  rb_define_method(rGecode_IntVar, "width",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_width), 0);

  


  rb_define_method(rGecode_IntVar, "degree",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_degree), 0);

  


  rb_define_method(rGecode_IntVar, "range",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_range), 0);

  


  rb_define_method(rGecode_IntVar, "assigned",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_assigned), 0);

  


  rb_define_method(rGecode_IntVar, "in",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_in), 1);

  


  rb_define_method(rGecode_IntVar, "update",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_IntVar_update), 3);

  


  rb_define_method(rGecode_IntVar, "+",
    RUBY_METHOD_FUNC(fGecode_Gecode_IntVar_plusop), 1);

  


  rb_define_method(rGecode_IntVar, "-",
    RUBY_METHOD_FUNC(fGecode_Gecode_IntVar_minusop), 1);

  


  rb_define_method(rGecode_IntVar, "*",
    RUBY_METHOD_FUNC(fGecode_Gecode_IntVar_multop), 1);

  


  rb_define_method(rGecode_IntVar, "different",
    RUBY_METHOD_FUNC(fGecode_Gecode_IntVar_notequalop), 1);

  


  rb_define_method(rGecode_IntVar, "equal",
    RUBY_METHOD_FUNC(fGecode_Gecode_IntVar_equalop), 1);

  


  rGecode_BoolVar = rb_define_class_under(rGecodeRaw,
    "BoolVar", rb_cObject);
  rb_define_alloc_func(rGecode_BoolVar, Gecode_BoolVar_alloc);

  rb_define_module_function(rGecode_BoolVar, "initialize",
    RUBY_METHOD_FUNC(fGecode_BoolVarBoolVar), -1);

  


  rb_define_method(rGecode_BoolVar, "max",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_max), 0);

  


  rb_define_method(rGecode_BoolVar, "min",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_min), 0);

  


  rb_define_method(rGecode_BoolVar, "med",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_med), 0);

  


  rb_define_method(rGecode_BoolVar, "val",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_val), 0);

  


  rb_define_method(rGecode_BoolVar, "size",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_size), 0);

  


  rb_define_method(rGecode_BoolVar, "width",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_width), 0);

  


  rb_define_method(rGecode_BoolVar, "degree",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_degree), 0);

  


  rb_define_method(rGecode_BoolVar, "range",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_range), 0);

  


  rb_define_method(rGecode_BoolVar, "assigned",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_assigned), 0);

  


  rb_define_method(rGecode_BoolVar, "in",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_in), 1);

  


  rb_define_method(rGecode_BoolVar, "update",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_BoolVar_update), 3);

  


  rb_define_method(rGecode_BoolVar, "+",
    RUBY_METHOD_FUNC(fGecode_Gecode_BoolVar_plusop), 1);

  


  rb_define_method(rGecode_BoolVar, "-",
    RUBY_METHOD_FUNC(fGecode_Gecode_BoolVar_minusop), 1);

  


  rb_define_method(rGecode_BoolVar, "*",
    RUBY_METHOD_FUNC(fGecode_Gecode_BoolVar_multop), 1);

  


  rb_define_method(rGecode_BoolVar, "different",
    RUBY_METHOD_FUNC(fGecode_Gecode_BoolVar_notequalop), 1);

  


  rb_define_method(rGecode_BoolVar, "equal",
    RUBY_METHOD_FUNC(fGecode_Gecode_BoolVar_equalop), 1);

  


  rGecode_SetVar = rb_define_class_under(rGecodeRaw,
    "SetVar", rb_cObject);
  rb_define_alloc_func(rGecode_SetVar, Gecode_SetVar_alloc);

  rb_define_module_function(rGecode_SetVar, "initialize",
    RUBY_METHOD_FUNC(fGecode_SetVarSetVar), -1);

  


  rb_define_method(rGecode_SetVar, "glbSize",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_glbSize), -1);

  
  rb_define_alias(rGecode_SetVar, "glb_size", "glbSize");



  rb_define_method(rGecode_SetVar, "lubSize",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_lubSize), 0);

  
  rb_define_alias(rGecode_SetVar, "lub_size", "lubSize");



  rb_define_method(rGecode_SetVar, "unknownSize",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_unknownSize), 0);

  
  rb_define_alias(rGecode_SetVar, "unknown_size", "unknownSize");



  rb_define_method(rGecode_SetVar, "cardMin",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_cardMin), 0);

  
  rb_define_alias(rGecode_SetVar, "card_min", "cardMin");



  rb_define_method(rGecode_SetVar, "cardMax",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_cardMax), 0);

  
  rb_define_alias(rGecode_SetVar, "card_max", "cardMax");



  rb_define_method(rGecode_SetVar, "lubMin",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_lubMin), 0);

  
  rb_define_alias(rGecode_SetVar, "lub_min", "lubMin");



  rb_define_method(rGecode_SetVar, "lubMax",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_lubMax), 0);

  
  rb_define_alias(rGecode_SetVar, "lub_max", "lubMax");



  rb_define_method(rGecode_SetVar, "glbMin",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_glbMin), 0);

  
  rb_define_alias(rGecode_SetVar, "glb_min", "glbMin");



  rb_define_method(rGecode_SetVar, "glbMax",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_glbMax), 0);

  
  rb_define_alias(rGecode_SetVar, "glb_max", "glbMax");



  rb_define_method(rGecode_SetVar, "contains",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_contains), 1);

  


  rb_define_method(rGecode_SetVar, "notContains",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_notContains), 1);

  
  rb_define_alias(rGecode_SetVar, "not_contains", "notContains");



  rb_define_method(rGecode_SetVar, "assigned",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_assigned), 0);

  


  rb_define_method(rGecode_SetVar, "update",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_SetVar_update), 3);

  


  rGecode_MDFS = rb_define_class_under(rGecodeRaw,
    "DFS", rb_cObject);
  rb_define_alloc_func(rGecode_MDFS, Gecode_MDFS_alloc);

  rb_define_module_function(rGecode_MDFS, "initialize",
    RUBY_METHOD_FUNC(fGecode_MDFSMDFS), 2);

  


  rb_define_method(rGecode_MDFS, "next",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MDFS_next), 0);

  


  rb_define_method(rGecode_MDFS, "stopped",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MDFS_stopped), 0);

  


  rb_define_method(rGecode_MDFS, "statistics",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MDFS_statistics), 0);

  


  rGecode_MBAB = rb_define_class_under(rGecodeRaw,
    "BAB", rb_cObject);
  rb_define_alloc_func(rGecode_MBAB, Gecode_MBAB_alloc);

  rb_define_module_function(rGecode_MBAB, "initialize",
    RUBY_METHOD_FUNC(fGecode_MBABMBAB), 2);

  


  rb_define_method(rGecode_MBAB, "next",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MBAB_next), 0);

  


  rb_define_method(rGecode_MBAB, "stopped",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MBAB_stopped), 0);

  


  rb_define_method(rGecode_MBAB, "statistics",
    RUBY_METHOD_FUNC(fGecodeRaw_Gecode_MBAB_statistics), 0);

  


  rGecode_DFA = rb_define_class_under(rGecodeRaw,
    "DFA", rb_cObject);
  rb_define_alloc_func(rGecode_DFA, Gecode_DFA_alloc);

  rb_define_module_function(rGecode_DFA, "initialize",
    RUBY_METHOD_FUNC(fGecode_DFADFA), 0);

  


  rGecode_REG = rb_define_class_under(rGecodeRaw,
    "REG", rb_cObject);
  rb_define_alloc_func(rGecode_REG, Gecode_REG_alloc);

  rb_define_module_function(rGecode_REG, "initialize",
    RUBY_METHOD_FUNC(fGecode_REGREG), -1);

  


  rb_define_method(rGecode_REG, "+",
    RUBY_METHOD_FUNC(fGecode_Gecode_REG_plusop), -1);

  


  rb_define_method(rGecode_REG, "+=",
    RUBY_METHOD_FUNC(fGecode_Gecode_REG_undefop_0959), 1);

  


  rb_define_method(rGecode_REG, "|",
    RUBY_METHOD_FUNC(fGecode_Gecode_REG_undefop_0251), 1);

  


  rb_define_method(rGecode_REG, "|=",
    RUBY_METHOD_FUNC(fGecode_Gecode_REG_undefop_0426), 1);

  


  rb_define_method(rGecode_REG, "*",
    RUBY_METHOD_FUNC(fGecode_Gecode_REG_multop), 0);

  


  rb_define_method(rGecode_REG, "()",
    RUBY_METHOD_FUNC(fGecode_Gecode_REG_parenthesisop), -1);

  

rSearch = rb_define_module_under(rGecodeRaw, "Search");

  rGecode_Search_MStop = rb_define_class_under(rSearch,
    "Stop", rb_cObject);
  rb_define_alloc_func(rGecode_Search_MStop, Gecode_Search_MStop_alloc);

  rb_define_module_function(rGecode_Search_MStop, "initialize",
    RUBY_METHOD_FUNC(fGecode_Search_MStopMStop), -1);

  


  rGecode_Search_Statistics = rb_define_class_under(rSearch,
    "Statistics", rb_cObject);
  rb_define_alloc_func(rGecode_Search_Statistics, Gecode_Search_Statistics_alloc);

  rb_define_module_function(rGecode_Search_Statistics, "initialize",
    RUBY_METHOD_FUNC(fGecode_Search_StatisticsStatistics), 0);

  

  
    rb_define_method(rGecode_Search_Statistics, "memory=", RUBY_METHOD_FUNC(setGecode_Search_Statisticsmemory), 1);
    rb_define_method(rGecode_Search_Statistics, "memory", RUBY_METHOD_FUNC(getGecode_Search_Statisticsmemory), 0);

  
    rb_define_method(rGecode_Search_Statistics, "propagate=", RUBY_METHOD_FUNC(setGecode_Search_Statisticspropagate), 1);
    rb_define_method(rGecode_Search_Statistics, "propagate", RUBY_METHOD_FUNC(getGecode_Search_Statisticspropagate), 0);

  
    rb_define_method(rGecode_Search_Statistics, "fail=", RUBY_METHOD_FUNC(setGecode_Search_Statisticsfail), 1);
    rb_define_method(rGecode_Search_Statistics, "fail", RUBY_METHOD_FUNC(getGecode_Search_Statisticsfail), 0);

  
    rb_define_method(rGecode_Search_Statistics, "clone=", RUBY_METHOD_FUNC(setGecode_Search_Statisticsclone), 1);
    rb_define_method(rGecode_Search_Statistics, "clone", RUBY_METHOD_FUNC(getGecode_Search_Statisticsclone), 0);

  
    rb_define_method(rGecode_Search_Statistics, "commit=", RUBY_METHOD_FUNC(setGecode_Search_Statisticscommit), 1);
    rb_define_method(rGecode_Search_Statistics, "commit", RUBY_METHOD_FUNC(getGecode_Search_Statisticscommit), 0);


  rGecode_Search_Options = rb_define_class_under(rSearch,
    "Options", rb_cObject);
  rb_define_alloc_func(rGecode_Search_Options, Gecode_Search_Options_alloc);

  rb_define_module_function(rGecode_Search_Options, "initialize",
    RUBY_METHOD_FUNC(fGecode_Search_OptionsOptions), 0);

  

  
    rb_define_method(rGecode_Search_Options, "c_d=", RUBY_METHOD_FUNC(setGecode_Search_Optionsc_d), 1);
    rb_define_method(rGecode_Search_Options, "c_d", RUBY_METHOD_FUNC(getGecode_Search_Optionsc_d), 0);

  
    rb_define_method(rGecode_Search_Options, "a_d=", RUBY_METHOD_FUNC(setGecode_Search_Optionsa_d), 1);
    rb_define_method(rGecode_Search_Options, "a_d", RUBY_METHOD_FUNC(getGecode_Search_Optionsa_d), 0);

  
    rb_define_method(rGecode_Search_Options, "stop=", RUBY_METHOD_FUNC(setGecode_Search_Optionsstop), 1);
    rb_define_method(rGecode_Search_Options, "stop", RUBY_METHOD_FUNC(getGecode_Search_Optionsstop), 0);

rConfig = rb_define_module_under(rSearch, "Config");
rb_define_const(rConfig, "ADAPTIVE_DISTANCE", cxx2ruby(Gecode::Search::Config::a_d));

rb_define_const(rConfig, "MINIMAL_DISTANCE", cxx2ruby(Gecode::Search::Config::c_d));

rMiniModel = rb_define_module_under(rGecodeRaw, "MiniModel");

  rGecode_MiniModel_LinExprGecode_IntVar = rb_define_class_under(rMiniModel,
    "LinExpr<Gecode::IntVar>", rb_cObject);
  rb_define_alloc_func(rGecode_MiniModel_LinExprGecode_IntVar, Gecode_MiniModel_LinExprGecode_IntVar_alloc);

  rb_define_module_function(rGecode_MiniModel_LinExprGecode_IntVar, "initialize",
    RUBY_METHOD_FUNC(fGecode_MiniModel_LinExprGecode_IntVarLinExprGecode_IntVar), -1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_IntVar, "post",
    RUBY_METHOD_FUNC(fMiniModel_Gecode_MiniModel_LinExprGecode_IntVar_post), -1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_IntVar, "+",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_plusop), -1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_IntVar, "-",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_minusop), -1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_IntVar, "*",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_multop), 1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_IntVar, "equal",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_equalop), 1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_IntVar, "different",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_notequalop), 1);

  


  rGecode_MiniModel_LinExprGecode_BoolVar = rb_define_class_under(rMiniModel,
    "LinExpr<Gecode::BoolVar>", rb_cObject);
  rb_define_alloc_func(rGecode_MiniModel_LinExprGecode_BoolVar, Gecode_MiniModel_LinExprGecode_BoolVar_alloc);

  rb_define_module_function(rGecode_MiniModel_LinExprGecode_BoolVar, "initialize",
    RUBY_METHOD_FUNC(fGecode_MiniModel_LinExprGecode_BoolVarLinExprGecode_BoolVar), -1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_BoolVar, "post",
    RUBY_METHOD_FUNC(fMiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_post), -1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_BoolVar, "+",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_plusop), -1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_BoolVar, "-",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_minusop), -1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_BoolVar, "*",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_multop), 1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_BoolVar, "equal",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_equalop), 1);

  


  rb_define_method(rGecode_MiniModel_LinExprGecode_BoolVar, "different",
    RUBY_METHOD_FUNC(fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_notequalop), 1);

  


  rGecode_MiniModel_BoolExpr = rb_define_class_under(rMiniModel,
    "BoolExpr", rb_cObject);
  rb_define_alloc_func(rGecode_MiniModel_BoolExpr, Gecode_MiniModel_BoolExpr_alloc);
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_VAR", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_VAR));
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_NOT", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_NOT));
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_AND", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_AND));
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_OR", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_OR));
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_IMP", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_IMP));
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_XOR", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_XOR));
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_EQV", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_EQV));
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_RLIN_INT", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_RLIN_INT));
rb_define_const(rGecode_MiniModel_BoolExpr, "NT_RLIN_BOOL", cxx2ruby(Gecode::MiniModel::BoolExpr::NT_RLIN_BOOL));

  rb_define_module_function(rGecode_MiniModel_BoolExpr, "initialize",
    RUBY_METHOD_FUNC(fGecode_MiniModel_BoolExprBoolExpr), -1);

  


  rb_define_method(rGecode_MiniModel_BoolExpr, "post",
    RUBY_METHOD_FUNC(fMiniModel_Gecode_MiniModel_BoolExpr_post), -1);

  


  rGecode_MiniModel_BoolRel = rb_define_class_under(rMiniModel,
    "BoolRel", rb_cObject);
  rb_define_alloc_func(rGecode_MiniModel_BoolRel, Gecode_MiniModel_BoolRel_alloc);

  rb_define_module_function(rGecode_MiniModel_BoolRel, "initialize",
    RUBY_METHOD_FUNC(fGecode_MiniModel_BoolRelBoolRel), 2);

  


  rGecode_MiniModel_LinRelGecode_IntVar = rb_define_class_under(rMiniModel,
    "LinRel<Gecode::IntVar>", rb_cObject);
  rb_define_alloc_func(rGecode_MiniModel_LinRelGecode_IntVar, Gecode_MiniModel_LinRelGecode_IntVar_alloc);

  rb_define_module_function(rGecode_MiniModel_LinRelGecode_IntVar, "initialize",
    RUBY_METHOD_FUNC(fGecode_MiniModel_LinRelGecode_IntVarLinRelGecode_IntVar), -1);

  


  rb_define_method(rGecode_MiniModel_LinRelGecode_IntVar, "post",
    RUBY_METHOD_FUNC(fMiniModel_Gecode_MiniModel_LinRelGecode_IntVar_post), -1);

  


  rGecode_MiniModel_LinRelGecode_BoolVar = rb_define_class_under(rMiniModel,
    "LinRel<Gecode::BoolVar>", rb_cObject);
  rb_define_alloc_func(rGecode_MiniModel_LinRelGecode_BoolVar, Gecode_MiniModel_LinRelGecode_BoolVar_alloc);

  rb_define_module_function(rGecode_MiniModel_LinRelGecode_BoolVar, "initialize",
    RUBY_METHOD_FUNC(fGecode_MiniModel_LinRelGecode_BoolVarLinRelGecode_BoolVar), -1);

  


  rb_define_method(rGecode_MiniModel_LinRelGecode_BoolVar, "post",
    RUBY_METHOD_FUNC(fMiniModel_Gecode_MiniModel_LinRelGecode_BoolVar_post), -1);

  


  rb_define_module_function(rGecodeRaw, "abs",
    RUBY_METHOD_FUNC(fGecodeRawabs), 5);

  


  rb_define_module_function(rGecodeRaw, "max",
    RUBY_METHOD_FUNC(fGecodeRawmax), -1);

  


  rb_define_module_function(rGecodeRaw, "min",
    RUBY_METHOD_FUNC(fGecodeRawmin), -1);

  


  rb_define_module_function(rGecodeRaw, "mult",
    RUBY_METHOD_FUNC(fGecodeRawmult), 6);

  


  rb_define_module_function(rGecodeRaw, "sqr",
    RUBY_METHOD_FUNC(fGecodeRawsqr), 5);

  


  rb_define_module_function(rGecodeRaw, "sqrt",
    RUBY_METHOD_FUNC(fGecodeRawsqrt), 5);

  


  rb_define_module_function(rGecodeRaw, "branch",
    RUBY_METHOD_FUNC(fGecodeRawbranch), -1);

  


  rb_define_module_function(rGecodeRaw, "assign",
    RUBY_METHOD_FUNC(fGecodeRawassign), 3);

  


  rb_define_module_function(rGecodeRaw, "channel",
    RUBY_METHOD_FUNC(fGecodeRawchannel), -1);

  


  rb_define_module_function(rGecodeRaw, "count",
    RUBY_METHOD_FUNC(fGecodeRawcount), -1);

  


  rb_define_module_function(rGecodeRaw, "distinct",
    RUBY_METHOD_FUNC(fGecodeRawdistinct), -1);

  


  rb_define_module_function(rGecodeRaw, "dom",
    RUBY_METHOD_FUNC(fGecodeRawdom), -1);

  


  rb_define_module_function(rGecodeRaw, "element",
    RUBY_METHOD_FUNC(fGecodeRawelement), -1);

  


  rb_define_module_function(rGecodeRaw, "linear",
    RUBY_METHOD_FUNC(fGecodeRawlinear), -1);

  


  rb_define_module_function(rGecodeRaw, "extensional",
    RUBY_METHOD_FUNC(fGecodeRawextensional), -1);

  


  rb_define_module_function(rGecodeRaw, "bab",
    RUBY_METHOD_FUNC(fGecodeRawbab), 2);

  


  rb_define_module_function(rGecodeRaw, "rel",
    RUBY_METHOD_FUNC(fGecodeRawrel), -1);

  


  rb_define_module_function(rGecodeRaw, "sorted",
    RUBY_METHOD_FUNC(fGecodeRawsorted), -1);

  


  rb_define_module_function(rGecodeRaw, "post",
    RUBY_METHOD_FUNC(fGecodeRawpost), -1);

  


  rb_define_module_function(rGecodeRaw, "atmost",
    RUBY_METHOD_FUNC(fGecodeRawatmost), -1);

  


  rb_define_module_function(rGecodeRaw, "atleast",
    RUBY_METHOD_FUNC(fGecodeRawatleast), -1);

  


  rb_define_module_function(rGecodeRaw, "exactly",
    RUBY_METHOD_FUNC(fGecodeRawexactly), -1);

  


  rb_define_module_function(rGecodeRaw, "lex",
    RUBY_METHOD_FUNC(fGecodeRawlex), -1);

  


  rb_define_module_function(rGecodeRaw, "cardinality",
    RUBY_METHOD_FUNC(fGecodeRawcardinality), -1);

  


  rb_define_module_function(rGecodeRaw, "convex",
    RUBY_METHOD_FUNC(fGecodeRawconvex), 2);

  


  rb_define_module_function(rGecodeRaw, "convexHull",
    RUBY_METHOD_FUNC(fGecodeRawconvexHull), 3);

  
  rb_define_alias(rGecodeRaw, "convex_hull", "convexHull");



  rb_define_module_function(rGecodeRaw, "atmostOne",
    RUBY_METHOD_FUNC(fGecodeRawatmostOne), 3);

  
  rb_define_alias(rGecodeRaw, "atmost_one", "atmostOne");



  rb_define_module_function(rGecodeRaw, "match",
    RUBY_METHOD_FUNC(fGecodeRawmatch), 3);

  


  rb_define_module_function(rGecodeRaw, "weights",
    RUBY_METHOD_FUNC(fGecodeRawweights), 5);

  


  rb_define_module_function(rGecodeRaw, "elementsUnion",
    RUBY_METHOD_FUNC(fGecodeRawelementsUnion), 4);

  
  rb_define_alias(rGecodeRaw, "elements_union", "elementsUnion");



  rb_define_module_function(rGecodeRaw, "elementsInter",
    RUBY_METHOD_FUNC(fGecodeRawelementsInter), -1);

  
  rb_define_alias(rGecodeRaw, "elements_inter", "elementsInter");



  rb_define_module_function(rGecodeRaw, "elementsDisjoint",
    RUBY_METHOD_FUNC(fGecodeRawelementsDisjoint), 3);

  
  rb_define_alias(rGecodeRaw, "elements_disjoint", "elementsDisjoint");



  rb_define_module_function(rGecodeRaw, "sequence",
    RUBY_METHOD_FUNC(fGecodeRawsequence), 2);

  


  rb_define_module_function(rGecodeRaw, "sequentialUnion",
    RUBY_METHOD_FUNC(fGecodeRawsequentialUnion), 3);

  
  rb_define_alias(rGecodeRaw, "sequential_union", "sequentialUnion");



} /* Init_gecode */

}
