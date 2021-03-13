# SimpleVector

function getindex(v::SimpleVector, i::Int)
    @boundscheck if !(1 <= i <= length(v))
        throw(BoundsError(v,i))
    end
    return ccall(:jl_svec_ref, Any, (Any, Int), v, i - 1)
end

function length(v::SimpleVector)
    return ccall(:jl_svec_len, Int, (Any,), v)
end
firstindex(v::SimpleVector) = 1
lastindex(v::SimpleVector) = length(v)
iterate(v::SimpleVector, i=1) = (length(v) < i ? nothing : (v[i], i + 1))
eltype(::Type{SimpleVector}) = Any
keys(v::SimpleVector) = OneTo(length(v))
isempty(v::SimpleVector) = (length(v) == 0)
axes(v::SimpleVector) = (OneTo(length(v)),)
axes(v::SimpleVector, d::Integer) = d <= 1 ? axes(v)[d] : OneTo(1)

function ==(v1::SimpleVector, v2::SimpleVector)
    length(v1)==length(v2) || return false
    for i = 1:length(v1)
        v1[i] == v2[i] || return false
    end
    return true
end

map(f, v::SimpleVector) = Any[ f(v[i]) for i = 1:length(v) ]

getindex(v::SimpleVector, I::AbstractArray) = Core.svec(Any[ v[i] for i in I ]...)

unsafe_convert(::Type{Ptr{Any}}, sv::SimpleVector) = convert(Ptr{Any},pointer_from_objref(sv)) + sizeof(Ptr)
