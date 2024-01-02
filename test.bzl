load(":fakechroot.bzl", "get_fakechroot")

def _test_fakechroot_impl(ctx):
    out = ctx.actions.declare_file("ok")
    fakechroot = get_fakechroot(ctx.files._fakechroot)

    ctx.actions.run_shell(
        inputs = depset(
            direct = [ fakechroot ],
        ),
        outputs = [ out ],
        command = """
set -eo pipefail;
export LD_PRELOAD={fakechroot};
LDD=`ldd $(which file) | grep {fakechroot}`;
if [ ! -z "$LDD" ] ;
    then touch {out} ;
else
    echo 'fakechroot does not work';
    exit 1;
fi
"""
            .format(fakechroot = fakechroot.path, out = out.path),
    )

    return DefaultInfo(files = depset([out]), runfiles = ctx.runfiles([out]))


test_fakechroot = rule(
    implementation = _test_fakechroot_impl,
    attrs = {
        "_fakechroot": attr.label(
            default = "//:fakechroot",
            allow_files = True,
            cfg = "exec"
        )
    }
)
