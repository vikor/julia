immutable TimeStruct
    time::Int64     # time in seconds from epoch
    offset::Cint    # timezone offset in minutes
end
TimeStruct() = TimeStruct(zero(Int64), zero(Cint))

immutable SignatureStruct
    name::Ptr{UInt8}  # full name of the author
    email::Ptr{UInt8} # email of the author
    when::TimeStruct  # time when the action happened
end
SignatureStruct() = SignatureStruct(Ptr{UInt8}(0),
                                    Ptr{UInt8}(0),
                                    TimeStruct())

immutable StrArrayStruct
   strings::Ptr{Ptr{UInt8}}
   count::Csize_t
end
StrArrayStruct() = StrArrayStruct(Ptr{UInt8}(0), zero(Csize_t))

immutable CheckoutOptionsStruct
    version::Cuint
    checkout_strategy::Cuint
    disable_filters::Cint
    dir_mode::Cuint
    file_mode::Cuint
    file_open_flags::Cint
    notify_flags::Cuint
    notify_cb::Ptr{Void}
    notify_payload::Ptr{Void}
    progress_cb::Ptr{Void}
    progress_payload::Ptr{Void}
    paths::StrArrayStruct
    baseline::Ptr{Void}
    target_directory::Ptr{UInt8}
    ancestor_label::Ptr{UInt8}
    our_label::Ptr{UInt8}
    their_label::Ptr{UInt8}
end
CheckoutOptionsStruct(; checkout_strategy::Cuint = GitConst.CHECKOUT_SAFE_CREATE,
                        disable_filters::Cint = zero(Cint),
                        dir_mode::Cuint = Cuint(0o755),
                        file_mode::Cuint = Cuint(0o755),
                        file_open_flags::Cint = zero(Cint),
                        notify_flags::Cuint = GitConst.CHECKOUT_NOTIFY_NONE,
                        notify_cb::Ptr{Void} = Ptr{Void}(0),
                        notify_payload::Ptr{Void} = Ptr{Void}(0),
                        progress_cb::Ptr{Void} = Ptr{Void}(0),
                        progress_payload::Ptr{Void} = Ptr{Void}(0),
                        paths::StrArrayStruct = StrArrayStruct(),
                        baseline::Ptr{Void} = Ptr{Void}(0),
                        target_directory::Ptr{UInt8} = Ptr{UInt8}(0),
                        ancestor_label::Ptr{UInt8} =Ptr{UInt8}(0),
                        our_label::Ptr{UInt8} = Ptr{UInt8}(0),
                        their_label::Ptr{UInt8} = Ptr{UInt8}(0)
)=CheckoutOptionsStruct(one(Cuint),
                        checkout_strategy,
                        disable_filters,
                        dir_mode,
                        file_mode,
                        file_open_flags,
                        notify_flags,
                        notify_cb,
                        notify_payload,
                        progress_cb,
                        progress_payload,
                        paths,
                        baseline,
                        target_directory,
                        ancestor_label,
                        our_label,
                        their_label)

immutable RemoteCallbacksStruct
    version::Cuint
    sideband_progress::Ptr{Void}
    completion::Ptr{Void}
    credentials::Ptr{Void}
    certificate_check::Ptr{Void}
    transfer_progress::Ptr{Void}
    update_tips::Ptr{Void}
    pack_progress::Ptr{Void}
    push_transfer_progress::Ptr{Void}
    push_update_reference::Ptr{Void}
    payload::Ptr{Void}
end
RemoteCallbacksStruct() = RemoteCallbacksStruct(one(Cuint),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0),
                                                Ptr{Void}(0))

immutable CloneOptionsStruct
    version::Cuint
    checkout_opts::CheckoutOptionsStruct
    remote_callbacks::RemoteCallbacksStruct
    bare::Cint
    localclone::Cint
    checkout_branch::Ptr{UInt8}
    signature::Ptr{Void}
    repository_cb::Ptr{Void}
    repository_cb_payload::Ptr{Void}
    remote_cb::Ptr{Void}
    remote_cb_payload::Ptr{Void}
end
CloneOptionsStruct(; checkout_opts::CheckoutOptionsStruct = CheckoutOptionsStruct(),
                     remote_callbacks::RemoteCallbacksStruct = RemoteCallbacksStruct(),
                     bare::Cint = zero(Cint),
                     localclone::Cint = zero(Cint),
                     checkout_branch::Ptr{UInt8} = Ptr{UInt8}(0),
                     signature::Ptr{Void} = Ptr{Void}(0),
                     repository_cb::Ptr{Void} = Ptr{Void}(0),
                     repository_cb_payload::Ptr{Void} = Ptr{Void}(0),
                     remote_cb::Ptr{Void} = Ptr{Void}(0),
                     remote_cb_payload::Ptr{Void} = Ptr{Void}(0)
)=CloneOptionsStruct(one(Cuint),
                     checkout_opts,
                     remote_callbacks,
                     bare,
                     localclone,
                     checkout_branch,
                     signature,
                     repository_cb,
                     repository_cb_payload,
                     remote_cb,
                     remote_cb_payload)

