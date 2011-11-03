
extern "C" {
  #include <ruby.h>
  
}


#include <gecode/kernel.hh>
#include <gecode/int.hh>
#include <gecode/set.hh>
#include <gecode/search.hh>
#include <gecode/minimodel.hh>
#include "gecoder.h"

/* This is for the ptrMap */
#include <map>

namespace Rust_gecode {


extern VALUE rGecodeRaw;

Gecode::IntVarBranch ruby2Gecode_IntVarBranch(VALUE rval, int argn = -1);


Gecode::IntValBranch ruby2Gecode_IntValBranch(VALUE rval, int argn = -1);


Gecode::SetVarBranch ruby2Gecode_SetVarBranch(VALUE rval, int argn = -1);


Gecode::SetValBranch ruby2Gecode_SetValBranch(VALUE rval, int argn = -1);


Gecode::IntRelType ruby2Gecode_IntRelType(VALUE rval, int argn = -1);


Gecode::BoolOpType ruby2Gecode_BoolOpType(VALUE rval, int argn = -1);


Gecode::SetRelType ruby2Gecode_SetRelType(VALUE rval, int argn = -1);


Gecode::SetOpType ruby2Gecode_SetOpType(VALUE rval, int argn = -1);


Gecode::IntConLevel ruby2Gecode_IntConLevel(VALUE rval, int argn = -1);


Gecode::PropKind ruby2Gecode_PropKind(VALUE rval, int argn = -1);


Gecode::SpaceStatus ruby2Gecode_SpaceStatus(VALUE rval, int argn = -1);


Gecode::IntAssign ruby2Gecode_IntAssign(VALUE rval, int argn = -1);


extern VALUE rGecode_MIntVarArray;
VALUE cxx2ruby(Gecode::MIntVarArray* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MIntVarArray(VALUE val);
Gecode::MIntVarArray* ruby2Gecode_MIntVarArrayPtr(VALUE rval, int argn = -1);
Gecode::MIntVarArray& ruby2Gecode_MIntVarArray(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MIntVarArray*> TGecode_MIntVarArrayMap;
extern TGecode_MIntVarArrayMap Gecode_MIntVarArrayMap;
static void Gecode_MIntVarArray_free(void *p);
static void Gecode_MIntVarArray_mark(void *p);
static void Gecode_MIntVarArray_free_map_entry(void *p);
VALUE fGecode_MIntVarArrayMIntVarArray ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_MIntVarArray_at ( VALUE self , VALUE index );

VALUE fGecode_Gecode_MIntVarArray_atop ( VALUE self , VALUE index );

VALUE fGecode_Gecode_MIntVarArray_ateqop ( VALUE self , VALUE index, VALUE val );

VALUE fGecodeRaw_Gecode_MIntVarArray_enlargeArray ( VALUE self , VALUE home, VALUE n );

VALUE fGecodeRaw_Gecode_MIntVarArray_size ( VALUE self  );

VALUE fGecodeRaw_Gecode_MIntVarArray_debug ( VALUE self  );


extern VALUE rGecode_MBoolVarArray;
VALUE cxx2ruby(Gecode::MBoolVarArray* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MBoolVarArray(VALUE val);
Gecode::MBoolVarArray* ruby2Gecode_MBoolVarArrayPtr(VALUE rval, int argn = -1);
Gecode::MBoolVarArray& ruby2Gecode_MBoolVarArray(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MBoolVarArray*> TGecode_MBoolVarArrayMap;
extern TGecode_MBoolVarArrayMap Gecode_MBoolVarArrayMap;
static void Gecode_MBoolVarArray_free(void *p);
static void Gecode_MBoolVarArray_mark(void *p);
static void Gecode_MBoolVarArray_free_map_entry(void *p);
VALUE fGecode_MBoolVarArrayMBoolVarArray ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_MBoolVarArray_at ( VALUE self , VALUE index );

VALUE fGecode_Gecode_MBoolVarArray_atop ( VALUE self , VALUE index );

VALUE fGecode_Gecode_MBoolVarArray_ateqop ( VALUE self , VALUE index, VALUE val );

VALUE fGecodeRaw_Gecode_MBoolVarArray_enlargeArray ( VALUE self , VALUE home, VALUE n );

VALUE fGecodeRaw_Gecode_MBoolVarArray_size ( VALUE self  );

VALUE fGecodeRaw_Gecode_MBoolVarArray_debug ( VALUE self  );


extern VALUE rGecode_MSetVarArray;
VALUE cxx2ruby(Gecode::MSetVarArray* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MSetVarArray(VALUE val);
Gecode::MSetVarArray* ruby2Gecode_MSetVarArrayPtr(VALUE rval, int argn = -1);
Gecode::MSetVarArray& ruby2Gecode_MSetVarArray(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MSetVarArray*> TGecode_MSetVarArrayMap;
extern TGecode_MSetVarArrayMap Gecode_MSetVarArrayMap;
static void Gecode_MSetVarArray_free(void *p);
static void Gecode_MSetVarArray_mark(void *p);
static void Gecode_MSetVarArray_free_map_entry(void *p);
VALUE fGecode_MSetVarArrayMSetVarArray ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_MSetVarArray_at ( VALUE self , VALUE index );

VALUE fGecode_Gecode_MSetVarArray_atop ( VALUE self , VALUE index );

VALUE fGecode_Gecode_MSetVarArray_ateqop ( VALUE self , VALUE index, VALUE val );

VALUE fGecodeRaw_Gecode_MSetVarArray_enlargeArray ( VALUE self , VALUE home, VALUE n );

VALUE fGecodeRaw_Gecode_MSetVarArray_size ( VALUE self  );

VALUE fGecodeRaw_Gecode_MSetVarArray_debug ( VALUE self  );


extern VALUE rGecode_TupleSet;
VALUE cxx2ruby(Gecode::TupleSet* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_TupleSet(VALUE val);
Gecode::TupleSet* ruby2Gecode_TupleSetPtr(VALUE rval, int argn = -1);
Gecode::TupleSet& ruby2Gecode_TupleSet(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::TupleSet*> TGecode_TupleSetMap;
extern TGecode_TupleSetMap Gecode_TupleSetMap;
static void Gecode_TupleSet_free(void *p);
static void Gecode_TupleSet_mark(void *p);
static void Gecode_TupleSet_free_map_entry(void *p);
VALUE fGecode_TupleSetTupleSet ( VALUE self  );

VALUE fGecodeRaw_Gecode_TupleSet_add ( VALUE self , VALUE tuple );

VALUE fGecodeRaw_Gecode_TupleSet_finalize ( VALUE self  );

VALUE fGecodeRaw_Gecode_TupleSet_finalized ( VALUE self  );

VALUE fGecodeRaw_Gecode_TupleSet_tuples ( VALUE self  );


extern VALUE rGecode_MSpace;
VALUE cxx2ruby(Gecode::MSpace* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MSpace(VALUE val);
Gecode::MSpace* ruby2Gecode_MSpacePtr(VALUE rval, int argn = -1);
Gecode::MSpace& ruby2Gecode_MSpace(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MSpace*> TGecode_MSpaceMap;
extern TGecode_MSpaceMap Gecode_MSpaceMap;
static void Gecode_MSpace_free(void *p);
static void Gecode_MSpace_mark(void *p);
static void Gecode_MSpace_free_map_entry(void *p);
VALUE fGecode_MSpaceMSpace ( VALUE self  );

VALUE fGecodeRaw_Gecode_MSpace_constrain ( VALUE self , VALUE s );

VALUE fGecodeRaw_Gecode_MSpace_new_int_var ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_MSpace_new_bool_var ( VALUE self  );

VALUE fGecodeRaw_Gecode_MSpace_new_set_var ( VALUE self , VALUE glb, VALUE lub, VALUE cardMin, VALUE cardMax );

VALUE fGecodeRaw_Gecode_MSpace_int_var ( VALUE self , VALUE id );

VALUE fGecodeRaw_Gecode_MSpace_bool_var ( VALUE self , VALUE id );

VALUE fGecodeRaw_Gecode_MSpace_set_var ( VALUE self , VALUE id );

VALUE fGecodeRaw_Gecode_MSpace_clone ( VALUE self , VALUE shared );

VALUE fGecodeRaw_Gecode_MSpace_status ( VALUE self  );

VALUE fGecodeRaw_Gecode_MSpace_propagators ( VALUE self  );

VALUE fGecodeRaw_Gecode_MSpace_branchings ( VALUE self  );

VALUE fGecodeRaw_Gecode_MSpace_failed ( VALUE self  );


extern VALUE rIntLimits;



extern VALUE rSetLimits;




extern VALUE rGecode_IntSet;
VALUE cxx2ruby(Gecode::IntSet* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_IntSet(VALUE val);
Gecode::IntSet* ruby2Gecode_IntSetPtr(VALUE rval, int argn = -1);
Gecode::IntSet& ruby2Gecode_IntSet(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::IntSet*> TGecode_IntSetMap;
extern TGecode_IntSetMap Gecode_IntSetMap;
static void Gecode_IntSet_free(void *p);
static void Gecode_IntSet_mark(void *p);
static void Gecode_IntSet_free_map_entry(void *p);
VALUE fGecode_IntSetIntSet ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_IntSet_size ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntSet_width ( VALUE self , VALUE i );

VALUE fGecodeRaw_Gecode_IntSet_max ( VALUE self , VALUE i );

VALUE fGecodeRaw_Gecode_IntSet_min ( VALUE self , VALUE i );



extern VALUE rGecode_IntVar;
VALUE cxx2ruby(Gecode::IntVar* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_IntVar(VALUE val);
Gecode::IntVar* ruby2Gecode_IntVarPtr(VALUE rval, int argn = -1);
Gecode::IntVar& ruby2Gecode_IntVar(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::IntVar*> TGecode_IntVarMap;
extern TGecode_IntVarMap Gecode_IntVarMap;
static void Gecode_IntVar_free(void *p);
static void Gecode_IntVar_mark(void *p);
static void Gecode_IntVar_free_map_entry(void *p);
VALUE fGecode_IntVarIntVar ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_IntVar_max ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_min ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_med ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_val ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_size ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_width ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_degree ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_range ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_assigned ( VALUE self  );

VALUE fGecodeRaw_Gecode_IntVar_in ( VALUE self , VALUE n );

VALUE fGecodeRaw_Gecode_IntVar_update ( VALUE self , VALUE home, VALUE share, VALUE x );

VALUE fGecode_Gecode_IntVar_plusop ( VALUE self , VALUE i );

VALUE fGecode_Gecode_IntVar_minusop ( VALUE self , VALUE i );

VALUE fGecode_Gecode_IntVar_multop ( VALUE self , VALUE i );

VALUE fGecode_Gecode_IntVar_notequalop ( VALUE self , VALUE other );

VALUE fGecode_Gecode_IntVar_equalop ( VALUE self , VALUE other );


extern VALUE rGecode_BoolVar;
VALUE cxx2ruby(Gecode::BoolVar* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_BoolVar(VALUE val);
Gecode::BoolVar* ruby2Gecode_BoolVarPtr(VALUE rval, int argn = -1);
Gecode::BoolVar& ruby2Gecode_BoolVar(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::BoolVar*> TGecode_BoolVarMap;
extern TGecode_BoolVarMap Gecode_BoolVarMap;
static void Gecode_BoolVar_free(void *p);
static void Gecode_BoolVar_mark(void *p);
static void Gecode_BoolVar_free_map_entry(void *p);
VALUE fGecode_BoolVarBoolVar ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_BoolVar_max ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_min ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_med ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_val ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_size ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_width ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_degree ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_range ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_assigned ( VALUE self  );

VALUE fGecodeRaw_Gecode_BoolVar_in ( VALUE self , VALUE n );

VALUE fGecodeRaw_Gecode_BoolVar_update ( VALUE self , VALUE home, VALUE share, VALUE x );

VALUE fGecode_Gecode_BoolVar_plusop ( VALUE self , VALUE i );

VALUE fGecode_Gecode_BoolVar_minusop ( VALUE self , VALUE i );

VALUE fGecode_Gecode_BoolVar_multop ( VALUE self , VALUE i );

VALUE fGecode_Gecode_BoolVar_notequalop ( VALUE self , VALUE other );

VALUE fGecode_Gecode_BoolVar_equalop ( VALUE self , VALUE other );


extern VALUE rGecode_SetVar;
VALUE cxx2ruby(Gecode::SetVar* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_SetVar(VALUE val);
Gecode::SetVar* ruby2Gecode_SetVarPtr(VALUE rval, int argn = -1);
Gecode::SetVar& ruby2Gecode_SetVar(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::SetVar*> TGecode_SetVarMap;
extern TGecode_SetVarMap Gecode_SetVarMap;
static void Gecode_SetVar_free(void *p);
static void Gecode_SetVar_mark(void *p);
static void Gecode_SetVar_free_map_entry(void *p);
VALUE fGecode_SetVarSetVar ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_SetVar_glbSize ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRaw_Gecode_SetVar_lubSize ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_unknownSize ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_cardMin ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_cardMax ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_lubMin ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_lubMax ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_glbMin ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_glbMax ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_contains ( VALUE self , VALUE i );

VALUE fGecodeRaw_Gecode_SetVar_notContains ( VALUE self , VALUE i );

VALUE fGecodeRaw_Gecode_SetVar_assigned ( VALUE self  );

VALUE fGecodeRaw_Gecode_SetVar_update ( VALUE self , VALUE home, VALUE shared, VALUE x );


extern VALUE rGecode_MDFS;
VALUE cxx2ruby(Gecode::MDFS* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MDFS(VALUE val);
Gecode::MDFS* ruby2Gecode_MDFSPtr(VALUE rval, int argn = -1);
Gecode::MDFS& ruby2Gecode_MDFS(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MDFS*> TGecode_MDFSMap;
extern TGecode_MDFSMap Gecode_MDFSMap;
static void Gecode_MDFS_free(void *p);
static void Gecode_MDFS_mark(void *p);
static void Gecode_MDFS_free_map_entry(void *p);
VALUE fGecode_MDFSMDFS ( VALUE self , VALUE s, VALUE o );

VALUE fGecodeRaw_Gecode_MDFS_next ( VALUE self  );

VALUE fGecodeRaw_Gecode_MDFS_stopped ( VALUE self  );

VALUE fGecodeRaw_Gecode_MDFS_statistics ( VALUE self  );


extern VALUE rGecode_MBAB;
VALUE cxx2ruby(Gecode::MBAB* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MBAB(VALUE val);
Gecode::MBAB* ruby2Gecode_MBABPtr(VALUE rval, int argn = -1);
Gecode::MBAB& ruby2Gecode_MBAB(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MBAB*> TGecode_MBABMap;
extern TGecode_MBABMap Gecode_MBABMap;
static void Gecode_MBAB_free(void *p);
static void Gecode_MBAB_mark(void *p);
static void Gecode_MBAB_free_map_entry(void *p);
VALUE fGecode_MBABMBAB ( VALUE self , VALUE s, VALUE o );

VALUE fGecodeRaw_Gecode_MBAB_next ( VALUE self  );

VALUE fGecodeRaw_Gecode_MBAB_stopped ( VALUE self  );

VALUE fGecodeRaw_Gecode_MBAB_statistics ( VALUE self  );


extern VALUE rGecode_DFA;
VALUE cxx2ruby(Gecode::DFA* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_DFA(VALUE val);
Gecode::DFA* ruby2Gecode_DFAPtr(VALUE rval, int argn = -1);
Gecode::DFA& ruby2Gecode_DFA(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::DFA*> TGecode_DFAMap;
extern TGecode_DFAMap Gecode_DFAMap;
static void Gecode_DFA_free(void *p);
static void Gecode_DFA_mark(void *p);
static void Gecode_DFA_free_map_entry(void *p);
VALUE fGecode_DFADFA ( VALUE self  );


extern VALUE rGecode_REG;
VALUE cxx2ruby(Gecode::REG* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_REG(VALUE val);
Gecode::REG* ruby2Gecode_REGPtr(VALUE rval, int argn = -1);
Gecode::REG& ruby2Gecode_REG(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::REG*> TGecode_REGMap;
extern TGecode_REGMap Gecode_REGMap;
static void Gecode_REG_free(void *p);
static void Gecode_REG_mark(void *p);
static void Gecode_REG_free_map_entry(void *p);
VALUE fGecode_REGREG ( int argc, VALUE *argv, VALUE self );

VALUE fGecode_Gecode_REG_plusop ( int argc, VALUE *argv, VALUE self );

VALUE fGecode_Gecode_REG_undefop_0959 ( VALUE self , VALUE r );

VALUE fGecode_Gecode_REG_undefop_0251 ( VALUE self , VALUE r );

VALUE fGecode_Gecode_REG_undefop_0426 ( VALUE self , VALUE r );

VALUE fGecode_Gecode_REG_multop ( VALUE self  );

VALUE fGecode_Gecode_REG_parenthesisop ( int argc, VALUE *argv, VALUE self );


extern VALUE rSearch;

extern VALUE rGecode_Search_MStop;
VALUE cxx2ruby(Gecode::Search::MStop* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_Search_MStop(VALUE val);
Gecode::Search::MStop* ruby2Gecode_Search_MStopPtr(VALUE rval, int argn = -1);
Gecode::Search::MStop& ruby2Gecode_Search_MStop(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::Search::MStop*> TGecode_Search_MStopMap;
extern TGecode_Search_MStopMap Gecode_Search_MStopMap;
static void Gecode_Search_MStop_free(void *p);
static void Gecode_Search_MStop_mark(void *p);
static void Gecode_Search_MStop_free_map_entry(void *p);
VALUE fGecode_Search_MStopMStop ( int argc, VALUE *argv, VALUE self );


extern VALUE rGecode_Search_Statistics;
VALUE cxx2ruby(Gecode::Search::Statistics* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_Search_Statistics(VALUE val);
Gecode::Search::Statistics* ruby2Gecode_Search_StatisticsPtr(VALUE rval, int argn = -1);
Gecode::Search::Statistics& ruby2Gecode_Search_Statistics(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::Search::Statistics*> TGecode_Search_StatisticsMap;
extern TGecode_Search_StatisticsMap Gecode_Search_StatisticsMap;
static void Gecode_Search_Statistics_free(void *p);
static void Gecode_Search_Statistics_mark(void *p);
static void Gecode_Search_Statistics_free_map_entry(void *p);
VALUE fGecode_Search_StatisticsStatistics ( VALUE self  );







extern VALUE rGecode_Search_Options;
VALUE cxx2ruby(Gecode::Search::Options* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_Search_Options(VALUE val);
Gecode::Search::Options* ruby2Gecode_Search_OptionsPtr(VALUE rval, int argn = -1);
Gecode::Search::Options& ruby2Gecode_Search_Options(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::Search::Options*> TGecode_Search_OptionsMap;
extern TGecode_Search_OptionsMap Gecode_Search_OptionsMap;
static void Gecode_Search_Options_free(void *p);
static void Gecode_Search_Options_mark(void *p);
static void Gecode_Search_Options_free_map_entry(void *p);
VALUE fGecode_Search_OptionsOptions ( VALUE self  );





extern VALUE rConfig;



extern VALUE rMiniModel;

extern VALUE rGecode_MiniModel_LinExprGecode_IntVar;
VALUE cxx2ruby(Gecode::MiniModel::LinExpr<Gecode::IntVar>* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MiniModel_LinExprGecode_IntVar(VALUE val);
Gecode::MiniModel::LinExpr<Gecode::IntVar>* ruby2Gecode_MiniModel_LinExprGecode_IntVarPtr(VALUE rval, int argn = -1);
Gecode::MiniModel::LinExpr<Gecode::IntVar>& ruby2Gecode_MiniModel_LinExprGecode_IntVar(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MiniModel::LinExpr<Gecode::IntVar>*> TGecode_MiniModel_LinExprGecode_IntVarMap;
extern TGecode_MiniModel_LinExprGecode_IntVarMap Gecode_MiniModel_LinExprGecode_IntVarMap;
static void Gecode_MiniModel_LinExprGecode_IntVar_free(void *p);
static void Gecode_MiniModel_LinExprGecode_IntVar_mark(void *p);
static void Gecode_MiniModel_LinExprGecode_IntVar_free_map_entry(void *p);
VALUE fGecode_MiniModel_LinExprGecode_IntVarLinExprGecode_IntVar ( int argc, VALUE *argv, VALUE self );

VALUE fMiniModel_Gecode_MiniModel_LinExprGecode_IntVar_post ( int argc, VALUE *argv, VALUE self );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_plusop ( int argc, VALUE *argv, VALUE self );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_minusop ( int argc, VALUE *argv, VALUE self );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_multop ( VALUE self , VALUE c );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_equalop ( VALUE self , VALUE other );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_IntVar_notequalop ( VALUE self , VALUE other );


extern VALUE rGecode_MiniModel_LinExprGecode_BoolVar;
VALUE cxx2ruby(Gecode::MiniModel::LinExpr<Gecode::BoolVar>* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MiniModel_LinExprGecode_BoolVar(VALUE val);
Gecode::MiniModel::LinExpr<Gecode::BoolVar>* ruby2Gecode_MiniModel_LinExprGecode_BoolVarPtr(VALUE rval, int argn = -1);
Gecode::MiniModel::LinExpr<Gecode::BoolVar>& ruby2Gecode_MiniModel_LinExprGecode_BoolVar(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MiniModel::LinExpr<Gecode::BoolVar>*> TGecode_MiniModel_LinExprGecode_BoolVarMap;
extern TGecode_MiniModel_LinExprGecode_BoolVarMap Gecode_MiniModel_LinExprGecode_BoolVarMap;
static void Gecode_MiniModel_LinExprGecode_BoolVar_free(void *p);
static void Gecode_MiniModel_LinExprGecode_BoolVar_mark(void *p);
static void Gecode_MiniModel_LinExprGecode_BoolVar_free_map_entry(void *p);
VALUE fGecode_MiniModel_LinExprGecode_BoolVarLinExprGecode_BoolVar ( int argc, VALUE *argv, VALUE self );

VALUE fMiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_post ( int argc, VALUE *argv, VALUE self );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_plusop ( int argc, VALUE *argv, VALUE self );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_minusop ( int argc, VALUE *argv, VALUE self );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_multop ( VALUE self , VALUE c );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_equalop ( VALUE self , VALUE other );

VALUE fGecode_MiniModel_Gecode_MiniModel_LinExprGecode_BoolVar_notequalop ( VALUE self , VALUE other );


extern VALUE rGecode_MiniModel_BoolExpr;
VALUE cxx2ruby(Gecode::MiniModel::BoolExpr* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MiniModel_BoolExpr(VALUE val);
Gecode::MiniModel::BoolExpr* ruby2Gecode_MiniModel_BoolExprPtr(VALUE rval, int argn = -1);
Gecode::MiniModel::BoolExpr& ruby2Gecode_MiniModel_BoolExpr(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MiniModel::BoolExpr*> TGecode_MiniModel_BoolExprMap;
extern TGecode_MiniModel_BoolExprMap Gecode_MiniModel_BoolExprMap;
static void Gecode_MiniModel_BoolExpr_free(void *p);
static void Gecode_MiniModel_BoolExpr_mark(void *p);
static void Gecode_MiniModel_BoolExpr_free_map_entry(void *p);

Gecode::MiniModel::BoolExpr::NodeType ruby2Gecode_MiniModel_BoolExpr_NodeType(VALUE rval, int argn = -1);

VALUE fGecode_MiniModel_BoolExprBoolExpr ( int argc, VALUE *argv, VALUE self );

VALUE fMiniModel_Gecode_MiniModel_BoolExpr_post ( int argc, VALUE *argv, VALUE self );


extern VALUE rGecode_MiniModel_BoolRel;
VALUE cxx2ruby(Gecode::MiniModel::BoolRel* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MiniModel_BoolRel(VALUE val);
Gecode::MiniModel::BoolRel* ruby2Gecode_MiniModel_BoolRelPtr(VALUE rval, int argn = -1);
Gecode::MiniModel::BoolRel& ruby2Gecode_MiniModel_BoolRel(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MiniModel::BoolRel*> TGecode_MiniModel_BoolRelMap;
extern TGecode_MiniModel_BoolRelMap Gecode_MiniModel_BoolRelMap;
static void Gecode_MiniModel_BoolRel_free(void *p);
static void Gecode_MiniModel_BoolRel_mark(void *p);
static void Gecode_MiniModel_BoolRel_free_map_entry(void *p);
VALUE fGecode_MiniModel_BoolRelBoolRel ( VALUE self , VALUE e, VALUE t );


extern VALUE rGecode_MiniModel_LinRelGecode_IntVar;
VALUE cxx2ruby(Gecode::MiniModel::LinRel<Gecode::IntVar>* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MiniModel_LinRelGecode_IntVar(VALUE val);
Gecode::MiniModel::LinRel<Gecode::IntVar>* ruby2Gecode_MiniModel_LinRelGecode_IntVarPtr(VALUE rval, int argn = -1);
Gecode::MiniModel::LinRel<Gecode::IntVar>& ruby2Gecode_MiniModel_LinRelGecode_IntVar(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MiniModel::LinRel<Gecode::IntVar>*> TGecode_MiniModel_LinRelGecode_IntVarMap;
extern TGecode_MiniModel_LinRelGecode_IntVarMap Gecode_MiniModel_LinRelGecode_IntVarMap;
static void Gecode_MiniModel_LinRelGecode_IntVar_free(void *p);
static void Gecode_MiniModel_LinRelGecode_IntVar_mark(void *p);
static void Gecode_MiniModel_LinRelGecode_IntVar_free_map_entry(void *p);
VALUE fGecode_MiniModel_LinRelGecode_IntVarLinRelGecode_IntVar ( int argc, VALUE *argv, VALUE self );

VALUE fMiniModel_Gecode_MiniModel_LinRelGecode_IntVar_post ( int argc, VALUE *argv, VALUE self );


extern VALUE rGecode_MiniModel_LinRelGecode_BoolVar;
VALUE cxx2ruby(Gecode::MiniModel::LinRel<Gecode::BoolVar>* instance, bool free = false, bool create_new_if_needed = true);
bool is_Gecode_MiniModel_LinRelGecode_BoolVar(VALUE val);
Gecode::MiniModel::LinRel<Gecode::BoolVar>* ruby2Gecode_MiniModel_LinRelGecode_BoolVarPtr(VALUE rval, int argn = -1);
Gecode::MiniModel::LinRel<Gecode::BoolVar>& ruby2Gecode_MiniModel_LinRelGecode_BoolVar(VALUE rval, int argn = -1);

typedef std::map<VALUE, Gecode::MiniModel::LinRel<Gecode::BoolVar>*> TGecode_MiniModel_LinRelGecode_BoolVarMap;
extern TGecode_MiniModel_LinRelGecode_BoolVarMap Gecode_MiniModel_LinRelGecode_BoolVarMap;
static void Gecode_MiniModel_LinRelGecode_BoolVar_free(void *p);
static void Gecode_MiniModel_LinRelGecode_BoolVar_mark(void *p);
static void Gecode_MiniModel_LinRelGecode_BoolVar_free_map_entry(void *p);
VALUE fGecode_MiniModel_LinRelGecode_BoolVarLinRelGecode_BoolVar ( int argc, VALUE *argv, VALUE self );

VALUE fMiniModel_Gecode_MiniModel_LinRelGecode_BoolVar_post ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawabs ( VALUE self , VALUE home, VALUE x0, VALUE x1, VALUE icl, VALUE pk );

VALUE fGecodeRawmax ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawmin ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawmult ( VALUE self , VALUE home, VALUE x0, VALUE x1, VALUE x2, VALUE icl, VALUE pk );

VALUE fGecodeRawsqr ( VALUE self , VALUE home, VALUE x0, VALUE x1, VALUE icl, VALUE pk );

VALUE fGecodeRawsqrt ( VALUE self , VALUE home, VALUE x0, VALUE x1, VALUE icl, VALUE pk );

VALUE fGecodeRawbranch ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawassign ( VALUE self , VALUE home, VALUE iva, VALUE vals );

VALUE fGecodeRawchannel ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawcount ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawdistinct ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawdom ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawelement ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawlinear ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawextensional ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawbab ( VALUE self , VALUE home, VALUE o );

VALUE fGecodeRawrel ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawsorted ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawpost ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawatmost ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawatleast ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawexactly ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawlex ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawcardinality ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawconvex ( VALUE self , VALUE home, VALUE s );

VALUE fGecodeRawconvexHull ( VALUE self , VALUE home, VALUE x, VALUE y );

VALUE fGecodeRawatmostOne ( VALUE self , VALUE home, VALUE x, VALUE c );

VALUE fGecodeRawmatch ( VALUE self , VALUE home, VALUE s, VALUE x );

VALUE fGecodeRawweights ( VALUE self , VALUE home, VALUE elements, VALUE weights, VALUE x, VALUE y );

VALUE fGecodeRawelementsUnion ( VALUE self , VALUE home, VALUE x, VALUE y, VALUE z );

VALUE fGecodeRawelementsInter ( int argc, VALUE *argv, VALUE self );

VALUE fGecodeRawelementsDisjoint ( VALUE self , VALUE home, VALUE x, VALUE y );

VALUE fGecodeRawsequence ( VALUE self , VALUE home, VALUE x );

VALUE fGecodeRawsequentialUnion ( VALUE self , VALUE home, VALUE y, VALUE x );


}
