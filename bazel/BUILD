licenses(['notice'])
package(default_visibility=['//visibility:public'])

py_library(
    name = 'parse_build_log',
    srcs = [
        'parse_build_log.py',
    ],
)

py_test(
    name = 'parse_build_log_test',
    srcs = [
        'parse_build_log_test.py',
    ],
    deps = [
        ':parse_build_log',
    ],
    data = [
        'test_data/build.log',
        'test_data/expected_parsed_output.txt',
    ],
    default_python_version = 'PY3',
    srcs_version = 'PY3',
)
