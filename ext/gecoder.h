/**
 * Gecode/R, a Ruby interface to Gecode.
 * Copyright (C) 2007 The Gecode/R development team.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 **/

#ifndef __GECODER_H
#define __GECODER_H

#include <ruby.h>

#include <gecode/kernel.hh>
#include <gecode/int.hh>
#include <gecode/search.hh>
#include <gecode/minimodel.hh>
#include <gecode/set.hh>

#include "vararray.h"

namespace Gecode {
  class MSpace : public Space {
    public:
      MSpace();
      MSpace(bool share, MSpace& s);
      ~MSpace();
      Gecode::Space *copy(bool share);

      int new_int_var(int min, int max);
      int new_int_var(IntSet domain);
      Gecode::IntVar* int_var(int id);

      int new_bool_var();
      Gecode::BoolVar* bool_var(int id);

      int new_set_var(const IntSet& glb, const IntSet& lub, unsigned int card_min, unsigned int card_max);
      Gecode::SetVar* set_var(int id);

      void gc_mark();

      void constrain(MSpace* s);

    private:
      Gecode::IntVarArray int_variables;
      Gecode::BoolVarArray bool_variables;
      Gecode::SetVarArray set_variables;
  };
  
  class MDFS : public Gecode::DFS<MSpace> {
    public:
      MDFS(MSpace *space, const Search::Options &o);
      ~MDFS();
  };

  class MBAB : public Gecode::BAB<MSpace> {
    public:
      MBAB(MSpace* space, const Search::Options &o);
      ~MBAB();
  };

  namespace Search {
    class MStop : public Gecode::Search::Stop {
      public:
        MStop();
        MStop(int fails, int time, size_t mem);
        ~MStop();

        bool stop (const Gecode::Search::Statistics &s);

      private:
        struct Private;
        Private *const d;
    };
  }
}

#endif


