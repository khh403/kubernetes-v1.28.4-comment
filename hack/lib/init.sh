#!/usr/bin/env bash

# Copyright 2014 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

# 这个脚本主要做了一些初始化操作:
#   unset CDPATH
#   export GO111MODULE=off
#   设置 KUBE_ROOT
#   设置 KUBE_OUTPUT_SUBPATH
#   设置 KUBE_OUTPUT
#   设置 KUBE_OUTPUT_BINPATH
#   设置 KUBE_RSYNC_COMPRESS
#   设置 THIS_PLATFORM_BIN
#   kube::log::install_errexit
#   kube::util::ensure-bash-version
#   设置 KUBE_AVAILABLE_GROUP_VERSIONS 当前版本支持的 Group
#   设置 KUBE_NONSERVER_GROUP_VERSIONS 当前版本不支持的 Group
#   定义函数 kube::realpath
#   定义函数 kube::init::loaded


# Short-circuit if init.sh has already been sourced
# 如果脚本 hack/lib/init.sh 已经被导入，那么就直接短路退出去
# 这个脚本的主要用途就是被其它脚本导入，已到达初始化一些配置的目的
[[ $(type -t kube::init::loaded) == function ]] && return 0

# Unset CDPATH so that path interpolation can work correctly
# https://github.com/kubernetes/kubernetes/issues/52255
unset CDPATH

# Until all GOPATH references are removed from all build scripts as well,
# explicitly disable module mode to avoid picking up user-set GO111MODULE preferences.
# As individual scripts (like hack/update-vendor.sh) make use of go modules,
# they can explicitly set GO111MODULE=on
export GO111MODULE=off

# The root of the build/dist directory
KUBE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"

KUBE_OUTPUT_SUBPATH="${KUBE_OUTPUT_SUBPATH:-_output/local}"
KUBE_OUTPUT="${KUBE_ROOT}/${KUBE_OUTPUT_SUBPATH}"
KUBE_OUTPUT_BINPATH="${KUBE_OUTPUT}/bin"
echo "====[test] KUBE_OUTPUT_SUBPATH=$KUBE_OUTPUT_SUBPATH"
echo "====[test] KUBE_OUTPUT=$KUBE_OUTPUT"
echo "====[test] KUBE_OUTPUT_BINPATH=$KUBE_OUTPUT_BINPATH"

# This controls rsync compression. Set to a value > 0 to enable rsync
# compression for build container
KUBE_RSYNC_COMPRESS="${KUBE_RSYNC_COMPRESS:-0}"
echo "====[test] KUBE_RSYNC_COMPRESS=$KUBE_RSYNC_COMPRESS"

# Set no_proxy for localhost if behind a proxy, otherwise,
# the connections to localhost in scripts will time out
export no_proxy="127.0.0.1,localhost${no_proxy:+,${no_proxy}}"

# This is a symlink to binaries for "this platform", e.g. build tools.
export THIS_PLATFORM_BIN="${KUBE_ROOT}/_output/bin"

source "${KUBE_ROOT}/hack/lib/util.sh"
source "${KUBE_ROOT}/hack/lib/logging.sh"
echo "====[test] 导入脚本 ${KUBE_ROOT}/hack/lib/util.sh"
echo "====[test] 导入脚本 ${KUBE_ROOT}/hack/lib/logging.sh"


kube::log::install_errexit
kube::util::ensure-bash-version

source "${KUBE_ROOT}/hack/lib/version.sh"
source "${KUBE_ROOT}/hack/lib/golang.sh"
source "${KUBE_ROOT}/hack/lib/etcd.sh"
echo "====[test] 导入脚本 ${KUBE_ROOT}/hack/lib/version.sh"
echo "====[test] 导入脚本 ${KUBE_ROOT}/hack/lib/golang.sh"
echo "====[test] 导入脚本 ${KUBE_ROOT}/hack/lib/etcd.sh"

# 获取 主机的 系统类型 我这里时 linux x86_64
# kube::util::host_platform 函数的返回是：linux/amd64
KUBE_OUTPUT_HOSTBIN="${KUBE_OUTPUT_BINPATH}/$(kube::util::host_platform)"
export KUBE_OUTPUT_HOSTBIN
echo "====[test] KUBE_OUTPUT_HOSTBIN=$KUBE_OUTPUT_HOSTBIN"

