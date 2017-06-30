#!/usr/bin/env python3

''' Parse the build log of openssl.

This module provides the parse_openssl_build_log() function that can parse the
build log files as generated via the following commands (run from the root
directory of the openssl source tree):
        ./config no-shared no-dso
        make -j8 buld_libs > build.log
'''

import re
import shlex


def file_to_lines(f):
    ''' Tokenize a file into lines.

    There are a few lines that use line splicing, i.e., a backslash at the end
    of the line to extend the line to the next line.  The parser needs to handle
    those cases as if they were whole lines.

    Args:
        f: The input file-like object.

    Returns:
        A generator object that returns full lines, one line per iteration.
        These lines are guaranteed to not have leading or trailing whitespaces.
        Empyt lines and lines that are made of only whitespaces are completely
        ignored.
    '''
    whole_line = ''
    line_splice = False
    for line in f:
        # Ignore empty lines and lines that are purely whitespace characters.
        line = line.strip()
        if not line:
            continue

        # If the previous line ends with '\', concatenate.
        if not line_splice:
            whole_line = line
        else:
            whole_line = whole_line + ' ' + line

        # If this line, after possibly having been concatenated with the
        # previous line, ends with '\', then this line should be concatenated
        # with the next line.
        if whole_line.endswith('\\'):
            whole_line = whole_line[:-1]
            line_splice = True
            continue
        else:
            line_splice = False

        # Now, the 'whole_line' is really the whole line to parse.
        yield whole_line


def parse_openssl_build_log(f):
    ''' Parse the openssl build log.

    Args:
        f: The file-like object that represents the build log.

    Returns:
        A generator that returns a dictionary upon each iteration.  All returned
        dictionaries must have the following three key-value pairs:
                type            One of {GENH,GENASM,CC,AR,RANLIB,UNKNOWN}.  The
                                type UNKOWN is a warning that this parser
                                function cannot parse that line.
                target          A string, a unique identification for the file
                                under operation.  If the 'type' is UNKNOWN, the
                                'target' value is None.
                cmd             A list of strings representing the command line
                                command to issue.  Suitable as the argument to
                                subprocess.check_call(cmd).  If the 'type' is
                                UNKNOWN, this becomes a string that is exactly
                                the same as the original line to allow easy
                                search and string matching during debugging.
        Any other values are auxiliary.
    '''
    retval = []
    for line in file_to_lines(f):
        if line.startswith(('make', '#')):
            # Ignore make prints and bash comments.
            continue
        elif re.match('^/usr/bin/perl .*\.h$', line):
            # Generate header file.  Requires configdata.pm, which is generated
            # via running `config no-shared no-dso`.
            toks = shlex.split(line)
            header_fname = toks[-1]
            retval.append(dict(cmd=toks, type='GENH', target=header_fname))
        elif re.match('^CC="gcc" /usr/bin/perl .*$', line):
            # Generate .s source files for the platform.  Requires
            # configdata.pm.
            CC, gcc, perl_script, elf, asm_fname = toks = shlex.split(line)
            retval.append(dict(cmd=toks, type='GENASM', target=asm_fname))
        elif re.match('^gcc  .*\.[sc]$', line):
            # Compile .s and .c files into .o files.
            toks = shlex.split(line)
            src_fname = toks[-1]
            retval.append(dict(cmd=toks, type='CC', target=src_fname))
        elif re.match('^ar  r.*$', line):
            # Build static libraries with `ar`.
            toks = shlex.split(line)
            static_lib = toks[2]
            retval.append(dict(cmd=toks, type='AR', target=static_lib))
        elif re.match('^ranlib .*$', line):
            # Generate index for libraries with `ranlib`.
            toks = shlex.split(line)
            static_lib = toks[1]
            retval.append(dict(cmd=toks, type='RANLIB', target=static_lib))
        else:
            retval.append(dict(cmd=line, type='UNKONWN', target=None))
    return retval
