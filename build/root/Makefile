# Copyright 2016 The Kubernetes Authors.
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

# 编译选项 DBG_MAKEFILE 用于调试 Makefile 的选项，这个一般都是在命令行输入选项 DBG_MAKEFILE=1，即 DBG_MAKEFILE=1 make all
DBG_MAKEFILE ?=
# 在 Makefile 中，?= 是一个条件赋值操作符，它的作用是：如果变量未定义，则使用?=右侧的值来定义变量；如果变量已经被定义了，则忽略?=右侧的值，保留原有的定义。
# 是 Makefile 中的一个条件判断语句，用于检查变量 DBG_MAKEFILE 的值是否等于 1。如果条件成立（即 DBG_MAKEFILE 的值为 1），则执行 ifeq 和 endif 之间的代码块，否则跳过。
#$(info ====[test] Makefile,DBG_MAKEFILE=$(DBG_MAKEFILE))
ifeq ($(DBG_MAKEFILE),1)
	# 开启 make DBG 会打印如下内容:
    $(warning ***** starting Makefile for goal(s) "$(MAKECMDGOALS)")
    # ***** starting Makefile for goal(s) ""
    # MAKECMDGOALS 这个变量怎么来的还不知道，显然这里变量 MAKECMDGOALS 没有任何只，就是一个空字符串
    $(warning ***** $(shell date))
    # ***** 2023年 11月 28日 星期二 14:53:14 CST
    # 使 make 在执行过程中打印更多的详细信息
else
    MAKEFLAGS += -s
    # 在 Makefile 中，+= 是一个赋值操作符，用于向变量中追加内容。它的作用是将右侧的值追加到左侧的变量值之后。如果左侧的变量尚未定义，则等同于简单的赋值操作符 =。
    # 如果我们不调试 Makefile，就不要回显 recipes，使用 MAKEFLAGS 设置编译选项 -s 即 silent 安静模式
	# 在Makefile中，MAKEFLAGS 是一个特殊的内置变量，用于传递给 make 命令的标志和选项。
	#     -s 标志用于使Make在执行过程中处于安静模式，即不输出命令的执行过程，只输出结果。
	#     因此，MAKEFLAGS += -s 的作用是在Make执行时将安静模式标志 -s 添加到MAKEFLAGS 变量中，以在执行过程中关闭大部分输出信息。
endif
#$(info ====[test] Makefile,MAKEFLAGS=$(MAKEFLAGS))


# Old-skool build tools.
# 老式的构建工具
#
# Commonly used targets (see each target for more information):
#   all: Build code. 编译所有组件
#   test: Run tests. 测试
#   clean: Clean up. 清理

# It's necessary to set this because some environments don't link sh -> bash.
# 配置 shell 的路径，目的是直接使用 bash shell 而不是系统默认的 sh 环境
SHELL := /usr/bin/env bash -o errexit -o pipefail -o nounset
#$(info ====[test] Makefile,SHELL=$(SHELL))

# ./hack/lib/logging.sh 这个文件用于 bash 脚本程序记录日志的一些配置，比如打印函数定义等
BASH_ENV := ./hack/lib/logging.sh
#$(info ====[test] Makefile,BASH_ENV=$(BASH_ENV))

# Define variables so `make --warn-undefined-variables` works.
# PRINT_HELP 变量 表示是否打印帮助信息
# 条件赋值 ( ?= ) 如果变量未定义，则使用符号中的值定义变量。如果该变量已经赋值，则该赋值语句无效。
PRINT_HELP ?=
#$(info ====[test] Makefile,PRINT_HELP=$(PRINT_HELP))

# We don't need make's built-in rules.
# 扩展编译选项 --no-builtin-rules
MAKEFLAGS += --no-builtin-rules
#$(info ====[test] Makefile,MAKEFLAGS=$(MAKEFLAGS))

# 空的 target
.SUFFIXES:

