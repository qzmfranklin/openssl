#!/usr/bin/env python3 -u

import io
import textwrap
import unittest

from parse_build_log import *


class TestParseBuildLog(unittest.TestCase):

    def test_file_to_lines(self):
        actual_lines = list(file_to_lines(io.StringIO(textwrap.dedent('''
            line1

            \t  \t\t\t     \t\t\t
              line2start...\\
                line2end
            '''))))
        self.assertEqual(actual_lines, [
            'line1',
            # Notice that the line splicing causes the insertion of the space.
            'line2start... line2end',
        ])

    def test_openssl_build_logs(self):
        os_targets = ['xenial', 'sierra']
        for target in os_targets:
            actual_list = []
            buildlog_fname = 'bazel/test_data/build.log.%s' % target
            for ele in parse_openssl_build_log(open(buildlog_fname, 'r')):
                actual_list.append('%s %s\n' % (ele['type'], ele['target']))
            expected_fname = 'bazel/test_data/expected.%s' % target
            expected_list = open(expected_fname, 'r').readlines()
            self.assertEqual(actual_list, expected_list)

    def test_parse_quoted_tokens(self):
        results = parse_openssl_build_log(io.StringIO(
            r'gcc  -DENGINESDIR="\"/usr/local/lib/engines-1.1\"" ds.c'))
        self.assertEqual(results[0]['type'], 'CC')
        self.assertEqual(results[0]['target'], 'ds.c')
        self.assertEqual(results[0]['cmd'], [
                'gcc',
                '',
                r'-DENGINESDIR="\"/usr/local/lib/engines-1.1\""',
                'ds.c',
        ])


if __name__ == '__main__':
    unittest.main()
