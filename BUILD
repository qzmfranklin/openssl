licenses(['notice'])
package(default_visibility=['//visibility:__pkg__'])

# TODO: crypto.copts and ssl.copts are identical except for the -I directives,
# which are superseded by the includes attribute anyways.  Should consolidate
# the copts for crypto and ssl.
load(':bazel/generated_data/xenial.bzl',
    'openssl_linkopts',
    'crypto_asm_srcs',
    'crypto_srcs',
    'crypto_generated_hdrs',
    'crypto_copts',
    'ssl_srcs',
    'ssl_copts',
    'genrule_outs',
    'genrule_cmds'
)

openssl_includes = [
    'include',
    'crypto',
    'crypto/include',
    'crypto/bn',
    'crypto/des',
    'crypto/modes',
    # The generated headers are stored in the $(GENDIR).
    '$(GENDIR)/%s/include' % package_name(),
    '$(GENDIR)/%s/crypto' % package_name(),
    '$(GENDIR)/%s/crypto/include' % package_name(),
] + ([ '.' ] if package_name() else [])

crypto_textual_hrds = [
    'crypto/LPdir_unix.c',
    'crypto/ec/ecp_nistz256_table.c',
    'crypto/des/ncbc_enc.c',
]


cc_library(
    name = 'crypto',
    visibility = [
        '//visibility:public',
    ],
    srcs = crypto_srcs + crypto_asm_srcs,
    hdrs = glob([
        'crypto/**/*.h',
        'include/**/*.h',
        'e_os.h',
    ]) + crypto_generated_hdrs,
    includes = openssl_includes,
    defines = [
        'OPENSSL_NO_STATIC_ENGINE',
    ],
    textual_hdrs = crypto_textual_hrds,
    copts = crypto_copts + [
        # See the comments above the commented cc_library target 'crypto_asm'
        # for an explanation of why these copts.
        '-B/usr/bin',
        '-Wno-unused-command-line-argument',
        '-fno-integrated-as',
    ],
    linkopts = openssl_linkopts,
)

# TODO (zhongming): Make this a standalone cc_library.
#
# Why it cannot build as a standalone cc_library:
#
#       Because it misses the symbol OPENSSL_cpuid_setup, which is implemented
#       in crypto/cryptlib.c.
#
#
# The reason for having this as a separate cc_library target is to isolate the
# compilation of the generated assembly files.  More specifically for the
# following two reasons:
#
#   1.  Avoid unused options.
#
#       A lot of the options used to compile normal .c files are unused when
#       compiling assembly, i.e., .s files.  As a result, compilation generates
#       tons of warnings of unused options.
#
#       Grouping these assembly files into a cc_library target allows us to
#       compile them without all those extraneous options, thus leading to
#       higher signal to noise ratio in compile time diagnostics.
#
#   2.  Disable clang's integrated assembler.
#
#       When using clang to compile .s files, the default assembler is clang's
#       integrated assembler.  The integrated assembler does not allow compile
#       assembly mnomonics that are not available in the target CPU.  But the
#       generated crypto/poly1305/poly1305-<arch>.s file contains lines using
#       registers that are only available by the Intel AVX512 instruction set
#       such as %ymm30 regardless of the actual target CPU.  As a result,
#       poly1305-<arch>.s does not compile with clang's integrated assembler on
#       CPUs that do not support AVX512.
#
#       Admittedly, clang is justified to check for the instruction set and
#       forbids compiling instructions not supported by the target CPU.
#       However, for the purpose of compiling openssl, that is an annoyance to
#       deal with.
#
#       The alternative to this approach, which is to make openssl generate .s
#       files by looking at the target CPU, is much harder to implement.
#
#
# What to do to enable it?
#
#   1.  Uncomment the target below.
#
#   2.  Add it as a deps to 'crypto'.
#cc_library(
    #name = 'crypto_asm',
    #srcs = crypto_asm_srcs,
    #copts = [
        #'-B/usr/bin',
        #'-Wno-unused-command-line-argument',
        #'-fno-integrated-as',
    #],
#)


