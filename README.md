# Home Assistant – Shared Python Library Build Test

Minimal test project for **two Home Assistant apps sharing one Python library**.

The important point is that the two apps do **not** copy the library from a sibling
directory. Each app installs the same package from a Git repository:

    pip install "git+https://github.com/OWNER/REPO.git@main#subdirectory=shared/jpt_test_lib"

This matches the intended "Variant A" architecture and works with Home Assistant's
per-app Docker build context.

## Structure

    .
    ├── repository.yaml
    ├── shared/
    │   └── jpt_test_lib/
    │       ├── pyproject.toml
    │       └── src/jpt_test_lib/__init__.py
    ├── app-one/
    │   ├── config.yaml
    │   ├── Dockerfile
    │   └── run.sh
    └── app-two/
        ├── config.yaml
        ├── Dockerfile
        └── run.sh

## Important

Replace `LIB_REPO` in both Dockerfiles with the Git URL of the repository containing
the `shared/jpt_test_lib` directory.

For example:

    ARG LIB_REPO=https://github.com/JPT77/JPTs-Homeassist-Addons.git
    ARG LIB_REF=main

and:

    RUN pip install --no-cache-dir \
        "git+${LIB_REPO}@${LIB_REF}#subdirectory=shared/jpt_test_lib"

For the first test, both apps deliberately use the exact same library version.

## What the test proves

App One prints:

    shared library OK: hello from shared library

App Two prints the same message.

If both apps build and start, the important mechanism is proven:

    HA app 1 ─┐
              ├── pip install ──> same Python package
    HA app 2 ─┘

No Python library code is duplicated into either app.

## Home Assistant test

Copy the repository to `/addons/ha-shared-library-test/` on the test HA system,
or use the local-app development setup.

Then add/install the two apps from the local repository.

The apps have no hardware access and do not implement LoRa.

## Local Docker test

After replacing LIB_REPO with a real Git repository URL:

    docker build ./app-one
    docker build ./app-two

The current Home Assistant documentation uses the app's Dockerfile as the source
of truth for the build. The local-app documentation also supports building apps
locally when no pre-built `image:` is configured.

## Why Git?

A Home Assistant app is built from its own directory. Therefore a Dockerfile in
`app-one/` cannot reliably do `COPY ../shared/...`.

Installing the shared library as a normal Python package avoids that build-context
problem.

Later, the LoRa library can replace `jpt_test_lib` without changing the basic
architecture.
