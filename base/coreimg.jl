# This file is a part of Julia. License is MIT: http://julialang.org/license

import Core.Intrinsics.ccall
ccall(:jl_new_main_module, Any, ())

baremodule Base
baremodule Inference
using Core: Intrinsics, arraylen, arrayref, arrayset, arraysize, _expr,
            kwcall, _apply, typeassert, apply_type, svec
import ..Base
ccall(:jl_set_istopmod, Void, (Bool,), false)

eval(x) = Core.eval(Inference,x)
eval(m,x) = Core.eval(m,x)

include = Core.include

# simple print definitions for debugging.
show(x::ANY) = ccall(:jl_static_show, Void, (Ptr{Void}, Any),
                     Intrinsics.pointerref(Intrinsics.cglobal(:jl_uv_stdout,Ptr{Void}),1), x)
print(x::ANY) = show(x)
println(x::ANY) = ccall(:jl_, Void, (Any,), x) # includes a newline
print(a::ANY...) = for x=a; print(x); end

## Load essential files and libraries
include("essentials.jl")
include("reflection.jl")
include("build_h.jl")
include("c.jl")
include("options.jl")

# core operations & types
include("promotion.jl")
include("tuple.jl")
include("range.jl")
include("expr.jl")
include("error.jl")

# core numeric operations & types
include("bool.jl")
include("number.jl")
include("int.jl")
include("operators.jl")
include("pointer.jl")
include("refpointer.jl")

# core array operations
include("abstractarray.jl")
include("subarray.jl")
include("array.jl")
include("subarray2.jl")

#TODO: eliminate Dict from inference
include("hashing.jl")
include("nofloat_hashing.jl")

# SIMD loops
include("simdloop.jl")
importall .SimdLoop

# map-reduce operators
include("functors.jl")
include("reduce.jl")

## core structures
include("intset.jl")
include("dict.jl")
include("iterator.jl")

# compiler
include("inference.jl")
precompile(CallStack, (Expr, Module, (Void,), EmptyCallStack))

# For OS specific stuff in I/O
# to force compile of inference
include("osutils.jl")

end # baremodule Inference
end # baremodule Base