# git diff option struct
immutable DiffOptionsStruct
    version::Cuint
    flags::UInt32

    # options controlling which files are in the diff
    ignore_submodules::Cint
    pathspec::StrArrayStruct
    notify_cb::Ptr{Void}
    notify_payload::Ptr{Void}

    # options controlling how the diff text is generated
    context_lines::UInt32
    interhunk_lines::UInt32
    id_abbrev::UInt16
    max_size::Coff_t
    old_prefix::Ptr{UInt8}
    new_prefix::Ptr{UInt8}
end
DiffOptionsStruct(; flags::UInt32 = GitConst.DIFF_NORMAL,
                    ignore_submodules::Cint = GitConst.SUBMODULE_IGNORE_DEFAULT,
                    pathspec::StrArrayStruct = StrArrayStruct(),
                    notify_cb::Ptr{Void} = Ptr{Void}(0),
                    notify_payload::Ptr{Void} = Ptr{Void}(0),
                    context_lines::UInt32 = UInt32(3),
                    interhunk_lines::UInt32 = zero(UInt32),
                    id_abbrev::UInt16 = UInt16(7),
                    max_size::Coff_t = Coff_t(512*1024*1024), #zero(Coff_t), #512Mb
                    old_prefix::Ptr{UInt8} = Ptr{UInt8}(0),
                    new_prefix::Ptr{UInt8} = Ptr{UInt8}(0)
)=DiffOptionsStruct(GitConst.DIFF_OPTIONS_VERSION,
                    flags,
                    ignore_submodules,
                    pathspec,
                    notify_cb,
                    notify_payload,
                    context_lines,
                    interhunk_lines,
                    id_abbrev,
                    max_size,
                    old_prefix,
                    new_prefix
                )

# Abstract object types
abstract AbstractGitObject
Base.isempty(obj::AbstractGitObject) = (obj.ptr == C_NULL)

abstract GitObject <: AbstractGitObject
function finalize(obj::GitObject)
    if obj.ptr != C_NULL
        ccall((:git_object_free, :libgit2), Void, (Ptr{Void},), obj.ptr)
        obj.ptr = C_NULL
    end
end

# Common types
for (typ, ref, sup, fnc) in (
            (:GitRemote,     :Void, :AbstractGitObject, :(:git_remote_free)),
            (:GitRevWalker,  :Void, :AbstractGitObject, :(:git_revwalk_free)),
            (:GitConfig,     :Void, :AbstractGitObject, :(:git_config_free)),
            (:GitReference,  :Void, :AbstractGitObject, :(:git_reference_free)),
            (:GitDiff,       :Void, :AbstractGitObject, :(:git_diff_free)),
            (:GitIndex,      :Void, :AbstractGitObject, :(:git_index_free)),
            (:GitRepo,       :Void, :AbstractGitObject, :(:git_repository_free)),
            (:GitSignature,  :SignatureStruct, :AbstractGitObject, :(:git_signature_free)),
            (:GitAnyObject,  :Void, :GitObject, nothing),
            (:GitCommit,     :Void, :GitObject, nothing),
            (:GitTree,       :Void, :GitObject, nothing)
        )

    @eval type $typ <: $sup
        ptr::Ptr{$ref}
        function $typ(ptr::Ptr{$ref})
            @assert ptr != C_NULL
            obj = new(ptr)
            return obj
        end
    end

    if fnc != nothing
        @eval function finalize(obj::$typ)
            if obj.ptr != C_NULL
                ccall(($fnc, :libgit2), Void, (Ptr{$ref},), obj.ptr)
                obj.ptr = C_NULL
            end
        end
    end

end

# Structure has the same layout as SignatureStruct
type Signature
    name::AbstractString
    email::AbstractString
    time::Int64
    time_offset::Int32
end

""" Resource management helper function
"""
function with_libgit2(f::Function, obj)
    try
        f(obj)
    catch err
        rethrow(err)
    finally
        finalize(obj)
    end
end

function with{T}(f::Function, ::Type{T}, args...; warn_on_exception::Bool=true)
    obj = T(args...)
    try
        with_libgit2(f, obj)
    catch err
        rethrow(err)
    end
end

function with_warn{T}(f::Function, ::Type{T}, args...)
    obj = T(args...)
    try
        with_libgit2(f, obj)
    catch err
        warn("$(string(T)) thrown exception: $err")
    end
end