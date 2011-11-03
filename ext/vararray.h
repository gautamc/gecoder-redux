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

#ifndef _VARARRAY_H
#define _VARARRAY_H

#include <gecode/int.hh>
#include <gecode/set.hh>


namespace Gecode {

class MVarArray
{
	public:
		MVarArray();
		virtual ~MVarArray();
		virtual void enlargeArray(Gecode::Space *parent, int n = 1) = 0;
		
		int count() const;
		int size() const;
		
		void setCount(int c);
		void setSize(int n);
		
	private:
		struct Private;
		Private *const d;
};

class MIntVarArray : public MVarArray
{
	public:
		MIntVarArray();
		MIntVarArray(const Gecode::IntVarArray &arr);
		MIntVarArray(Space *home, int n);
		MIntVarArray(Space *home, int n, int min, int max);
		MIntVarArray(Space *home, int n, const IntSet &s);
		
		~MIntVarArray();
		
		void enlargeArray(Gecode::Space *parent, int n = 1);
		
		void setArray(const Gecode::IntVarArray &arr);
		Gecode::IntVarArray *ptr() const;
		
		Gecode::IntVar &at(int index);
		void push(const Gecode::IntVar& intvar);
		
		void debug() const;
		
		void gc_mark();
		
		IntVar &operator [](int index);
		
	private:
		struct Private;
		Private *const d;
};

class MBoolVarArray : public MVarArray
{
	public:
		MBoolVarArray();
		MBoolVarArray(const Gecode::BoolVarArray &arr);
		MBoolVarArray(Space *home, int n);

		~MBoolVarArray();
		
		void enlargeArray(Gecode::Space *parent, int n = 1);
		
		void setArray(const Gecode::BoolVarArray &arr);
		Gecode::BoolVarArray *ptr() const;
		
		Gecode::BoolVar &at(int index);
		Gecode::BoolVar &operator[](int index);
		
		void push(const Gecode::BoolVar& boolvar);
		
		void debug() const;
		
		void gc_mark();
		
	private:
		struct Private;
		Private *const d;
};



class MSetVarArray : public MVarArray
{
	public:
		MSetVarArray();
		MSetVarArray(const Gecode::SetVarArray &arr);
		
		MSetVarArray(Space *home, int n);
		MSetVarArray(Space *home, int n, int glbMin, int glbMax, int lubMin, int lubMax, unsigned int minCard=0, unsigned int maxCard=Set::Limits::card);
		
		MSetVarArray(Space *home, int n, const IntSet &glb, int lubMin, int lubMax, unsigned int minCard=0, unsigned int maxCard=Set::Limits::card);
		
		MSetVarArray(Space *home, int n, int glbMin, int glbMax, const IntSet &lub, unsigned int minCard=0, unsigned int maxCard=Set::Limits::card);
		
		MSetVarArray(Space *home, int n, const IntSet &glb, const IntSet &lub, unsigned int minCard=0, unsigned int maxCard=Set::Limits::card);
		
		~MSetVarArray();
		
		
		
		void enlargeArray(Gecode::Space *parent, int n = 1);
		
		void setArray(const Gecode::SetVarArray &arr);
		Gecode::SetVarArray *ptr() const;
		
		Gecode::SetVar &at(int index);
		Gecode::SetVar &operator[](int index);
		
		void push(const Gecode::SetVar& setvar);
		
		void debug() const;
		
		void gc_mark();
		
	private:
		struct Private;
		Private *const d;
};

}


#endif

