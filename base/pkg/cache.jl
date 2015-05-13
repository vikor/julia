module Cache

import ..LibGit2, ..Dir
using ..Types

path(pkg::AbstractString) = abspath(".cache", pkg)

function mkcachedir()
    cache = joinpath(realpath("."), ".cache")
    if isdir(cache)
        return
    end

    @windowsxp_only mkdir(cache)
    @non_windowsxp_only begin
        if Dir.isversioned(pwd())
            rootcache = joinpath(realpath(".."), ".cache")
            if !isdir(rootcache)
                mkdir(rootcache)
            end
            symlink(rootcache, cache)
            return
        end
        mkdir(cache)
    end
end

function prefetch(pkg::AbstractString, url::AbstractString, sha1s::Vector)
    isdir(".cache") || mkcachedir()
    cache = path(pkg)
    repo = if isdir(cache)
        try
            LibGit2.GitRepo(cache)
        catch err
            rethrow(err)
        end
    else
        info("Cloning cache of $pkg from $url")
        try
            LibGit2.clone(url, cache, bare = true, remote_cb = LibGit2.mirror_cb)
        catch err
            isdir(cache) && rm(cache, recursive=true)
            error("Cannot clone $pkg from $url\n", err)
        end
    end
    try
        LibGit2.set_remote_url(repo, url)
        if !all(sha1->LibGit2.iscommit(sha1, repo), sha1s)
            info("Updating cache of $pkg...")
            try
                LibGit2.fetch(repo)
            catch
                error("couldn't update $cache using `git remote update`")
            end
        end
    catch err
        rethrow(err)
    end
    filter(sha1->!LibGit2.iscommit(sha1, repo), sha1s)
end
prefetch(pkg::AbstractString, url::AbstractString, sha1::AbstractString...) = prefetch(pkg, url, AbstractString[sha1...])

end # module
