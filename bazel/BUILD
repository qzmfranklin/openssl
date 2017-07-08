licenses(['notice'])
package(default_visibility=['//visibility:public'])

py_binary(
    name = 'log_to_bzl',
    srcs = [
        'log_to_bzl.py',
    ],
    deps = [
        ':parse_build_log',
    ],
    default_python_version = 'PY3',
    srcs_version = 'PY3',
)

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
    data = glob([
        'test_data/*',
    ]),
    default_python_version = 'PY3',
    srcs_version = 'PY3',
)
