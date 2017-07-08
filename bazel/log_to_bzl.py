#!/usr/bin/env python3


''' Generate openssl.bzl rule from openssl build log.
'''


import argparse
import jinja2
import sys
import subprocess

from parse_build_log import parse_openssl_build_log


def generate_bzl(parsed_results):
    ''' Generate the content of the openssl.bzl file.

    The openssl library has two primary libraries: crypto and ssl.  This genrule
    should build these two libraries.

    Args:
        parsed_results: The parsed results of the build log.  The format is
            described in the __doc__ string of the parse_openssl_build_log()
            function in parse_build_log.py.  Note that parsed_results is a
            generator.  This forces this method to complete everything with one
            pass.

    Returns:
        A python3 string representing the content of the bazel rule file for
        building openssl.
    '''
    generated_hdrs = []
    generated_srcs = []
    genrule_cmds = []
    genrule_srcs = []
    crypto_srcs = []
    ssl_srcs = []
    # In fact, crypto_copts is a strict superset of ssl_copts.  The extra flag
    # is '-Icrypto/include'.
    crypto_copts = []
    ssl_copts = []
    linkopts = ['-pthread', '-m64']
    for ele in parsed_results:
        type = ele['type']
        target = ele['target']
        cmd = ele['cmd']
        if type == 'CC':
            # This if-elif-else block relies on the fact that crypto library
            # and ssl library are built from source files under crypto/ and
            # ssl/, respectively.
            if target.startswith('crypto'):
                crypto_srcs.append(target)
                if not crypto_copts:
                    # Here is an excerpt from a typical 'CC' line:
                    #       gcc  -I. ... -DPOLY1305_ASM -Wall -O3 -pthread -m64
                    #       -DL_ENDIAN -Wa,--noexecstack -fPIC
                    #       -DOPENSSL_USE_NODELETE -c -o crypto/aes/aes-x86_64.o
                    #       crypto/aes/aes-x86_64.s
                    # We only want to pick up shell tokens that starts with
                    # '-I', '-D', and '-W' while excluding the '-Wall' flag.
                    # Notably, the '-O3' and '-fPIC' are auto-inserted by bazel.
                    for tok in cmd:
                        if len(tok) > 1 and tok != '-Wall' and \
                                tok[:2] in ['-I', '-D', '-W']:
                            crypto_copts.append(tok)
            elif target.startswith('ssl'):
                ssl_srcs.append(target)
                if not ssl_copts:
                    for tok in cmd:
                        if len(tok) > 1 and tok != '-Wall' and \
                                tok[:2] in ['-I', '-D', '-W']:
                            ssl_copts.append(tok)
            else:
                # Ignore other directories.  The only directory that is intended
                # to be ignord is the test/ directory.
                continue
        elif type == 'GENH':
            # Representative examples of GENH:
            # 1.  /usr/bin/perl -I. -Mconfigdata util/dofile.pl -oMakefile
            # include/openssl/opensslconf.h.in > include/openssl/opensslconf.h
            # 2.  /usr/bin/perl util/mkbuildinf.pl "gcc -DDSO_DLFCN ...
            # -Wa,--noexecstack" linux-x86_64 > crypto/buildinf.h
            #
            # Shell tokens ending with '.pl' and '.h.in' are bazel sources.
            #
            # Note that the generated header files are stored in the
            # bazel-genfiles directory.  This requires adding the following to
            # the copts of the cc_library:
            #       '-I$(GENDIR)/%s/include' % PACKAGE_NAME
            #       '-I$(GENDIR)/%s/crypto' % PACKAGE_NAME
            #       '-I$(GENDIR)/%s/crypto/include' % PACKAGE_NAME
            genrule_cmd = []
            for tok in cmd:
                if tok.endswith(('.pl', '.h.in')) or tok == target:
                    if tok != target:
                        genrule_srcs.append(tok)
                    tok = '$(location %s)' % tok
                genrule_cmd.append(tok)
            genrule_cmds.append(subprocess.list2cmdline(genrule_cmd))
            generated_hdrs.append(target)
        elif type == 'GENASM':
            # Representative example of GENASM:
            #     CC=gcc /usr/bin/perl crypto/aes/asm/aes-x86_64.pl elf crypto/aes/aes-x86_64.s
            #
            # Shell tokens endin with '.pl' are bazel sources.
            genrule_cmd = []
            for tok in cmd:
                if tok.endswith('.pl') or tok == target:
                    if tok != target:
                        genrule_srcs.append(tok)
                    tok = '$(location %s)' % tok
                genrule_cmd.append(tok)
            genrule_cmds.append(subprocess.list2cmdline(genrule_cmd))
            generated_srcs.append(target)
            # Note that these generated sources are already included in the
            # build log.  Therefore there is no need to add them again.
        else:
            # Ignor AR and RANLIB
            pass

    data = {
        'crypto': {
            'copts': sorted(crypto_copts),
            'srcs': sorted(crypto_srcs),
            'generated_hdrs': generated_hdrs,
        },
        'ssl': {
            'copts': sorted(ssl_copts),
            'srcs': sorted(ssl_srcs),
        },
        'linkopts': linkopts,
        'genrule': {
            'cmds': sorted(genrule_cmds),
            'outs': sorted(generated_hdrs + generated_srcs),
            'srcs': sorted(list(set(genrule_srcs))),
        },
    }
    template = jinja2.Template(open('openssl.bzl.j2').read())
    return template.render(data)


def main():
    parser = argparse.ArgumentParser(description=__doc__,
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    def __file_type__(s):
        if s is '-':
            return sys.stdin
        else:
            return open(s, 'r')
    parser.add_argument('build_log',
            type=__file_type__,
            help='''the build log file to parse, '-' indicates using stdin as
            the input file''')
    parser.add_argument('--format',
            choices={'human', 'bazel'},
            default='human',
            help='''human: output a human readable format of the build log;
            bazel: output the .bzl rule file.''')

    args = parser.parse_args()

    parsed_results = parse_openssl_build_log(args.build_log)

    if args.format == 'human':
        for ele in parsed_results:
            if ele['type'] != 'UNKNOWN':
                print('\t%s\t%s' % (ele['type'], ele['target']))
            else:
                print(ele['type'], ele['cmd'])
    elif args.format == 'bazel':
        print(generate_bzl(parsed_results))


if __name__ == '__main__':
    main()
