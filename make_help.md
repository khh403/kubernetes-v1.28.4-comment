# Makefile & make 帮助手册

## make help

```azure
--------------------------------------------------------------------------------
all
# Build code.
#
# Args:
#   WHAT: Directory names to build.  If any of these directories has a 'main'
#     package, the build will produce executable files under _output/bin.
#     If not specified, "everything" will be built.
#   GOFLAGS: Extra flags to pass to 'go' when building.
#   GOLDFLAGS: Extra linking flags passed to 'go' when building.
#   GOGCFLAGS: Additional go compile flags passed to 'go' when building.
#
# Example:
#   make
#   make all
#   make all WHAT=cmd/kubelet GOFLAGS=-v
#   make all GOLDFLAGS=""
#     Note: Specify GOLDFLAGS as an empty string for building unstripped binaries, which allows
#           you to use code debugging tools like delve. When GOLDFLAGS is unspecified, it defaults
#           to "-s -w" which strips debug information. Other flags that can be used for GOLDFLAGS
#           are documented at https://golang.org/cmd/link/
---------------------------------------------------------------------------------
check
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
---------------------------------------------------------------------------------
clean
# Remove all build artifacts.
#
# Example:
#   make clean
#
# TODO(thockin): call clean_generated when we stop committing generated code.
---------------------------------------------------------------------------------
clean_generated
# Remove all auto-generated artifacts. Generated artifacts in staging folder should not be removed as they are not
# generated using generated_files.
#
# Example:
#   make clean_generated
---------------------------------------------------------------------------------
clean_meta
# Remove make-related metadata files.
#
# Example:
#   make clean_meta
---------------------------------------------------------------------------------
dependencycheck
genyaml
kubemark
genman
preferredimports
genutils
kube-controller-manager
kube-scheduler
clicheck
genkubedocs
importverifier
cloud-controller-manager
kubeadm
kubelet
kube-proxy
genswaggertypedocs
linkcheck
kube-apiserver
kubectl
gendocs
kubectl-convert
# Add rules for all directories in cmd/
#
# Example:
#   make kubectl kube-proxy
---------------------------------------------------------------------------------
cross
# Cross-compile for all platforms
# Use the 'cross-in-a-container' target to cross build when already in
# a container vs. creating a new container to build from (build-image)
# Useful for running in GCB.
#
# Example:
#   make cross
#   make cross-in-a-container
---------------------------------------------------------------------------------
cross-in-a-container
# Cross-compile for all platforms
# Use the 'cross-in-a-container' target to cross build when already in
# a container vs. creating a new container to build from (build-image)
# Useful for running in GCB.
#
# Example:
#   make cross
#   make cross-in-a-container
---------------------------------------------------------------------------------
generated_files
# Produce auto-generated files needed for the build.
#
# Example:
#   make generated_files
---------------------------------------------------------------------------------
ginkgo
# Build ginkgo
#
# Example:
# make ginkgo
---------------------------------------------------------------------------------
help
# Print make targets and help info
#
# Example:
# make help
---------------------------------------------------------------------------------
package
# Package tarballs
# Use the 'package-tarballs' target to run the final packaging steps of
# a release.
#
# Example:
#   make package-tarballs
---------------------------------------------------------------------------------
package-tarballs
# Package tarballs
# Use the 'package-tarballs' target to run the final packaging steps of
# a release.
#
# Example:
#   make package-tarballs
---------------------------------------------------------------------------------
quick-release
# Build a release, but skip tests
#
# Args:
#   KUBE_RELEASE_RUN_TESTS: Whether to run tests. Set to 'y' to run tests anyways.
#   KUBE_FASTBUILD: Whether to cross-compile for other architectures. Set to 'false' to do so.
#   KUBE_DOCKER_REGISTRY: Registry of released images, default to k8s.gcr.io
#   KUBE_BASE_IMAGE_REGISTRY: Registry of base images for controlplane binaries, default to k8s.gcr.io
#
# Example:
#   make release-skip-tests
#   make quick-release
---------------------------------------------------------------------------------
quick-release-images
# Build release images, but only for linux/amd64
#
# Args:
#   KUBE_FASTBUILD: Whether to cross-compile for other architectures. Set to 'false' to do so.
#   KUBE_BUILD_CONFORMANCE: Whether to build conformance testing image as well. Set to 'y' to do so.
#
# Example:
#   make quick-release-images
---------------------------------------------------------------------------------
quick-verify
# Runs only the presubmission verifications that aren't slow.
#
# Example:
#   make quick-verify
---------------------------------------------------------------------------------
release
# Build a release
# Use the 'release-in-a-container' target to build the release when already in
# a container vs. creating a new container to build in using the 'release'
# target.  Useful for running in GCB.
#
# Example:
#   make release
#   make release-in-a-container
---------------------------------------------------------------------------------
release-images
# Build release images
#
# Args:
#   KUBE_BUILD_CONFORMANCE: Whether to build conformance testing image as well. Set to 'n' to skip.
#
# Example:
#   make release-images
---------------------------------------------------------------------------------
release-in-a-container
# Build a release
# Use the 'release-in-a-container' target to build the release when already in
# a container vs. creating a new container to build in using the 'release'
# target.  Useful for running in GCB.
#
# Example:
#   make release
#   make release-in-a-container
---------------------------------------------------------------------------------
release-skip-tests
# Build a release, but skip tests
#
# Args:
#   KUBE_RELEASE_RUN_TESTS: Whether to run tests. Set to 'y' to run tests anyways.
#   KUBE_FASTBUILD: Whether to cross-compile for other architectures. Set to 'false' to do so.
#   KUBE_DOCKER_REGISTRY: Registry of released images, default to k8s.gcr.io
#   KUBE_BASE_IMAGE_REGISTRY: Registry of base images for controlplane binaries, default to k8s.gcr.io
#
# Example:
#   make release-skip-tests
#   make quick-release
---------------------------------------------------------------------------------
test
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
---------------------------------------------------------------------------------
test-cmd
# Build and run cmdline tests.
#
# Args:
#   WHAT: List of tests to run, check test/cmd/legacy-script.sh for names.
#     For example, WHAT=deployment will run run_deployment_tests function.
# Example:
#   make test-cmd
#   make test-cmd WHAT="deployment impersonation"
---------------------------------------------------------------------------------
test-e2e-kubeadm
# Build and run kubeadm end-to-end tests.
#
# Args:
#  FOCUS: Regexp that matches the tests to be run.  Defaults to "".
#  SKIP: Regexp that matches the tests that needs to be skipped.  Defaults
#    to "".
#  RUN_UNTIL_FAILURE: If true, pass --untilItFails to ginkgo so tests are run
#    repeatedly until they fail. Defaults to false.
#  ARTIFACTS: Local directory to save test artifacts into. Defaults to "/tmp/_artifacts".
#  PARALLELISM: The number of ginkgo nodes to run.  If empty ginkgo default
#    parallelism (cores - 1) is used
#  BUILD: Build kubeadm end-to-end tests. Defaults to true.
#
# Example:
#   make test-e2e-kubeadm
#   make test-e2e-kubeadm FOCUS=kubeadm-config
#   make test-e2e-kubeadm SKIP=kubeadm-config
#
# Build and run tests.
---------------------------------------------------------------------------------
test-e2e-node
# Build and run node end-to-end tests.
#
# Args:
#  FOCUS: Regexp that matches the tests to be run.  Defaults to "".
#  SKIP: Regexp that matches the tests that needs to be skipped.
#    Defaults to "\[Flaky\]|\[Slow\]|\[Serial\]".
#  TEST_ARGS: A space-separated list of arguments to pass to node e2e test.
#    Defaults to "".
#  RUN_UNTIL_FAILURE: If true, pass --untilItFails to ginkgo so tests are run
#    repeatedly until they fail.  Defaults to false.
#  REMOTE: If true, run the tests on a remote host instance on GCE.  Defaults
#    to false.
#  ARTIFACTS: Local directory to scp test artifacts into from the remote hosts
#    for REMOTE=true. Local directory to write juntil xml results into for REMOTE=false.
#    Defaults to "/tmp/_artifacts/$(date +%y%m%dT%H%M%S)".
#  LIST_IMAGES: For REMOTE=true only. If true, don't run tests. Just output the
#    list of available images for testing.  Defaults to false.
#  TIMEOUT: For REMOTE=true only. How long (in golang duration format) to wait
#    for ginkgo tests to complete. Defaults to 45m.
#  PARALLELISM: The number of ginkgo nodes to run.  Defaults to 8.
#  RUNTIME: Container runtime to use (eg. docker, remote).
#    Defaults to "docker".
#  CONTAINER_RUNTIME_ENDPOINT: remote container endpoint to connect to.
#    Used when RUNTIME is set to "remote".
#  IMAGE_SERVICE_ENDPOINT: remote image endpoint to connect to, to prepull images.
#    Used when RUNTIME is set to "remote".
#  IMAGE_CONFIG_FILE: path to a file containing image configuration.
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
#    $IMAGES.  Defaults to "kubernetes-node-e2e-images".
#  INSTANCE_PREFIX: For REMOTE=true only.  Instances created from images will
#    have the name "${INSTANCE_PREFIX}-${IMAGE_NAME}".  Defaults to "test".
#  INSTANCE_METADATA: For REMOTE=true and running on GCE only.
#  GUBERNATOR: For REMOTE=true only. Produce link to Gubernator to view logs.
#    Defaults to false.
#  TEST_SUITE: For REMOTE=true only. Test suite to use. Defaults to "default".
#
# Example:
#   make test-e2e-node FOCUS=Kubelet SKIP=container
#   make test-e2e-node REMOTE=true DELETE_INSTANCES=true
#   make test-e2e-node TEST_ARGS='--kubelet-flags="--cgroups-per-qos=true"'
# Build and run tests.
---------------------------------------------------------------------------------
test-integration
# Build and run integration tests.
#
# Args:
#   WHAT: Directory names to test.  All *_test.go files under these
#     directories will be run.  If not specified, "everything" will be tested.
#
# Example:
#   make test-integration
---------------------------------------------------------------------------------
update
# Runs all the generated updates.
#
# Example:
# make update
---------------------------------------------------------------------------------
verify
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
---------------------------------------------------------------------------------
vet
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
---------------------------------------------------------------------------------

```
