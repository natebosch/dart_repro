# Kernel compiled with build_runner is --async-async

Running from source or from a kernel snapshot built by the VM behaves like
`--sync-async`. Running from kernel built modularly with `build_runner` behaves
like `--async-async`.

Tested at Dart version 2.1.0-dev.7.1

## Seeing the behavior:

Run from source:

    dart bin/try.dart

Output:

    before
    running
    after


Run from kernel:

    dart --snapshot=bin/try.dart.dill --snapshot-kind=kernel bin/try.dart
    dart bin/try.dart.dill

Output:

    before
    running
    after


Run from kernel built with `build_runner`:

    pub get
    pub run build_runner build
    dart .dart_tool/build/generated/dart_repro/bin/try.vm.app.dill

Output:

    before
    after
    running

## Kernel dumps

`kernel_dumps/from_vm` is the dumped kernel from the `--snapshot` output.
`kernel_dumps/from_build_runner` is the dumped kernel produced by the `pub run
build_runner build`.

Take a diff to see that there are small differences around the async methods.