# list of all available group versions.  This should be used when generated code
# or when starting an API server that you want to have everything.
# most preferred version for a group should appear first
# 所有 kubernetes 中不同资源的 版本号
KUBE_AVAILABLE_GROUP_VERSIONS="${KUBE_AVAILABLE_GROUP_VERSIONS:-\
v1 \
admissionregistration.k8s.io/v1 \
admissionregistration.k8s.io/v1alpha1 \
admissionregistration.k8s.io/v1beta1 \
admission.k8s.io/v1 \
admission.k8s.io/v1beta1 \
apps/v1 \
apps/v1beta1 \
apps/v1beta2 \
authentication.k8s.io/v1 \
authentication.k8s.io/v1alpha1 \
authentication.k8s.io/v1beta1 \
authorization.k8s.io/v1 \
authorization.k8s.io/v1beta1 \
autoscaling/v1 \
autoscaling/v2 \
autoscaling/v2beta1 \
autoscaling/v2beta2 \
batch/v1 \
batch/v1beta1 \
certificates.k8s.io/v1 \
certificates.k8s.io/v1beta1 \
certificates.k8s.io/v1alpha1 \
coordination.k8s.io/v1beta1 \
coordination.k8s.io/v1 \
discovery.k8s.io/v1 \
discovery.k8s.io/v1beta1 \
resource.k8s.io/v1alpha2 \
extensions/v1beta1 \
events.k8s.io/v1 \
events.k8s.io/v1beta1 \
imagepolicy.k8s.io/v1alpha1 \
networking.k8s.io/v1 \
networking.k8s.io/v1alpha1 \
networking.k8s.io/v1beta1 \
node.k8s.io/v1 \
node.k8s.io/v1alpha1 \
node.k8s.io/v1beta1 \
policy/v1 \
policy/v1beta1 \
rbac.authorization.k8s.io/v1 \
rbac.authorization.k8s.io/v1beta1 \
rbac.authorization.k8s.io/v1alpha1 \
scheduling.k8s.io/v1alpha1 \
scheduling.k8s.io/v1beta1 \
scheduling.k8s.io/v1 \
storage.k8s.io/v1beta1 \
storage.k8s.io/v1 \
storage.k8s.io/v1alpha1 \
flowcontrol.apiserver.k8s.io/v1alpha1 \
flowcontrol.apiserver.k8s.io/v1beta1 \
flowcontrol.apiserver.k8s.io/v1beta2 \
flowcontrol.apiserver.k8s.io/v1beta3 \
internal.apiserver.k8s.io/v1alpha1 \
}"
echo "====[test] k8s资源版本号 KUBE_AVAILABLE_GROUP_VERSIONS=$KUBE_AVAILABLE_GROUP_VERSIONS"

# not all group versions are exposed by the server.  This list contains those
# which are not available so we don't generate clients or swagger for them
KUBE_NONSERVER_GROUP_VERSIONS="
 abac.authorization.kubernetes.io/v0 \
 abac.authorization.kubernetes.io/v1beta1 \
 apidiscovery.k8s.io/v2beta1 \
 componentconfig/v1alpha1 \
 imagepolicy.k8s.io/v1alpha1\
 admission.k8s.io/v1\
 admission.k8s.io/v1beta1\
"
export KUBE_NONSERVER_GROUP_VERSIONS
echo "====[test] 尚未开放的k8s资源版本号 KUBE_NONSERVER_GROUP_VERSIONS=$KUBE_NONSERVER_GROUP_VERSIONS"

# This emulates "readlink -f" which is not available on MacOS X.
# Test:
# T=/tmp/$$.$RANDOM
# mkdir $T
# touch $T/file
# mkdir $T/dir
# ln -s $T/file $T/linkfile
# ln -s $T/dir $T/linkdir
# function testone() {
#   X=$(readlink -f $1 2>&1)
#   Y=$(kube::readlinkdashf $1 2>&1)
#   if [ "$X" != "$Y" ]; then
#     echo readlinkdashf $1: expected "$X", got "$Y"
#   fi
# }
# testone /
# testone /tmp
# testone $T
# testone $T/file
# testone $T/dir
# testone $T/linkfile
# testone $T/linkdir
# testone $T/nonexistant
# testone $T/linkdir/file
# testone $T/linkdir/dir
# testone $T/linkdir/linkfile
# testone $T/linkdir/linkdir
function kube::readlinkdashf {
  # run in a subshell for simpler 'cd'
  # run in a subshell for simpler 'cd'
  # 用括号将一串连续指令括起来，这种用法对 shell 来说，称为指令群组。
  # shell会以产生 subshell来执行这组指令。因此，在其中所定义的变数，仅作用于指令群组本身
  (
    if [[ -d "${1}" ]]; then # This also catch symlinks to dirs.
      cd "${1}"
      pwd -P
    else
      cd "$(dirname "${1}")"
      local f
      f=$(basename "${1}")
      if [[ -L "${f}" ]]; then
        readlink "${f}"
      else
        echo "$(pwd -P)/${f}"
      fi
    fi
  )
}

# This emulates "realpath" which is not available on MacOS X
# Test:
# T=/tmp/$$.$RANDOM
# mkdir $T
# touch $T/file
# mkdir $T/dir
# ln -s $T/file $T/linkfile
# ln -s $T/dir $T/linkdir
# function testone() {
#   X=$(realpath $1 2>&1)
#   Y=$(kube::realpath $1 2>&1)
#   if [ "$X" != "$Y" ]; then
#     echo realpath $1: expected "$X", got "$Y"
#   fi
# }
# testone /
# testone /tmp
# testone $T
# testone $T/file
# testone $T/dir
# testone $T/linkfile
# testone $T/linkdir
# testone $T/nonexistant
# testone $T/linkdir/file
# testone $T/linkdir/dir
# testone $T/linkdir/linkfile
# testone $T/linkdir/linkdir
kube::realpath() {
  if [[ ! -e "${1}" ]]; then
    echo "${1}: No such file or directory" >&2
    return 1
  fi
  kube::readlinkdashf "${1}"
}

# Marker function to indicate init.sh has been fully sourced
kube::init::loaded() {
  return 0
}
