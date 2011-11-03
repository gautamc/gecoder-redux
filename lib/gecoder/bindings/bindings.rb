# Copyright (c) 2007, David Cuadrado <krawek@gmail.com>
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.


RUST_PATH = File.dirname(__FILE__) + '/../../../vendor/rust'
$:.unshift(RUST_PATH) unless $:.include?(RUST_PATH)
require 'rust'

ruby2intargs = %@

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
@

custom_mark_definitions =<<-"end_custom_definition"
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
end_custom_definition


Rust::Bindings::create_bindings Rust::Bindings::LangCxx, "gecode" do |b|
  b.include_header 'gecode/kernel.hh', Rust::Bindings::HeaderGlobal
  b.include_header 'gecode/int.hh', Rust::Bindings::HeaderGlobal
  b.include_header 'gecode/set.hh', Rust::Bindings::HeaderGlobal
  b.include_header 'gecode/search.hh', Rust::Bindings::HeaderGlobal
  b.include_header 'gecode/minimodel.hh', Rust::Bindings::HeaderGlobal
  b.include_header 'gecoder.h', Rust::Bindings::HeaderLocal
  
  b.add_custom_definition ruby2intargs
  b.add_custom_definition custom_mark_definitions
  
  # Is it possible to use namespaces with multiple levels in Rust? I.e. use
  # Gecode::Raw instead of GecodeRaw here (and avoid the hidious renaming)
  # when requiring them.
  b.add_namespace "GecodeRaw", "Gecode" do |ns|
    ns.add_enum "IntVarBranch" do |enum|
      enum.add_value "INT_VAR_NONE"
      enum.add_value "INT_VAR_MIN_MIN"
      enum.add_value "INT_VAR_MIN_MAX"
      enum.add_value "INT_VAR_MAX_MIN"
      enum.add_value "INT_VAR_MAX_MAX"
      enum.add_value "INT_VAR_SIZE_MIN"
      enum.add_value "INT_VAR_SIZE_MAX"
      enum.add_value "INT_VAR_DEGREE_MAX"
      enum.add_value "INT_VAR_DEGREE_MIN"
      enum.add_value "INT_VAR_REGRET_MIN_MIN"
      enum.add_value "INT_VAR_REGRET_MIN_MAX"
      enum.add_value "INT_VAR_REGRET_MAX_MIN"
      enum.add_value "INT_VAR_REGRET_MAX_MAX"
    end
    
    ns.add_enum "IntValBranch" do |enum|
      enum.add_value "INT_VAL_MIN"
      enum.add_value "INT_VAL_MED"
      enum.add_value "INT_VAL_MAX"
      enum.add_value "INT_VAL_SPLIT_MIN"
      enum.add_value "INT_VAL_SPLIT_MAX"
    end    
    
    ns.add_enum "SetVarBranch" do |enum|
      enum.add_value "SET_VAR_NONE"
      enum.add_value "SET_VAR_MIN_CARD"
      enum.add_value "SET_VAR_MAX_CARD"
      enum.add_value "SET_VAR_MIN_UNKNOWN_ELEM"
      enum.add_value "SET_VAR_MAX_UNKNOWN_ELEM"
    end
    
    ns.add_enum "SetValBranch" do |enum|
      enum.add_value "SET_VAL_MIN"
      enum.add_value "SET_VAL_MAX"
    end
    
    ns.add_enum "IntRelType" do |enum|
      enum.add_value "IRT_EQ"
      enum.add_value "IRT_NQ"
      enum.add_value "IRT_LQ"
      enum.add_value "IRT_LE"
      enum.add_value "IRT_GQ"
      enum.add_value "IRT_GR"
    end
    
    ns.add_enum "BoolOpType" do |enum|
      enum.add_value "BOT_AND"
      enum.add_value "BOT_OR"
      enum.add_value "BOT_IMP"
      enum.add_value "BOT_EQV"
      enum.add_value "BOT_XOR"
    end
    
    ns.add_enum "SetRelType" do |enum|
      enum.add_value "SRT_EQ"
      enum.add_value "SRT_NQ"
      enum.add_value "SRT_SUB"
      enum.add_value "SRT_SUP"
      enum.add_value "SRT_DISJ"
      enum.add_value "SRT_CMPL"
    end
    
    ns.add_enum "SetOpType" do |enum|
      enum.add_value "SOT_UNION"
      enum.add_value "SOT_DUNION"
      enum.add_value "SOT_INTER"
      enum.add_value "SOT_MINUS"
    end
    
    ns.add_enum "IntConLevel" do |enum|
      enum.add_value "ICL_VAL"
      enum.add_value "ICL_BND"
      enum.add_value "ICL_DOM"
      enum.add_value "ICL_DEF"
    end
    
    ns.add_enum "PropKind" do |enum|
      enum.add_value "PK_DEF"
      enum.add_value "PK_SPEED"
      enum.add_value "PK_MEMORY"
    end
    
    ns.add_enum "SpaceStatus" do |enum|
      enum.add_value "SS_FAILED"
      enum.add_value "SS_SOLVED"
      enum.add_value "SS_BRANCH"
    end
    
    ns.add_enum "IntAssign" do |enum|
      enum.add_value "INT_ASSIGN_MIN"
      enum.add_value "INT_ASSIGN_MED"
      enum.add_value "INT_ASSIGN_MAX"
    end
    
    ns.add_cxx_class "MIntVarArray" do |klass|
      klass.bindname = "IntVarArray"
      klass.function_mark = 'Gecode_MIntVarArray_custom_mark'
      
      klass.add_constructor
      klass.add_constructor do |func|
        func.add_parameter "Gecode::MSpace *", "home"
        func.add_parameter "int", "n"
      end
      
      klass.add_constructor do |func|
        func.add_parameter "Gecode::MSpace *", "home"
        func.add_parameter "int", "n"
        func.add_parameter "int", "min"
        func.add_parameter "int", "max"
      end
      
      klass.add_constructor do |func|
        func.add_parameter "Gecode::MSpace *", "home"
        func.add_parameter "int", "n"
        func.add_parameter "Gecode::IntSet", "s"
      end
      
      klass.add_method "at", "Gecode::IntVar&" do |method|
        method.add_parameter "int", "index"
      end
      
      klass.add_operator "[]", "Gecode::IntVar&" do |method|
        method.add_parameter "int", "index"
      end
      
      klass.add_operator "[]=", "Gecode::IntVar&" do |method|
        method.add_parameter "int", "index"
        method.add_parameter "Gecode::IntVar", "val"
      end
      
      klass.add_method "enlargeArray" do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "int", "n"
      end
      
      klass.add_method "size", "int"
      
      klass.add_method "debug"
      
    end
    
    
    ns.add_cxx_class "MBoolVarArray" do |klass|
      klass.bindname = "BoolVarArray"
      klass.function_mark = 'Gecode_MBoolVarArray_custom_mark'
      
      klass.add_constructor
      klass.add_constructor do |func|
        func.add_parameter "Gecode::MSpace *", "home"
        func.add_parameter "int", "n"
      end
      
      klass.add_method "at", "Gecode::BoolVar&" do |method|
        method.add_parameter "int", "index"
      end
      
      klass.add_operator "[]", "Gecode::BoolVar&" do |method|
        method.add_parameter "int", "index"
      end
      
      klass.add_operator "[]=", "Gecode::BoolVar&" do |method|
        method.add_parameter "int", "index"
        method.add_parameter "Gecode::BoolVar", "val"
      end
      
      klass.add_method "enlargeArray" do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "int", "n"
      end
      
      klass.add_method "size", "int"
      
      klass.add_method "debug"
      
    end
    
    ns.add_cxx_class "MSetVarArray" do |klass|
      klass.bindname = "SetVarArray"
      klass.function_mark = 'Gecode_MSetVarArray_custom_mark'
      
      klass.add_constructor
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "int", "n"
      end
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "int", "n"
        method.add_parameter "int", "glbMin"
        method.add_parameter "int", "glbMax"
        method.add_parameter "int", "lubMin"
        method.add_parameter "int", "lubMax"
        method.add_parameter "int", "minCard"
        method.add_parameter "int", "maxCard"
      end
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "int", "n"
        method.add_parameter "Gecode::IntSet", "glb"
        method.add_parameter "int", "lubMin"
        method.add_parameter "int", "lubMax"
        method.add_parameter "int", "minCard", true
        method.add_parameter "int", "maxCard", true
      end
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "int", "n"
        method.add_parameter "int", "glbMin"
        method.add_parameter "int", "glbMax"
        method.add_parameter "Gecode::IntSet", "lub"
        method.add_parameter "int", "minCard", true
        method.add_parameter "int", "maxCard", true
      end
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "int", "n"
        method.add_parameter "Gecode::IntSet", "glb"
        method.add_parameter "Gecode::IntSet", "lub"
        method.add_parameter "int", "minCard", true
        method.add_parameter "int", "maxCard", true
      end
      
      klass.add_method "at", "Gecode::SetVar&" do |method|
        method.add_parameter "int", "index"
      end
      
      klass.add_operator "[]", "Gecode::SetVar&" do |method|
        method.add_parameter "int", "index"
      end
      
      klass.add_operator "[]=", "Gecode::SetVar&" do |method|
        method.add_parameter "int", "index"
        method.add_parameter "Gecode::SetVar", "val"
      end
      
      klass.add_method "enlargeArray" do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "int", "n"
      end
      
      klass.add_method "size", "int"
      
      klass.add_method "debug"
    end
    
    ns.add_cxx_class "TupleSet" do |klass|
      klass.add_constructor
      
      klass.add_method "add" do |method|
        method.add_parameter "Gecode::IntArgs", "tuple"
      end
      
      klass.add_method "finalize"
      
      klass.add_method "finalized", "bool"
      
      klass.add_method "tuples", "int"
    end
    
    ns.add_cxx_class "MSpace" do |klass|
      klass.bindname = "Space"
      klass.function_mark = 'Gecode_MSpace_custom_mark'
      
      klass.add_constructor

      klass.add_method "constrain" do |method|
        method.add_parameter "Gecode::MSpace*", "s"
      end
      
      klass.add_method "new_int_var", "int" do |method|
        method.add_parameter "int", "min"
        method.add_parameter "int", "max"
      end
      
      klass.add_method "new_int_var", "int" do |method|
        method.add_parameter "Gecode::IntSet", "domain"
      end

      klass.add_method "new_bool_var", "int" do |method|
      end

      klass.add_method "new_set_var", "int" do |method|
        method.add_parameter "Gecode::IntSet", "glb"
        method.add_parameter "Gecode::IntSet", "lub"
        method.add_parameter "int", "cardMin"
        method.add_parameter "int", "cardMax"
      end

      klass.add_method "int_var", "Gecode::IntVar*" do |method|
        method.add_parameter "int", "id"
      end

      klass.add_method "bool_var", "Gecode::BoolVar*" do |method|
        method.add_parameter "int", "id"
      end
      
      klass.add_method "set_var", "Gecode::SetVar*" do |method|
        method.add_parameter "int", "id"
      end

      klass.add_method "clone", "Gecode::MSpace *" do |method|
        method.add_parameter "bool", "shared"
      end
      
      klass.add_method "status", "int"
      
      klass.add_method "propagators", "int"
      klass.add_method "branchings", "int"
      klass.add_method "failed", "bool"
      
      # The description method is commented out because it overlaps with the 
      # description method used by rspec, and isn't used directly in the 
      # interface.
      #klass.add_method "mdescription", "Gecode::MBranchingDesc *", "description"
    end
    
    # The namespace structure doesn't completely mimic Gecode's namespace 
    # structure. This is because there's apparently some limitation that 
    # prevents two namespaces from having the same name (Limits), regardless
    # of if they have the same parent or not. 
    ns.add_namespace "IntLimits" do |limitsns|
      limitsns.add_constant "MAX", "Gecode::Int::Limits::max"
      limitsns.add_constant "MIN", "Gecode::Int::Limits::min"
    end

    ns.add_namespace "SetLimits" do |limitsns|
      limitsns.add_constant "MAX", "Gecode::Set::Limits::max"
      limitsns.add_constant "MIN", "Gecode::Set::Limits::min"
      limitsns.add_constant "CARD", "Gecode::Set::Limits::card"
    end
    
    ns.add_cxx_class "IntSet" do |klass|
      klass.add_constructor do |method|
        method.add_parameter "int", "min"
        method.add_parameter "int", "max"
      end
      
      klass.add_constructor do |method|
        method.add_parameter "int []", "r"
        method.add_parameter "int", "n"
      end
      
      klass.add_method "size", "int"
      
      klass.add_method "width", "unsigned int" do |method|
        method.add_parameter "int", "i"
      end
      
      klass.add_method "max", "int" do |method|
        method.add_parameter "int", "i"
      end
      
      klass.add_method "min", "int" do |method|
        method.add_parameter "int", "i"
      end
      
      klass.add_constant "Empty", "(Gecode::IntSet *)&Gecode::IntSet::empty"
    end
    
    ns.add_cxx_class "IntVar" do |klass|
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "int", "min"
        method.add_parameter "int", "max"
      end
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "Gecode::IntSet", "s"
      end
      
      klass.add_method "max", "int"
      
      klass.add_method "min", "int"
      klass.add_method "med", "int"
      klass.add_method "val", "int"
      klass.add_method "size", "unsigned int"
      klass.add_method "width", "unsigned int"
      klass.add_method "degree", "unsigned int"
      
      klass.add_method "range", "bool"
      klass.add_method "assigned", "bool"
      klass.add_method "in", "bool" do |method|
        method.add_parameter "int", "n"
      end
      
      klass.add_method "update" do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "bool", "share"
        method.add_parameter "Gecode::IntVar", "x"
      end
      
      klass.add_operator "+", "Gecode::MiniModel::LinExpr<Gecode::IntVar>" do |operator|
        operator.add_parameter("int", "i")
      end
      
      klass.add_operator "-", "Gecode::MiniModel::LinExpr<Gecode::IntVar>" do |operator|
        operator.add_parameter("int", "i")
      end
      
      klass.add_operator "*", "Gecode::MiniModel::LinExpr<Gecode::IntVar>" do |operator|
        operator.add_parameter("int", "i")
      end
      
      klass.add_operator "!=", "Gecode::MiniModel::LinRel<Gecode::IntVar>", "different" do |operator|
        operator.add_parameter("Gecode::IntVar", "other")
      end
      
      klass.add_operator "==", "Gecode::MiniModel::LinRel<Gecode::IntVar>", "equal" do |operator|
        operator.add_parameter("Gecode::IntVar", "other")
      end
      
    end
    
    ns.add_cxx_class "BoolVar" do |klass|
      klass.add_constructor
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "int", "min"
        method.add_parameter "int", "max"
      end
      
      klass.add_method "max", "int"
      
      klass.add_method "min", "int"
      klass.add_method "med", "int"
      klass.add_method "val", "int"
      klass.add_method "size", "unsigned int"
      klass.add_method "width", "unsigned int"
      klass.add_method "degree", "unsigned int"
      
      klass.add_method "range", "bool"
      klass.add_method "assigned", "bool"
      klass.add_method "in", "bool" do |method|
        method.add_parameter "int", "n"
      end
      
      klass.add_method "update", "void" do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "bool", "share"
        method.add_parameter "Gecode::BoolVar", "x"
      end
      
      klass.add_operator "+", "Gecode::MiniModel::LinExpr<Gecode::BoolVar>" do |operator|
        operator.add_parameter("int", "i")
      end
      
      klass.add_operator "-", "Gecode::MiniModel::LinExpr<Gecode::BoolVar>" do |operator|
        operator.add_parameter("int", "i")
      end
      
      klass.add_operator "*", "Gecode::MiniModel::LinExpr<Gecode::BoolVar>" do |operator|
        operator.add_parameter("int", "i")
      end
      
      klass.add_operator "!=", "Gecode::MiniModel::LinRel<Gecode::BoolVar>", "different" do |operator|
        operator.add_parameter("Gecode::BoolVar", "other")
      end
      
      klass.add_operator "==", "Gecode::MiniModel::LinRel<Gecode::BoolVar>", "equal" do |operator|
        operator.add_parameter("Gecode::BoolVar", "other")
      end
    end
    
    ns.add_cxx_class "SetVar" do |klass|
      klass.add_constructor
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace*", "home"
      end
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "int", "glbMin"
        method.add_parameter "int", "glbMax"
        method.add_parameter "int", "lubMin"
        method.add_parameter "int", "lubMax"
        method.add_parameter "int", "cardMin"
        method.add_parameter "int", "cardMax"
      end
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "Gecode::IntSet", "glbD"
        method.add_parameter "int", "lubMin"
        method.add_parameter "int", "lubMax"
        method.add_parameter "int", "cardMin", true
        method.add_parameter "int", "cardMax", true
      end
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "int", "glbMin"
        method.add_parameter "int", "glbMax"
        method.add_parameter "Gecode::IntSet", "lubD"
        method.add_parameter "int", "cardMin", true
        method.add_parameter "int", "cardMax", true
      end
      
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace*", "home"
        method.add_parameter "Gecode::IntSet", "glbD"
        method.add_parameter "Gecode::IntSet", "lubD"
        method.add_parameter "int", "cardMin", true
        method.add_parameter "int", "cardMax", true
      end
      
      klass.add_method "glbSize", "int"
      klass.add_method "lubSize", "int"
      klass.add_method "unknownSize", "int"
      klass.add_method "cardMin", "int"
      klass.add_method "cardMax", "int"
      klass.add_method "lubMin", "int"
      klass.add_method "lubMax", "int"
      klass.add_method "glbMin", "int"
      klass.add_method "glbMax", "int"
      klass.add_method "glbSize", "int"
      klass.add_method "contains", "bool" do |method|
        method.add_parameter "int", "i"
      end
      
      klass.add_method "notContains", "bool" do |method|
        method.add_parameter "int", "i"
      end
      
      klass.add_method "assigned", "bool"
      
      klass.add_method "update" do |method|
        method.add_parameter "Gecode::MSpace *", "home"
        method.add_parameter "bool", "shared"
        method.add_parameter "Gecode::SetVar", "x"
      end
    end
    
    ns.add_cxx_class "MDFS" do |klass|
      klass.bindname = "DFS"
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace *", "s"
        method.add_parameter "Gecode::Search::Options", "o"
      end
      
      klass.add_method "next", "Gecode::MSpace *"
      klass.add_method "stopped", "bool"
      klass.add_method "statistics", "Gecode::Search::Statistics"
    end
    
    ns.add_cxx_class "MBAB" do |klass|
      klass.bindname = "BAB"
      klass.add_constructor do |method|
        method.add_parameter "Gecode::MSpace *", "s"
        method.add_parameter "Gecode::Search::Options", "o"
      end
      
      klass.add_method "next", "Gecode::MSpace *"
      klass.add_method "stopped", "bool"
      klass.add_method "statistics", "Gecode::Search::Statistics"
    end

    ns.add_cxx_class "DFA" do |klass|
      klass.add_constructor
    end

    ns.add_cxx_class "REG" do |klass|
      klass.add_constructor

      klass.add_constructor do |method|
        method.add_parameter "int", "s"
      end

      klass.add_constructor do |method|
        method.add_parameter "Gecode::IntArgs&", "x"
      end

      klass.add_constructor do |method|
        method.add_parameter "Gecode::REG&", "r"
      end

      klass.add_operator "+", "Gecode::REG" do |operator|
        operator.add_parameter "Gecode::REG&", "r"
      end

      klass.add_operator "+=", "Gecode::REG&" do |operator|
        operator.add_parameter "Gecode::REG&", "r"
      end

      klass.add_operator "|", "Gecode::REG" do |operator|
        operator.add_parameter "Gecode::REG&", "r"
      end
      
      klass.add_operator "|=", "Gecode::REG&" do |operator|
        operator.add_parameter "Gecode::REG&", "r"
      end
      
      klass.add_operator "*", "Gecode::REG" do |operator|
      end
      
      klass.add_operator "+", "Gecode::REG" do |operator|
      end

      klass.add_operator "()", "Gecode::REG" do |operator|
        operator.add_parameter "int", "n"
        operator.add_parameter "int", "m"
      end

      klass.add_operator "()", "Gecode::REG" do |operator|
        operator.add_parameter "int", "n"
      end
    end
    
    # SEARCH NAMESPACE
    
    ns.add_namespace "Search" do |searchns|
      searchns.add_cxx_class "MStop" do |klass|
        klass.bindname = "Stop"
        klass.add_constructor
        klass.add_constructor do |method|
          method.add_parameter "int", "fails"
          method.add_parameter "int", "time"
          method.add_parameter "int", "mem"
        end
      end
      
      searchns.add_cxx_class "Statistics" do |klass|
        klass.add_constructor
        klass.add_attribute "memory", "int"
        klass.add_attribute "propagate", "int"
        klass.add_attribute "fail", "int"
        klass.add_attribute "clone", "int"
        klass.add_attribute "commit", "int"
      end
      
      searchns.add_cxx_class "Options" do |klass|
        klass.add_constructor
        klass.add_attribute "c_d", "int"
        klass.add_attribute "a_d", "int"
        klass.add_attribute "stop", "Gecode::Search::MStop*"
      end
      
      searchns.add_namespace "Config" do |intns|
        intns.add_constant "ADAPTIVE_DISTANCE", "Gecode::Search::Config::a_d"
        intns.add_constant "MINIMAL_DISTANCE", "Gecode::Search::Config::c_d"
      end
    end
    
    # MINIMODEL NAMESPACE
    
    ns.add_namespace "MiniModel" do |minimodelns|
      ['Gecode::IntVar', 'Gecode::BoolVar'].each do |template_type|
        minimodelns.add_cxx_class "LinExpr<#{template_type}>" do |klass|
          klass.add_constructor

          klass.add_constructor do |method|
            method.add_parameter "#{template_type}&", "x"
            method.add_parameter "int", "a", true
          end
        
          klass.add_method "post" do |method|
            method.add_parameter "Gecode::MSpace *", "home"
            method.add_parameter "Gecode::IntRelType", "irt"
            method.add_parameter "Gecode::IntConLevel", "icl"
            method.add_parameter "Gecode::PropKind", "pk"
          end
          
          klass.add_method "post" do |method|
            method.add_parameter "Gecode::MSpace *", "home"
            method.add_parameter "Gecode::IntRelType", "irt"
            method.add_parameter "Gecode::BoolVar", "b"
            method.add_parameter "Gecode::IntConLevel", "icl"
            method.add_parameter "Gecode::PropKind", "pk"
          end
          
          klass.add_operator "+", "Gecode::MiniModel::LinExpr<#{template_type}>" do |operator|
            operator.add_parameter("Gecode::MiniModel::LinExpr<#{template_type}>", "exp")
          end
          
          klass.add_operator "+", "Gecode::MiniModel::LinExpr<#{template_type}>" do |operator|
            operator.add_parameter(template_type, "exp")
          end
          
          klass.add_operator "+", "Gecode::MiniModel::LinExpr<#{template_type}>" do |operator|
            operator.add_parameter("int", "c")
          end
          
          klass.add_operator "-", "Gecode::MiniModel::LinExpr<#{template_type}>" do |operator|
            operator.add_parameter("Gecode::MiniModel::LinExpr<#{template_type}>", "exp")
          end
          
          klass.add_operator "-", "Gecode::MiniModel::LinExpr<#{template_type}>" do |operator|
            operator.add_parameter(template_type, "exp")
          end
          
          klass.add_operator "-", "Gecode::MiniModel::LinExpr<#{template_type}>" do |operator|
            operator.add_parameter("int", "c")
          end
          
          klass.add_operator "*", "Gecode::MiniModel::LinExpr<#{template_type}>" do |operator|
            operator.add_parameter("int", "c")
          end
          
          klass.add_operator "==", "Gecode::MiniModel::LinRel<#{template_type}>", "equal" do |operator|
            operator.add_parameter "Gecode::MiniModel::LinExpr<#{template_type}>", "other"
          end
          
          klass.add_operator "!=", "Gecode::MiniModel::LinRel<#{template_type}>", "different" do |operator|
            operator.add_parameter "Gecode::MiniModel::LinExpr<#{template_type}>", "other"
          end
        end
      end
      
      minimodelns.add_cxx_class "BoolExpr" do |klass| # TODO
        klass.add_enum "NodeType" do |enum|
          enum.add_value "NT_VAR"
          enum.add_value "NT_NOT"
          enum.add_value "NT_AND"
          enum.add_value "NT_OR"
          enum.add_value "NT_IMP"
          enum.add_value "NT_XOR"
          enum.add_value "NT_EQV"
          enum.add_value "NT_RLIN_INT"
          enum.add_value "NT_RLIN_BOOL"
        end
        klass.add_constructor do |method|
          method.add_parameter "Gecode::MiniModel::BoolExpr", "e"
        end
        
        klass.add_constructor do |method|
          method.add_parameter "Gecode::BoolVar", "e"
        end
        
        klass.add_constructor do |method|
          method.add_parameter "Gecode::MiniModel::BoolExpr", "l"
          method.add_parameter "Gecode::MiniModel::BoolExpr::NodeType", "t"
          method.add_parameter "Gecode::MiniModel::BoolExpr", "r"
        end
        
        klass.add_constructor do |method|
          method.add_parameter "Gecode::MiniModel::BoolExpr", "l"
          method.add_parameter "Gecode::MiniModel::BoolExpr::NodeType", "t"
        end
        
        klass.add_constructor do |method|
          method.add_parameter "Gecode::MiniModel::LinRel<Gecode::IntVar>", "e"
        end
        
        klass.add_constructor do |method|
          method.add_parameter "Gecode::MiniModel::LinRel<Gecode::BoolVar>", "e"
        end        
        
        klass.add_method "post", "Gecode::BoolVar" do |method|
          method.add_parameter "Gecode::MSpace *", "home"
          method.add_parameter "Gecode::IntConLevel", "icl"
          method.add_parameter "Gecode::PropKind", "pk"
        end
        
        klass.add_method "post" do |method|
          method.add_parameter "Gecode::MSpace *", "home"
          method.add_parameter "bool", "t"
          method.add_parameter "Gecode::IntConLevel", "icl"
          method.add_parameter "Gecode::PropKind", "pk"
        end
      end
      
      minimodelns.add_cxx_class "BoolRel" do |klass|
        klass.add_constructor do |method|
          method.add_parameter "Gecode::MiniModel::BoolExpr", "e"
          method.add_parameter "bool", "t"
        end
      end
      
      ['Gecode::IntVar', 'Gecode::BoolVar'].each do |template_type|
        minimodelns.add_cxx_class "LinRel<#{template_type}>" do |klass|
          klass.add_constructor
        
          klass.add_constructor do |method|
            method.add_parameter "Gecode::MiniModel::LinExpr<#{template_type}>", "l"
            method.add_parameter "Gecode::IntRelType", "irt"
            method.add_parameter "Gecode::MiniModel::LinExpr<#{template_type}>", "r"
          end
        
          klass.add_constructor do |method|
            method.add_parameter "Gecode::MiniModel::LinExpr<#{template_type}>", "l"
            method.add_parameter "Gecode::IntRelType", "irt"
            method.add_parameter "int", "r"
          end
          
          klass.add_constructor do |method|
            method.add_parameter "int", "l"
            method.add_parameter "Gecode::IntRelType", "irt"
            method.add_parameter "Gecode::MiniModel::LinExpr<#{template_type}>", "r"
          end
          
          klass.add_method "post", "void" do |method|
            method.add_parameter "Gecode::MSpace*", "home"
            method.add_parameter "bool", "t"
            method.add_parameter "Gecode::IntConLevel", "icl"
            method.add_parameter "Gecode::PropKind", "pk"
          end
          
          klass.add_method "post", "void" do |method|
            method.add_parameter "Gecode::MSpace*", "home"
            method.add_parameter "Gecode::BoolVar", "b"
            method.add_parameter "Gecode::IntConLevel", "icl"
            method.add_parameter "Gecode::PropKind", "pk"
          end
        end
      end
    end
    
    
    
    # INT POSTING FUNCTIONS
    
    ns.add_function "abs" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntVar", "x1"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "max" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntVar", "x1"
      func.add_parameter "Gecode::IntVar", "x2"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "max" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::MIntVarArray", "arr" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 1)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "min" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntVar", "x1"
      func.add_parameter "Gecode::IntVar", "x2"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "min" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::MIntVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 1)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "mult" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntVar", "x1"
      func.add_parameter "Gecode::IntVar", "x2"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "sqr" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntVar", "x1"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "sqrt" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntVar", "x1"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "branch" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::MIntVarArray *", "iva" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVarBranch", "vars"
      func.add_parameter "Gecode::IntValBranch", "vals"
    end
    
    ns.add_function "branch" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::MBoolVarArray *", "iva" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVarBranch", "vars"
      func.add_parameter "Gecode::IntValBranch", "vals"
    end
    
    ns.add_function "branch" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::MSetVarArray *", "sva" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::SetVarBranch", "vars"
      func.add_parameter "Gecode::SetValBranch", "vals"
    end
    
    ns.add_function "assign" do |func|
      func.add_parameter "Gecode::MSpace *", "home"
      func.add_parameter "Gecode::MIntVarArray *", "iva" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(iva, 1)->ptr()"
      end
      func.add_parameter "Gecode::IntAssign", "vals"
    end
    
    ns.add_function "channel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::MIntVarArray *", "y" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "channel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::BoolVar", "x1"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "channel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "int", "o"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "count" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      
      func.add_parameter "int", "y"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "count" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "count" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      
      func.add_parameter "int", "y"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "count" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "distinct" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "iva" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "distinct" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntArgs", "x"
      func.add_parameter "Gecode::MIntVarArray *", "iva" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x"
      func.add_parameter "int", "l"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "iva" do |param|
        param.custom_conversion = "*reinterpret_cast<Gecode::IntVarArgs *>(ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr())"
      end
      func.add_parameter "int", "l"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x"
      func.add_parameter "Gecode::IntSet", "s"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "iva" do |param|
        param.custom_conversion = "*reinterpret_cast<Gecode::IntVarArgs *>(ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr())"
      end
      func.add_parameter "Gecode::IntSet", "s"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x"
      func.add_parameter "int", "l"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::BoolVar", "b"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x"
      func.add_parameter "Gecode::IntSet", "s"
      func.add_parameter "Gecode::BoolVar", "b"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "element", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntArgs&", "x"
      func.add_parameter "Gecode::IntVar", "y0"
      func.add_parameter "Gecode::IntVar", "y1"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "element", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "iva" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "y0"
      func.add_parameter "Gecode::IntVar", "y1"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "c"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "c"
      func.add_parameter "Gecode::BoolVar", "b"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntArgs", "a"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "c"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntArgs", "a"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "c"
      func.add_parameter "Gecode::BoolVar", "b"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "c"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "c"
      func.add_parameter "Gecode::BoolVar", "b"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntArgs", "a"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntArgs", "a"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::BoolVar", "b"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "y"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "linear", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "extensional", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::TupleSet", "t"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "extensional", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::TupleSet", "t"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
  
    ns.add_function "extensional", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::REG", "dfa" 
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end

    ns.add_function "extensional", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::REG", "dfa" 
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "bab", "Gecode::MSpace*" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::Search::Options", "o"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "c"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "x1"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "x1"
      func.add_parameter "Gecode::BoolVar", "b"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x0"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "c"
      func.add_parameter "Gecode::BoolVar", "b"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end

    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::MIntVarArray *", "y" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[3], 4)->ptr()"
      end
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::BoolVar", "x0"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "int", "c"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::BoolVar", "x0"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::BoolVar", "x1"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::BoolVar", "x0"
      func.add_parameter "Gecode::BoolOpType", "o"
      func.add_parameter "Gecode::BoolVar", "x1"
      func.add_parameter "Gecode::BoolVar", "x2"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::BoolVar", "x0"
      func.add_parameter "Gecode::BoolOpType", "o"
      func.add_parameter "Gecode::BoolVar", "x1"
      func.add_parameter "int", "n"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::BoolOpType", "o"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[2], 2)->ptr()"
      end
      func.add_parameter "int", "n"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::BoolOpType", "o"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[2], 2)->ptr()"
      end
      func.add_parameter "Gecode::BoolVar", "y"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end

    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MBoolVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::MBoolVarArray *", "y" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[3], 4)->ptr()"
      end
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end    

    ns.add_function "sorted", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::MIntVarArray *", "y" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "sorted", "void" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::MIntVarArray *", "y" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::MIntVarArray *", "z" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[3], 4)->ptr()"
      end
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "post", "Gecode::BoolVar" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MiniModel::BoolExpr", "e"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "post", "Gecode::BoolVar" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::BoolVar", "e"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "post" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MiniModel::BoolRel", "r"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "post", "Gecode::IntVar" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "e"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "post", "Gecode::IntVar" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "int", "n"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "post", "Gecode::IntVar" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MiniModel::LinExpr<Gecode::IntVar>", "e"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "post" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MiniModel::LinRel<Gecode::IntVar>", "e"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "post" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "bool", "r"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "atmost" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "int", "n"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "atmost" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "n"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "atmost" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "int", "n"
      func.add_parameter "Gecode::IntVar", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "atmost" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "n"
      func.add_parameter "Gecode::IntVar", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "atleast" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "int", "n"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "atleast" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "n"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "atleast" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "int", "n"
      func.add_parameter "Gecode::IntVar", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "atleast" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "n"
      func.add_parameter "Gecode::IntVar", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "exactly" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "int", "n"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "exactly" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "n"
      func.add_parameter "int", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "exactly" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "int", "n"
      func.add_parameter "Gecode::IntVar", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "exactly" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "n"
      func.add_parameter "Gecode::IntVar", "m"
      func.add_parameter "Gecode::IntConLevel", "icl"
      func.add_parameter "Gecode::PropKind", "pk"
    end
    
    ns.add_function "lex" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray *", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::MIntVarArray *", "y" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[3], 4)->ptr()"
      end
      func.add_parameter "Gecode::IntConLevel", "icl", true
      func.add_parameter "Gecode::PropKind", "pk", true
    end
    
    ns.add_function "cardinality" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "int", "i"
      func.add_parameter "int", "j"
    end
    
    ns.add_function "cardinality" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "s"
      func.add_parameter "Gecode::IntVar", "x"
    end
    
    ns.add_function "convex" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "s"
    end
    
    ns.add_function "convexHull" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetVar", "y"
    end
    
    ns.add_function "atmostOne" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MSetVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(x, 2)->ptr()"
      end
      func.add_parameter "int", "c"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "int", "i"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "int", "i"
      func.add_parameter "int", "j"
    end
    
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::IntSet", "s"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "int", "i"
      func.add_parameter "Gecode::BoolVar", "b"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "int", "i"
      func.add_parameter "int", "j"
      func.add_parameter "Gecode::BoolVar", "b"
    end
    
    ns.add_function "dom" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::IntSet", "s"
      func.add_parameter "Gecode::BoolVar", "b"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "s"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::IntVar", "x"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x"
      func.add_parameter "Gecode::IntRelType", "r"
      func.add_parameter "Gecode::SetVar", "s"
    end
    
    ns.add_function "min" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "s"
      func.add_parameter "Gecode::IntVar", "x"
    end
    
    ns.add_function "max" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "s"
      func.add_parameter "Gecode::IntVar", "x"
    end
    
    ns.add_function "match" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "s"
      func.add_parameter "Gecode::MIntVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(x, 3)->ptr()"
      end
    end
    
    ns.add_function "channel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MIntVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::MSetVarArray", "y" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(argv[2], 3)->ptr()"
      end
    end

    ns.add_function "channel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MBoolVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MBoolVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::SetVar", "y"
    end
    
    ns.add_function "weights" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntArgs", "elements"
      func.add_parameter "Gecode::IntArgs", "weights"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::IntVar", "y"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntSet", "x"
      func.add_parameter "Gecode::SetOpType", "op"
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::SetVar", "z"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetOpType", "op"
      func.add_parameter "Gecode::IntSet", "y"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::SetVar", "z"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetOpType", "op"
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::IntSet", "z"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntSet", "x"
      func.add_parameter "Gecode::SetOpType", "op"
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::IntSet", "z"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetOpType", "op"
      func.add_parameter "Gecode::IntSet", "y"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::IntSet", "z"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetOpType", "op"
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::SetVar", "z"
    end
    
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetOpType", "op"
      func.add_parameter "Gecode::MSetVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::SetVar", "y"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetOpType", "op"
      func.add_parameter "Gecode::MIntVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MIntVarArrayPtr(argv[2], 3)->ptr()"
      end
      func.add_parameter "Gecode::SetVar", "y"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::SetVar", "y"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::IntVar", "y"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::SetVar", "y"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::BoolVar", "b"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::SetVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::BoolVar", "b"
    end
    
    ns.add_function "rel" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::IntVar", "x"
      func.add_parameter "Gecode::SetRelType", "r"
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::BoolVar", "b"
    end
    
    ns.add_function "elementsUnion" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MSetVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(x, 2)->ptr()"
      end
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::SetVar", "z"
    end
    
    ns.add_function "elementsInter" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MSetVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::SetVar", "z"
    end
    
    ns.add_function "elementsInter" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MSetVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::SetVar", "y"
      func.add_parameter "Gecode::SetVar", "z"
      func.add_parameter "Gecode::IntSet", "universe"
    end
    
    ns.add_function "element" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MSetVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(argv[1], 2)->ptr()"
      end
      func.add_parameter "Gecode::IntVar", "y"
      func.add_parameter "Gecode::SetVar", "z"
    end
    
    ns.add_function "elementsDisjoint" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MSetVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(x, 2)->ptr()"
      end
      func.add_parameter "Gecode::SetVar", "y"
    end
    
    ns.add_function "sequence" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MSetVarArray", "x" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(x, 2)->ptr()"
      end
    end
    
    ns.add_function "sequentialUnion" do |func|
      func.add_parameter "Gecode::MSpace*", "home"
      func.add_parameter "Gecode::MSetVarArray", "y" do |param|
        param.custom_conversion = "*ruby2Gecode_MSetVarArrayPtr(y, 2)->ptr()"
      end
      func.add_parameter "Gecode::SetVar", "x"
    end
  end
end