# Constants used throughout.
# 一些常量的初始化
# 空的 target
.EXPORT_ALL_VARIABLES:
# OUT_DIR 表示最终生成的 target 文件的目录，包括可执行文件、镜像、中间文件等
OUT_DIR ?= _output
#$(info ====[test] Makefile,OUT_DIR=$(OUT_DIR))

# BIN_DIR 表示生成 target 可执行文件的目录
BIN_DIR := $(OUT_DIR)/bin
#$(info ====[test] Makefile,BIN_DIR=$(BIN_DIR))

# kubernetes 的项目跟路径，就是 go.mod 里面模块的名字
PRJ_SRC_PATH := k8s.io/kubernetes
#$(info ====[test] Makefile,PRJ_SRC_PATH=$(PRJ_SRC_PATH))

# 设置 vendor 模式
# KUBE_GOFLAGS 已经被废弃，后面都使用 GOFLAGS
# go build 编译 golang 程序的时候，使用 GOFLAGS 来指定编译标识，而本项目单独给 makefile 定义了编译选项 KUBE_GOFLAGS 来表示
# 在命令行编译 k8s 的时候，如果要给 go build 配置编译选项，那么就在命令行上指定 KUBE_GOFLAGS
ifdef KUBE_GOFLAGS
$(info KUBE_GOFLAGS is now deprecated. Please use GOFLAGS instead.)
ifndef GOFLAGS
GOFLAGS := $(KUBE_GOFLAGS)
unexport KUBE_GOFLAGS
else
$(error Both KUBE_GOFLAGS and GOFLAGS are set. Please use just GOFLAGS)
endif
endif
#$(info ====[test] Makefile,GOFLAGS=$(GOFLAGS))

# This controls the verbosity of the build.  Higher numbers mean more output.
# 控制脚本输出和日志记录的详细程度, KUBE_VERBOSE=1
KUBE_VERBOSE ?= 1
#$(info ====[test] Makefile,KUBE_VERBOSE=$(KUBE_VERBOSE))

# make all 编译所有组件
# 真正执行编译动作的脚本是 hack/make-rules/build.sh $(WHAT)
define ALL_HELP_INFO
# Build code.
#
# Args:
#   WHAT: Directory names to build.  If any of these directories has a 'main'
#     package, the build will produce executable files under $(OUT_DIR)/bin.
#     If not specified, "everything" will be built.
#     "vendor/<module>/<path>" is accepted as alias for "<module>/<path>".
#     "ginkgo" is an alias for the ginkgo CLI.
#   GOFLAGS: Extra flags to pass to 'go' when building.
#   GOLDFLAGS: Extra linking flags passed to 'go' when building.
#   GOGCFLAGS: Additional go compile flags passed to 'go' when building.
#   DBG: If set to "1", build with optimizations disabled for easier
#     debugging.  Any other value is ignored.
#
# Example:
#   make
#   make all
#   make all WHAT=cmd/kubelet GOFLAGS=-v
#   make all DBG=1
#     Note: Specify DBG=1 for building unstripped binaries, which allows you to use code debugging
#           tools like delve. When DBG is unspecified, it defaults to "-s -w" which strips debug
#           information.
endef

# 把 all 声明成 伪目标，也就是不会生成 target 文件，只执行为目标后面的命令
.PHONY: all
ifeq ($(PRINT_HELP),y)
all:
# PRINT_HELP=y make
	echo "$$ALL_HELP_INFO"
else
all:
# make all WHAT=cmd/kubelet GOFLAGS=-v
	hack/make-rules/build.sh $(WHAT)
endif

define GINKGO_HELP_INFO
# Build ginkgo
#
# Example:
# make ginkgo
endef
.PHONY: ginkgo
ifeq ($(PRINT_HELP),y)
ginkgo:
	echo "$$GINKGO_HELP_INFO"
