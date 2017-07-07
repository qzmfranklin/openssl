# This BUILD file exposes two targets in the current directory:
#       crypto ssl
# This openssl repository can be freely included in other Bazel projects or used
# as an external repository.
#
# More details are available in the comments at the top of the bazel/openssl.bzl
# file.
licenses(['notice'])
package(default_visibility=['//visibility:__pkg__'])
load(':bazel/openssl.bzl', 'openssl')
openssl()