cc_library(
    name = 'ssl',
    visibility = [
        '//visibility:public',
    ],
    srcs = ssl_srcs,
    hdrs = glob([
        'ssl/**/*.h',
    ]),
    includes = openssl_includes,
    copts = ssl_copts,
    linkopts = openssl_linkopts,
    deps = [
      ':crypto',
    ]
)

genrule(
    name = 'generate_internal_files',
    srcs = glob([
        # Perl modules used to generate asm files.
        #
        # The glob pattern below does not include the .pm files under the
        # external/ directory as bazel thinks those are part of some
        # external repository, complained as such:
        #       Label '//:external/perl/transfer/Text/Template.pm' crosses boundary of subpackage 'external' (perhaps you meant to put the colon here: '//external:perl/transfer/Text/Template.pm'?).
        # The workaround is to `mv external third_party`.
        '**/*.pm',
        '**/*.pl',
        '**/*.h.in',
    ]) + [
        ':configdata_pm',
    ] + crypto_textual_hrds,
    outs = genrule_outs,
    cmd = ' && '.join([
        # Make the perl module files available at runtime.
        'export DIR=%s' % '/'.join(['.', PACKAGE_NAME]),
        'export PERL5LIB=$$DIR/third_party/perl:$$(dirname $(location :configdata_pm))',
    ] + genrule_cmds),
)

genrule(
    name = 'configdata_pm',
    srcs = glob([
        '**/*.pm',
        # The 10-main.conf is the database storing the combinationas of
        # platforms compilers supported by openssl.
        'Configurations/**',
        # The existence of the following directories under crypto/ is used
        # to populate the correct set of configuration options:
        #       aes aria bf camellia cast des dh dsa ec hmac idea md2 md5
        #       mdc2 rc2 rc4 rc5 ripemd rsa seed sha
        'crypto/**',
        # The various build.info files are used to populate the
        # %unified_info section in the generated configdata.pm file.
        '**/build.info',
    ]) + [
        'Configure',
        'config',
        # The opensslv.h file contains version information and is used by
        # config.
        'include/openssl/opensslv.h',
        'util/dofile.pl',
    ],
    outs = [
        # This perl module is used to generate other .h and .s files.
        'configdata.pm',
    ],
    cmd = ' && '.join([
        'export DIR=%s' % '/'.join(['.', PACKAGE_NAME]),
        'export PERL5LIB=$$DIR/util:$$DIR/third_party/perl:$(@D)',
        '$(location config) &> /dev/null',
        'rm -f $@',
        'cp -L configdata.pm $(@D)',
    ]),
)

cc_binary(
    name = 'openssl',
    visibility = [
        '//visibility:public',
    ],
    srcs = glob([
        'apps/*.c',
        'apps/*.h',
    ], exclude=[
        'apps/win32_init.c',
    ]) + [
        ':progs_h',
    ],
    deps = [
        ':ssl',
    ],
    copts = [
        # The generated progs.h file resides in the $GENDIR
        '-I$(GENDIR)/%s' % PACKAGE_NAME,
    ] + crypto_copts,
    linkopts = [
        '-ldl',
    ],
)

genrule(
    name = 'progs_h',
    srcs = glob([
        'apps/*.c',
    ]) + [
        'apps/progs.pl',
        ':configdata_pm',
    ],
    outs = [
        'progs.h',
    ],
    cmd = ' && '.join([
        # The python3 -c '...' hack emulates the GNU `readlink -f`, which is
        # absent from BSD based distributions.
        r'''export DIR=$$(python3 -c 'import os; print(os.path.realpath("%s"))') ''' % '/'.join(['.', PACKAGE_NAME]),
        r'''export PERL5LIB=$$DIR:$$DIR/third_party/perl:$$(python3 -c 'import os; print(os.path.realpath("$(@D)"))') ''',
        'cd $$DIR',
            # This perl script must be invoked using exactly this format.
            # Otherwise, it will fail to scan the apps/openssl directory and
            # miss out the `extern int` declarations in the generated
            # progs.h file.
            'perl apps/progs.pl apps/openssl > tmp',
        'cd -',
        'mv $$DIR/tmp $@',
    ]),
)