else
ginkgo:
	hack/make-rules/build.sh github.com/onsi/ginkgo/v2/ginkgo
endif

define VERIFY_HELP_INFO
# Runs all the presubmission verifications.
#
# Args:
#   BRANCH: Branch to be passed to verify-vendor.sh script.
#   WHAT: List of checks to run
#
# Example:
#   make verify
#   make verify BRANCH=branch_x
#   make verify WHAT="gofmt typecheck"
endef
.PHONY: verify
ifeq ($(PRINT_HELP),y)
verify:
	echo "$$VERIFY_HELP_INFO"
else
verify:
	KUBE_VERIFY_GIT_BRANCH=$(BRANCH) hack/make-rules/verify.sh
endif

define QUICK_VERIFY_HELP_INFO
# Runs only the presubmission verifications that aren't slow.
#
# Example:
#   make quick-verify
endef
.PHONY: quick-verify
ifeq ($(PRINT_HELP),y)
quick-verify:
	echo "$$QUICK_VERIFY_HELP_INFO"
else
quick-verify:
	QUICK=true SILENT=false hack/make-rules/verify.sh
endif

define UPDATE_HELP_INFO
# Runs all the update scripts.
#
# Example:
# make update
endef
.PHONY: update
ifeq ($(PRINT_HELP),y)
update:
	echo "$$UPDATE_HELP_INFO"
else
update:
	hack/make-rules/update.sh
endif

define CHECK_TEST_HELP_INFO
# Build and run tests.
#
# Args:
#   WHAT: Directory names to test.  All *_test.go files under these
#     directories will be run.  If not specified, "everything" will be tested.
#   TESTS: Same as WHAT.
#   KUBE_COVER: Whether to run tests with code coverage. Set to 'y' to enable coverage collection.
#   GOFLAGS: Extra flags to pass to 'go' when building.
#   GOLDFLAGS: Extra linking flags to pass to 'go' when building.
#   GOGCFLAGS: Additional go compile flags passed to 'go' when building.
#
# Example:
#   make check
#   make test
#   make check WHAT=./pkg/kubelet GOFLAGS=-v
endef
.PHONY: check test
ifeq ($(PRINT_HELP),y)
check test:
	echo "$$CHECK_TEST_HELP_INFO"
else
check test:
	hack/make-rules/test.sh $(WHAT) $(TESTS)
endif

define TEST_IT_HELP_INFO
# Build and run integration tests.
#
# Args:
#   WHAT: Directory names to test.  All *_test.go files under these
#     directories will be run.  If not specified, "everything" will be tested.
#
# Example:
#   make test-integration
#   make test-integration WHAT=./test/integration/kubelet GOFLAGS="-v -coverpkg=./pkg/kubelet/..." KUBE_COVER="y"
endef
.PHONY: test-integration
ifeq ($(PRINT_HELP),y)
test-integration:
	echo "$$TEST_IT_HELP_INFO"
else
test-integration:
	hack/make-rules/test-integration.sh $(WHAT)
endif

