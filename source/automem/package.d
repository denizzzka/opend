module automem;


version(unittest) {
    import unit_threaded;
    import test_allocator;
}


struct Unique(Type, Allocator) {
    import std.traits: hasMember;
    import std.typecons: Proxy;

    enum hasInstance = hasMember!(Allocator, "instance");

    static if(is(Type == class))
        alias Pointer = Type;
    else
        alias Pointer = Type*;

    static if(hasInstance)
        /**
           The allocator is a singleton, so no need to pass it in to the
           constructor
         */
        this(Args...)(auto ref Args args) {
            makeObject(args);
        }
    else
        /**
           Non-singleton allocator, must be passed in
         */
        this(Args...)(Allocator allocator, auto ref Args args) {
            _allocator = allocator;
            makeObject(args);
        }

    this(T)(Unique!(T, Allocator) other) if(is(T: Type)) {
        moveFrom(other);
    }

    @disable this(this);

    ~this() {
        deleteObject;
    }

    inout(Pointer) get() @safe pure nothrow inout {
        return _object;
    }

    Unique unique() {
        import std.algorithm: move;
        Unique u;
        move(this, u);
        assert(_object is null);
        return u;
    }

    Pointer release() @safe pure nothrow {
        auto ret = _object;
        _object = null;
        return ret;
    }

    void reset(Pointer newObject) {
        deleteObject;
        _object = newObject;
    }

    bool opCast(T)() @safe pure nothrow const if(is(T == bool)) {
        return _object !is null;
    }

    void opAssign(T)(Unique!(T, Allocator) other) if(is(T: Type)) {
        deleteObject;
        moveFrom(other);
    }

    mixin Proxy!_object;

private:

    Pointer _object;

    static if(hasInstance)
        alias _allocator = Allocator.instance;
    else
        Allocator _allocator;

    void makeObject(Args...)(auto ref Args args) {
        import std.experimental.allocator: make;
        _object = _allocator.make!Type(args);
    }

    void deleteObject() {
        import std.experimental.allocator: dispose;
        if(_object !is null) _allocator.dispose(_object);
    }

    void moveFrom(T)(ref Unique!(T, Allocator) other) if(is(T: Type)) {
        _object = other._object;
        other._object = null;

        static if(!hasInstance) {
            import std.algorithm: move;
            move(other._allocator, _allocator);
        }
    }
}


@("Unique with struct and test allocator")
@system unittest {

    auto allocator = TestAllocator();
    {
        const foo = Unique!(Struct, TestAllocator*)(&allocator, 5);
        foo.twice.shouldEqual(10);
        allocator.numAllocations.shouldEqual(1);
        Struct.numStructs.shouldEqual(1);
    }

    Struct.numStructs.shouldEqual(0);
}

@("Unique with class and test allocator")
@system unittest {

    auto allocator = TestAllocator();
    {
        const foo = Unique!(Class, TestAllocator*)(&allocator, 5);
        foo.twice.shouldEqual(10);
        allocator.numAllocations.shouldEqual(1);
        Class.numClasses.shouldEqual(1);
    }

    Class.numClasses.shouldEqual(0);
}


@("Unique with struct and mallocator")
@system unittest {

    import std.experimental.allocator.mallocator: Mallocator;
    {
        const foo = Unique!(Struct, Mallocator)(5);
        foo.twice.shouldEqual(10);
        Struct.numStructs.shouldEqual(1);
    }

    Struct.numStructs.shouldEqual(0);
}


@("Unique default constructor")
@system unittest {
    auto allocator = TestAllocator();

    auto ptr = Unique!(Struct, TestAllocator*)();
    (cast(bool)ptr).shouldBeFalse;
    ptr.get.shouldBeNull;

    ptr = Unique!(Struct, TestAllocator*)(&allocator, 5);
    ptr.get.shouldNotBeNull;
    ptr.get.twice.shouldEqual(10);
    (cast(bool)ptr).shouldBeTrue;
}


@("Unique release")
@system unittest {
    import std.experimental.allocator: dispose;

    auto allocator = TestAllocator();

    auto ptr = Unique!(Struct, TestAllocator*)(&allocator, 5);
    auto obj = ptr.release;
    obj.twice.shouldEqual(10);
    allocator.dispose(obj);
}

@("Unique reset")
@system unittest {
    import std.experimental.allocator: make;

    auto allocator = TestAllocator();

    auto ptr = Unique!(Struct, TestAllocator*)(&allocator, 5);
    ptr.reset(allocator.make!Struct(2));
    ptr.twice.shouldEqual(4);
}

