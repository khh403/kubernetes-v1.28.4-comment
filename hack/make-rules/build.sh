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

# This script sets up a go workspace locally and builds all go components.

# 设置 Bash 脚本中的一些错误处理选项
set -o errexit  # set -e 在执行脚本时，如果任何一条命令的退出状态不是 0（即失败），则立即终止脚本的执行。一旦发生错误，脚本将会立即退出，不会继续执行后续的命令
set -o nounset  # set -u 在执行脚本时，如果试图使用未设置过的变量，则立即终止脚本的执行。这样可以帮助你避免因为意外地使用未定义的变量而导致的错误。
set -o pipefail # 在执行管道命令时，如果管道中任何一个命令失败（返回非零退出状态），则整个管道的退出状态将是失败的。
                # 默认情况下，Bash 只会将管道中最后一个命令的退出状态作为整个管道的退出状态，这可能会掩盖掉前面命令的失败情况。
                # 启用 pipefail 可以更准确地反映整个管道执行的成功与否。

# 设置 KUBE_ROOT - 当前项目的工作路径
KUBE_ROOT=$(dirname "${BASH_SOURCE[0]}")/../..
echo "====[test] KUBE_ROOT=$KUBE_ROOT"

# 设置 KUBE_VERBOSE=1
KUBE_VERBOSE="${KUBE_VERBOSE:-1}"
echo "====[test] KUBE_VERBOSE=$KUBE_VERBOSE"

# 导入脚本 ${KUBE_ROOT}/hack/lib/init.sh
source "${KUBE_ROOT}/hack/lib/init.sh"
echo "====[test] 导入脚本 ${KUBE_ROOT}/hack/lib/init.sh"

# hack/lib/golang.sh
kube::golang::build_binaries "$@"
kube::golang::place_bins