define TEST_E2E_NODE_HELP_INFO
# Build and run node end-to-end tests.
#
# Args:
#  FOCUS: Regexp that matches the tests to be run.  Defaults to "".
#  SKIP: Regexp that matches the tests that needs to be skipped.
#    Defaults to "\[Flaky\]|\[Slow\]|\[Serial\]".
#  TEST_ARGS: A space-separated list of arguments to pass to node e2e test.
#    Defaults to "".
#  RUN_UNTIL_FAILURE: If true, pass --until-it-fails=true to ginkgo so tests are run
#    repeatedly until they fail.  Defaults to false.
#  REMOTE: If true, run the tests on a remote host.  Defaults to false.
#  REMOTE_MODE: For REMOTE=true only.  Mode for remote execution (eg. gce, ssh).
#    If set to "gce", an instance can be provisioned or reused from GCE. If set
#    to "ssh", provided `HOSTS` must be IPs or resolvable.  Defaults to "gce".
#  ARTIFACTS: Local directory to scp test artifacts into from the remote hosts
#    for REMOTE=true. Local directory to write juntil xml results into for REMOTE=false.
#    Defaults to "/tmp/_artifacts/$$(date +%y%m%dT%H%M%S)".
#  TIMEOUT: For REMOTE=true only. How long (in golang duration format) to wait
#    for ginkgo tests to complete. Defaults to 45m.
#  PARALLELISM: The number of ginkgo nodes to run.  Defaults to 8.
#  CONTAINER_RUNTIME_ENDPOINT: remote container endpoint to connect to.
#    Defaults to "/run/containerd/containerd.sock".
#  IMAGE_SERVICE_ENDPOINT: remote image endpoint to connect to, to prepull images.
#    Used when RUNTIME is set to "remote".
#  IMAGE_CONFIG_FILE: path to a file containing image configuration.
#  IMAGE_CONFIG_DIR: path to image config files.
#  SYSTEM_SPEC_NAME: The name of the system spec to be used for validating the
#    image in the node conformance test. The specs are located at
#    test/e2e_node/system/specs/. For example, "SYSTEM_SPEC_NAME=gke" will use
#    the spec at test/e2e_node/system/specs/gke.yaml. If unspecified, the
#    default built-in spec (system.DefaultSpec) will be used.
#  IMAGES: For REMOTE=true only.  Comma delimited list of images for creating
#    remote hosts to run tests against.  Defaults to a recent image.
#  HOSTS: For REMOTE=true only.  Comma delimited list of running gce hosts to
#    run tests against.  Defaults to "".
#  DELETE_INSTANCES: For REMOTE=true only.  Delete any instances created as
#    part of this test run.  Defaults to false.
#  PREEMPTIBLE_INSTANCES: For REMOTE=true only.  Mark created gce instances
#    as preemptible.  Defaults to false.
#  CLEANUP: For REMOTE=true only.  If false, do not stop processes or delete
#    test files on remote hosts.  Defaults to true.
#  IMAGE_PROJECT: For REMOTE=true only.  Project containing images provided to
#    $$IMAGES.  Defaults to "cos-cloud".
#  INSTANCE_PREFIX: For REMOTE=true only.  Instances created from images will
#    have the name "$${INSTANCE_PREFIX}-$${IMAGE_NAME}".  Defaults to "test".
#  INSTANCE_METADATA: For REMOTE=true and running on GCE only.
#  GUBERNATOR: For REMOTE=true only. Produce link to Gubernator to view logs.
#    Defaults to false.
#  TEST_SUITE: For REMOTE=true only. Test suite to use. Defaults to "default".
#  SSH_USER: For REMOTE=true only  SSH username to use.
#  SSH_KEY: For REMOTE=true only. Path to SSH key to use.
#  SSH_OPTIONS: For REMOTE=true only. SSH options to use.
#  INSTANCE_TYPE: For REMOTE=true only. Machine type to use.
#  NODE_ENV: For REMOTE=true only. Additional metadata keys to add the instance.
#  RUNTIME_CONFIG: The runtime configuration for the API server on the node e2e tests.
#
# Example:
#   make test-e2e-node FOCUS=Kubelet SKIP=container
#   make test-e2e-node REMOTE=true DELETE_INSTANCES=true
#   make test-e2e-node TEST_ARGS='--kubelet-flags="--cgroups-per-qos=true"'
# Build and run tests.
endef
.PHONY: test-e2e-node
ifeq ($(PRINT_HELP),y)
test-e2e-node:
	echo "$$TEST_E2E_NODE_HELP_INFO"
else
test-e2e-node: ginkgo
	hack/make-rules/test-e2e-node.sh
endif

