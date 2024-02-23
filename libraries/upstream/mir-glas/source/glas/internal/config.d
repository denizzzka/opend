/++
Copyright: Copyright © 2016-, Ilya Yaroshenko.
License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors: Ilya Yaroshenko
+/
module glas.internal.config;

import std.traits;
import std.meta;
import glas.internal.utility: isComplex;

mixin template RegisterConfig(size_t P, T)
    if (is(Unqual!T == T))
{
    static if (isFloatingPoint!T)
        version(X86)
            static if (__traits(targetHasFeature, "sse2"))
                mixin SSE2;
            else
                mixin FPU;
        else
        version(X86_64)
            static if (__traits(targetHasFeature, "avx512f"))
                mixin AVX512F;
            else
            static if (__traits(targetHasFeature, "avx"))
                mixin AVX;
            else
                mixin SSE2;
        else
            mixin M16;
    else
    static if (isIntegral!T)
        version(X86)
            static if (T.sizeof > size_t.sizeof)
                mixin M1;
            else
                mixin M4;
        else
            static if (T.sizeof > size_t.sizeof)
                mixin M4;
            else
                mixin M16;
    else
        mixin M1;
    enum _countOf(C) = C.sizeof / T.sizeof;
    alias nr_chain = BroadcastChain!_broadcast;
    alias mr_chain = staticMap!(_countOf, _simd_type_chain);
    enum size_t main_nr = _broadcast;
    enum size_t main_mr = _countOf!(_simd_type_chain[0]);
    alias Vi(size_t mri) = ForeachType!(_simd_type_chain[mri]);
    enum Mi(size_t mri) = _simd_type_chain[mri].length;
}

//private:

template BroadcastChain(size_t s)
{
    import std.traits: Select;
    import core.bitop: bsr;
    static assert(s);
    static if (s == 1)
    {
        alias BroadcastChain = AliasSeq!(s);
    }
    else
    {
        private enum trp2 = 1 << bsr(s);
        alias BroadcastChain = AliasSeq!(s, BroadcastChain!(Select!(trp2 == s, trp2 / 2, trp2)));
    }
}

mixin template AVX512F()
{
    static if (is(T == real))
        mixin M8;
    else
    static if (is(T == float))
        static if (P == 1)
            mixin AVX512_S;
        else
            mixin AVX512_C;
    else
    static if (is(T == double))
        static if (P == 1)
            mixin AVX512_D;
        else
            mixin AVX512_Z;
    else static assert(0);
}

// AVX and AVX2
mixin template AVX()
{
    static if (is(T == real))
        mixin M8;
    else
    static if (is(T == float))
        static if (P == 1)
            mixin AVX_S;
        else
            mixin AVX_C;
    else
    static if (is(T == double))
        static if (P == 1)
            mixin AVX_D;
        else
            mixin AVX_Z;
    else static assert(0);
}

mixin template SSE2()
{
    static if (is(T == real))
        mixin M8;
    else
    static if (is(T == float))
        static if (P == 1)
            mixin SSE2_S;
        else
            mixin SSE2_C;
    else
    static if (is(T == double))
        static if (P == 1)
            mixin SSE2_D;
        else
            mixin SSE2_Z;
    else static assert(0);
}

alias FPU = M8;

version(LDC_LLVM_300)
{
    enum six = 6;
}
else
{
    pragma(msg, "PERFORMANCE NOTE:
    =======================================================================
    LLVM >=4.0 has a bug in register renaming.
    Computation kernels are not optimal!
    For more details see issue https://github.com/libmir/mir-glas/issues/18
    =======================================================================");
    enum six = 5;
}

mixin template AVX512_S()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(float[16])[4], __vector(float[16])[2], __vector(float[16])[1], __vector(float[8])[1], __vector(float[4])[1], __vector(float[2])[1], float[1]);
}

mixin template AVX512_D()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(double[8])[4], __vector(double[8])[2], __vector(double[8])[1], __vector(double[4])[1], __vector(double[2])[1], double[1]);
}

mixin template AVX512_C()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(float[16])[2], __vector(float[16])[1], __vector(float[8])[1], __vector(float[4])[1], __vector(float[2])[1], float[1]);
}

mixin template AVX512_Z()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(double[8])[2], __vector(double[8])[1], __vector(double[4])[1], __vector(double[2])[1], double[1]);
}

mixin template AVX_S()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(float[8])[2], __vector(float[8])[1], __vector(float[4])[1], __vector(float[2])[1], float[1]);
}

mixin template AVX_D()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(double[4])[2], __vector(double[4])[1], __vector(double[2])[1], double[1]);
}

mixin template AVX_C()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(float[8])[1], __vector(float[4])[1], __vector(float[2])[1], float[1]);
}

mixin template AVX_Z()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(double[4])[1], __vector(double[2])[1], double[1]);
}

mixin template SSE2_S()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(float[4])[2], __vector(float[4])[1], __vector(float[2])[1], float[1]);
}

mixin template SSE2_D()
{
    enum size_t _broadcast = six;
    alias _simd_type_chain = AliasSeq!(__vector(double[2])[2], __vector(double[2])[1], double[1]);
}

mixin template SSE2_C()
{
    enum size_t _broadcast = 4;
    alias _simd_type_chain = AliasSeq!(__vector(float[4])[2], __vector(float[4])[1], __vector(float[2])[1], float[1]);
}

mixin template SSE2_Z()
{
    enum size_t _broadcast = 4;
    alias _simd_type_chain = AliasSeq!(__vector(double[2])[2], __vector(double[2])[1], double[1]);
}

mixin template M16()
{
    static if (P == 1)
    {
        enum size_t _broadcast = six;
        alias _simd_type_chain = AliasSeq!(T[2], T[1]);
    }
    else
    {
        enum size_t _broadcast = 2;
        alias _simd_type_chain = AliasSeq!(T[2], T[1]);
    }
}

mixin template M8()
{
    enum size_t _broadcast = 2;
    static if (P == 1)
        alias _simd_type_chain = AliasSeq!(T[2], T[1]);
    else
        alias _simd_type_chain = AliasSeq!(T[1]);
}

mixin template M4()
{
    enum size_t _broadcast = 1;
    static if (P == 1)
        alias _simd_type_chain = AliasSeq!(T[2], T[1]);
    else
        alias _simd_type_chain = AliasSeq!(T[1]);
}

mixin template M1()
{
    enum size_t _broadcast = 1;
    alias _simd_type_chain = AliasSeq!(T[1]);
}