@("Unique move")
@system unittest {
    import std.algorithm: move;

    auto allocator = TestAllocator();
    auto oldPtr = Unique!(Struct, TestAllocator*)(&allocator, 5);
    Unique!(Struct, TestAllocator*) newPtr;
    move(oldPtr, newPtr);
    oldPtr.shouldBeNull;
    newPtr.twice.shouldEqual(10);
}

@("Unique copy")
@system unittest {
    import std.algorithm: move;

    auto allocator = TestAllocator();
    auto oldPtr = Unique!(Struct, TestAllocator*)(&allocator, 5);
    Unique!(Struct, TestAllocator*) newPtr;
    // non-copyable
    static assert(!__traits(compiles, newPtr = oldPtr));
}

@("Unique construct base class")
@system unittest {
    auto allocator = TestAllocator();
    {
        Unique!(Object, TestAllocator*) bar = Unique!(Class, TestAllocator*)(&allocator, 5);
        Class.numClasses.shouldEqual(1);
    }

    Class.numClasses.shouldEqual(0);
}

@("Unique assign base class")
@system unittest {
    import std.algorithm: move;
    auto allocator = TestAllocator();
    {
        Unique!(Object, TestAllocator*) bar;
        bar = Unique!(Class, TestAllocator*)(&allocator, 5);
        Class.numClasses.shouldEqual(1);
    }

    Class.numClasses.shouldEqual(0);
}

@("Return Unique from function")
@system unittest {
    auto allocator = TestAllocator();

    auto produce(int i) {
        return Unique!(Struct, TestAllocator*)(&allocator, i);
    }

    auto ptr = produce(4);
    ptr.twice.shouldEqual(8);
}

@("Unique unique")
@system unittest {
    auto allocator = TestAllocator();
    auto oldPtr = Unique!(Struct, TestAllocator*)(&allocator, 5);
    auto newPtr = oldPtr.unique;
    newPtr.twice.shouldEqual(10);
    oldPtr.shouldBeNull;
}


struct RefCounted(Type, Allocator) {
    import std.traits: hasMember;
    import std.typecons: Proxy;

    enum hasInstance = hasMember!(Allocator, "instance");

    static if(is(Type == class))
        alias Pointer = Type;
    else
        alias Pointer = Type*;

    static if(hasInstance)
        /**
           The allocator is a singleton, so no need to pass it in to the
           constructor
        */
        this(Args...)(auto ref Args args) {
            makeObject(args);
        }
    else
        /**
           Non-singleton allocator, must be passed in
        */
        this(Args...)(Allocator allocator, auto ref Args args) {
            _allocator = allocator;
            makeObject(args);
        }

    ~this() {
        destroy(_impl._object);
        auto mem = cast(void*)_impl;
        _allocator.deallocate(mem[0 .. Impl.sizeof]);
    }

    mixin Proxy!(_impl);

private:

    static struct Impl {
        Type _object;
        size_t _count;
        alias _object this;
    }

    static if(hasInstance)
        alias _allocator = Allocator.instance;
    else
        Allocator _allocator;

    Impl* _impl;

    void makeObject(Args...)(auto ref Args args) {
        import std.experimental.allocator: make;
        import std.conv: emplace;
        import std.traits: hasIndirections;
        import core.memory : GC;

        _impl = cast(Impl*)_allocator.allocate(Impl.sizeof);
        emplace(&_impl._object, args);
        _impl._count= 1;

        static if (hasIndirections!Type)
            GC.addRange(&_impl._object, Type.sizeof);
    }


}

@("RefCounted something something darkside")
@system unittest {
    auto allocator = TestAllocator();
    {
        auto ptr = RefCounted!(Struct, TestAllocator*)(&allocator, 5);
        Struct.numStructs.shouldEqual(1);
    }
    Struct.numStructs.shouldEqual(0);
}

version(unittest) {

    private struct Struct {
        int i;
        static int numStructs = 0;

        this(int i) @safe nothrow {
            this.i = i;
            ++numStructs;
        }

        ~this() @safe nothrow {
            --numStructs;
        }

        int twice() @safe pure const nothrow {
            return i * 2;
        }
    }

    private class Class {
        int i;
        static int numClasses = 0;

        this(int i) @safe nothrow {
            this.i = i;
            ++numClasses;
        }

        ~this() @safe nothrow {
            --numClasses;
        }

        int twice() @safe pure const nothrow {
            return i * 2;
        }
    }
}