define TEST_CMD_HELP_INFO
# Build and run cmdline tests.
#
# Args:
#   WHAT: List of tests to run, check test/cmd/legacy-script.sh for names.
#     For example, WHAT=deployment will run run_deployment_tests function.
# Example:
#   make test-cmd
#   make test-cmd WHAT="deployment impersonation"
endef
.PHONY: test-cmd
ifeq ($(PRINT_HELP),y)
test-cmd:
	echo "$$TEST_CMD_HELP_INFO"
else
test-cmd:
	hack/make-rules/test-cmd.sh
endif

define CLEAN_HELP_INFO
# Remove all build artifacts.
#
# Example:
#   make clean
endef
.PHONY: clean
ifeq ($(PRINT_HELP),y)
clean:
	echo "$$CLEAN_HELP_INFO"
else
clean:
	build/make-clean.sh
	hack/make-rules/clean.sh
endif


# TODO(thockin): Remove this in v1.29.
.PHONY: generated_files
generated_files:
	echo "'make generated_files' is deprecated.  Please use hack/update-codegen.sh instead."
ifneq ($(PRINT_HELP), y)
	false
endif


define VET_HELP_INFO
# Run 'go vet'.
#
# Args:
#   WHAT: Directory names to vet.  All *.go files under these
#     directories will be vetted.  If not specified, "everything" will be
#     vetted.
#
# Example:
#   make vet
#   make vet WHAT=./pkg/kubelet
endef
.PHONY: vet
ifeq ($(PRINT_HELP),y)
vet:
	echo "$$VET_HELP_INFO"
else
vet:
	hack/make-rules/vet.sh $(WHAT)
endif

define LINT_HELP_INFO
# Run golangci-lint
#
# Example:
#   make lint
endef
.PHONY: lint
ifeq ($(PRINT_HELP),y)
lint:
	echo "$$LINT_HELP_INFO"
else
lint:
	hack/verify-golangci-lint.sh
endif

define RELEASE_HELP_INFO
# Build a release
# Use the 'release-in-a-container' target to build the release when already in
# a container vs. creating a new container to build in using the 'release'
# target.  Useful for running in GCB.
#
# Example:
#   make release
#   make release-in-a-container
endef
.PHONY: release release-in-a-container
ifeq ($(PRINT_HELP),y)
release release-in-a-container:
	echo "$$RELEASE_HELP_INFO"
else
release release-in-a-container: KUBE_BUILD_CONFORMANCE = y
release:
	build/release.sh
release-in-a-container:
	build/release-in-a-container.sh
endif

define RELEASE_IMAGES_HELP_INFO
# Build release images
#
# Args:
#   KUBE_BUILD_CONFORMANCE: Whether to build conformance testing image as well. Set to 'n' to skip.
#   DBG: If set to "1", build with optimizations disabled for easier debugging. Any other value is ignored.
#
# Example:
#   make release-images
#   make release-images DBG=1
#     Note: Specify DBG=1 for building unstripped binaries, which allows you to use code debugging
#           tools like delve. When DBG is unspecified, it defaults to "-s -w" which strips debug
#           information.
endef
.PHONY: release-images
ifeq ($(PRINT_HELP),y)
# KUBE_BUILD_CONFORMANCE - 用来控制是否创建一致性测试镜像
release-images: KUBE_BUILD_CONFORMANCE = y
release-images:
	echo "$$RELEASE_IMAGES_HELP_INFO"
else
release-images:
	build/release-images.sh
endif

define RELEASE_SKIP_TESTS_HELP_INFO
# Build a release, but skip tests
#
# Args:
#   KUBE_RELEASE_RUN_TESTS: Whether to run tests. Set to 'y' to run tests anyways.
#   KUBE_FASTBUILD: Whether to cross-compile for other architectures. Set to 'false' to do so.
#   KUBE_DOCKER_REGISTRY: Registry of released images, default to registry.k8s.io
#   KUBE_BASE_IMAGE_REGISTRY: Registry of base images for controlplane binaries, default to registry.k8s.io/build-image
#
# Example:
#   make release-skip-tests
#   make quick-release
endef
.PHONY: release-skip-tests quick-release
ifeq ($(PRINT_HELP),y)
release-skip-tests quick-release:
	echo "$$RELEASE_SKIP_TESTS_HELP_INFO"
