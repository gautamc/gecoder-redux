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

#include "vararray.h"
#include "gecode.hh"

namespace Gecode {


struct MVarArray::Private
{
	int count;
	int size;
};

MVarArray::MVarArray() : d(new Private)
{
}

MVarArray::~MVarArray()
{
	delete d;
}

int MVarArray::count() const
{
	return d->count;
}

int MVarArray::size() const
{
	return d->size;
}

void MVarArray::setCount(int c)
{
	d->count = c;
}

void MVarArray::setSize(int n)
{
	d->size = n;
}


// MINTVARARRAY

struct MIntVarArray::Private
{
	Gecode::IntVarArray array;
};


MIntVarArray::MIntVarArray() : d(new Private)
{
	setArray(Gecode::IntVarArray());
}

MIntVarArray::MIntVarArray(const Gecode::IntVarArray &arr) : d(new Private)
{
	setArray(arr);
}

MIntVarArray::MIntVarArray (Space *home, int n) : d(new Private)
{
	setArray(Gecode::IntVarArray(home, n));
}

MIntVarArray::MIntVarArray (Space *home, int n, int min, int max) : d(new Private)
{
	setArray(Gecode::IntVarArray(home, n, min, max));
}

MIntVarArray::MIntVarArray (Space *home, int n, const IntSet &s) : d(new Private)
{
	setArray(Gecode::IntVarArray(home, n, s));
}


MIntVarArray::~MIntVarArray()
{
	delete d;
}

void MIntVarArray::setArray(const Gecode::IntVarArray &arr)
{
	d->array = arr;
	setSize(arr.size());
}

void MIntVarArray::enlargeArray(Gecode::Space *parent, int n)
{
	Gecode::IntVarArray na(parent, size()+n, 0, 0);
	for(int i = size(); i--; )
		na[i] = d->array[i];
	
	d->array = na;
	
	setSize(size() + n);
}

Gecode::IntVarArray *MIntVarArray::ptr() const
{
	return &d->array;
}

Gecode::IntVar &MIntVarArray::at(int index)
{
	return d->array[index];
}

IntVar &MIntVarArray::operator [](int index)
{
	return d->array[index];
}

void MIntVarArray::gc_mark()
{
  for(int i = size(); i--; ) {
		rb_gc_mark(Rust_gecode::cxx2ruby(&(d->array[i]), false, false));
	}
}

void MIntVarArray::debug() const
{
	for(int i = 0; i < d->array.size(); i++)
	{
		std::cout << d->array[i] << " ";
	}
	std::cout << std::endl;
}


// MBOOLVARARRAY

struct MBoolVarArray::Private
{
	Gecode::BoolVarArray array;
};


MBoolVarArray::MBoolVarArray() : d(new Private)
{
	setArray(Gecode::BoolVarArray());
}

MBoolVarArray::MBoolVarArray(const Gecode::BoolVarArray &arr) : d(new Private)
{
	setArray(arr);
}

MBoolVarArray::MBoolVarArray (Space *home, int n) : d(new Private)
{
	setArray(Gecode::BoolVarArray(home, n));
}

MBoolVarArray::~MBoolVarArray()
{
	delete d;
}

void MBoolVarArray::setArray(const Gecode::BoolVarArray &arr)
{
	d->array = arr;
	setSize(arr.size());
}

void MBoolVarArray::enlargeArray(Gecode::Space *parent, int n)
{
	Gecode::BoolVarArray na(parent, size()+n, 0, 0);
	for(int i = size(); i--; )
		na[i] = d->array[i];
	
	d->array = na;
	
	setSize(size() + n);
}

Gecode::BoolVarArray *MBoolVarArray::ptr() const
{
	return &d->array;
}

Gecode::BoolVar &MBoolVarArray::at(int index)
{
	return d->array[index];
}

Gecode::BoolVar &MBoolVarArray::operator[](int index)
{
	return d->array[index];
}

void MBoolVarArray::gc_mark()
{
  for(int i = size(); i--; ) {
		rb_gc_mark(Rust_gecode::cxx2ruby(&(d->array[i]), false, false));
	}
}

void MBoolVarArray::debug() const
{
	for(int i = 0; i < d->array.size(); i++)
	{
		std::cout << d->array[i] << " ";
	}
	std::cout << std::endl;
}


// SETVARARRAY

struct MSetVarArray::Private
{
	Gecode::SetVarArray array;
};

MSetVarArray::MSetVarArray() : d(new Private)
{
	setArray(Gecode::SetVarArray());
}

MSetVarArray::MSetVarArray(const Gecode::SetVarArray &arr) : d(new Private)
{
	setArray(arr);
}

MSetVarArray::MSetVarArray(Space *home, int n) : d(new Private)
{
	setArray(Gecode::SetVarArray(home, n));
}

MSetVarArray::MSetVarArray(Gecode::Space *home, int n, int glbMin, int glbMax, int lubMin, int lubMax, unsigned int minCard, unsigned int maxCard) : d(new Private)
{
	setArray(Gecode::SetVarArray(home, n, glbMin, glbMax, lubMin, lubMax, minCard, maxCard));
}
		
MSetVarArray::MSetVarArray(Gecode::Space *home, int n, const Gecode::IntSet &glb, int lubMin, int lubMax, unsigned int minCard, unsigned int maxCard) : d(new Private)
{
	setArray(Gecode::SetVarArray(home, n, glb, lubMin, lubMax, minCard, maxCard));
}

MSetVarArray::MSetVarArray(Gecode::Space *home, int n, int glbMin, int glbMax, const Gecode::IntSet &lub, unsigned int minCard, unsigned int maxCard) : d(new Private)
{
	setArray(Gecode::SetVarArray(home, n, glbMin, glbMax, lub, minCard, maxCard));
}

MSetVarArray::MSetVarArray(Gecode::Space *home, int n, const Gecode::IntSet &glb, const Gecode::IntSet &lub, unsigned int minCard, unsigned int maxCard) : d(new Private)
{
	setArray(Gecode::SetVarArray(home, n, glb, lub, minCard, maxCard));
}

MSetVarArray::~MSetVarArray()
{
	delete d;
}

void MSetVarArray::setArray(const Gecode::SetVarArray &arr)
{
	d->array = arr;
	setSize(arr.size());
}

void MSetVarArray::enlargeArray(Gecode::Space *parent, int n)
{
	Gecode::SetVarArray na(parent, size()+n);
	for (int i = size(); i--; )
		na[i] = d->array[i];
	
	d->array = na;
	
	setSize(size() + n);
}

Gecode::SetVarArray *MSetVarArray::ptr() const
{
	return &d->array;
}

Gecode::SetVar &MSetVarArray::at(int index)
{
	return d->array[index];
}

Gecode::SetVar &MSetVarArray::operator[](int index)
{
	return d->array[index];
}

void MSetVarArray::gc_mark()
{
  for(int i = size(); i--; ) {
		rb_gc_mark(Rust_gecode::cxx2ruby(&(d->array[i]), false, false));
	}
}

void MSetVarArray::debug() const
{
	for(int i = 0; i < d->array.size(); i++)
	{
		std::cout << d->array[i] << " ";
	}
	std::cout << std::endl;
}


}







