# All python versions that we can build for; not all
# of these will be built, based on the python_versions flag.
ALL_PYTHON_VERSIONS=["3.6", "3.7", "3.8"]

def _impl(repository_ctx):
    result = repository_ctx.execute([
        repository_ctx.path(repository_ctx.attr._build_script),
        repository_ctx.attr.version])
    if result.stdout:
        print(result.stdout)
    if result.stderr:
        print(result.stderr)
    if result.return_code:
        fail("Could not install python version " + repository_ctx.attr.version)

# "version" attribute used to force regeneration of the repository
# if something changes.
spiral_python_repository = repository_rule(
    implementation=_impl,
        attrs={"version": attr.string(mandatory=True),
               "_build_script" : attr.label(default="//tools:python_repository.sh")})

def spiral_python_repositories():
    for version in ALL_PYTHON_VERSIONS:
        spiral_python_repository(
            name="spiral_python" + version,
            version=version
        )