else
release-skip-tests quick-release: KUBE_RELEASE_RUN_TESTS = n
release-skip-tests quick-release: KUBE_FASTBUILD = true
release-skip-tests quick-release:
	build/release.sh
endif

define QUICK_RELEASE_IMAGES_HELP_INFO
# Build release images, but only for linux/amd64
#
# Args:
#   KUBE_FASTBUILD: Whether to cross-compile for other architectures. Set to 'false' to do so.
#   KUBE_BUILD_CONFORMANCE: Whether to build conformance testing image as well. Set to 'y' to do so.
#   DBG: If set to "1", build with optimizations disabled for easier debugging. Any other value is ignored.
#
# Example:
#   make quick-release-images
#   make quick-release-images DBG=1
#     Note: Specify DBG=1 for building unstripped binaries, which allows you to use code debugging
#           tools like delve. When DBG is unspecified, it defaults to "-s -w" which strips debug
#           information.
endef
.PHONY: quick-release-images
ifeq ($(PRINT_HELP),y)
quick-release-images:
	echo "$$QUICK_RELEASE_IMAGES_HELP_INFO"
else
quick-release-images: KUBE_FASTBUILD = true
quick-release-images:
	build/release-images.sh
endif

define PACKAGE_HELP_INFO
# Package tarballs
# Use the 'package-tarballs' target to run the final packaging steps of
# a release.
#
# Example:
#   make package-tarballs
endef
.PHONY: package package-tarballs
ifeq ($(PRINT_HELP),y)
package package-tarballs:
	echo "$$PACKAGE_HELP_INFO"
else
package-tarballs: KUBE_BUILD_CONFORMANCE = y
package package-tarballs:
	build/package-tarballs.sh
endif

define CROSS_HELP_INFO
# Cross-compile for all platforms
# Use the 'cross-in-a-container' target to cross build when already in
# a container vs. creating a new container to build from (build-image)
# Useful for running in GCB.
#
# Example:
#   make cross
#   make cross-in-a-container
endef
.PHONY: cross cross-in-a-container
ifeq ($(PRINT_HELP),y)
cross cross-in-a-container:
	echo "$$CROSS_HELP_INFO"
else
cross cross-in-a-container: KUBE_BUILD_CONFORMANCE = y
cross:
	hack/make-rules/cross.sh
cross-in-a-container: KUBE_OUTPUT_SUBPATH = $(OUT_DIR)/dockerized
cross-in-a-container:
ifeq (,$(wildcard /.dockerenv))
	echo -e "\nThe 'cross-in-a-container' target can only be used from within a docker container.\n"
else
	hack/make-rules/cross.sh
endif
endif

define CMD_HELP_INFO
# Add rules for all directories in cmd/
#
# Example:
#   make kubectl kube-proxy
endef
#TODO: make EXCLUDE_TARGET auto-generated when there are other files in cmd/
EXCLUDE_TARGET=OWNERS
CMD_TARGET = $(filter-out %$(EXCLUDE_TARGET),$(notdir $(abspath $(wildcard cmd/*/))))
.PHONY: $(CMD_TARGET)
ifeq ($(PRINT_HELP),y)
$(CMD_TARGET):
	echo "$$CMD_HELP_INFO"
else
$(CMD_TARGET):
	hack/make-rules/build.sh cmd/$@
endif

define HELP_INFO
# Print make targets and help info
#
# Example:
# make help
endef
.PHONY: help
ifeq ($(PRINT_HELP),y)
help:
	echo "$$HELP_INFO"
else
help:
	hack/make-rules/make-help.sh
endif
