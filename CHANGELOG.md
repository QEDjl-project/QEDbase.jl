# Changelog

## Version 0.2.0

[diff since 0.1.6](https://github.com/QEDjl-project/QEDbase.jl/compare/release-0.1.6...release-0.2.0)

This release is part of the restructuring processes of QED.jl (see https://github.com/QEDjl-project/QED.jl/issues/35 for details).
It is a breaking release, indicated by the bumped minor version, because we don't have a major version for this
yet.

### Breaking changes

With this release, we remove the actual core functionality and move it to [`QEDcore.jl`](https://github.com/QEDjl-project/QEDcore.jl).
The purpose of this package is transformed from the tool box status to the provider of all
common interfaces.

### New features

This version introduces the interfaces used downstream in `QEDcore.jl` and
`QEDprocesses.jl` . Among the interfaces already
present in `QEDbase.jl`, we add

- the process interface from `QEDprocesses.jl`
- the model interface from `QEDprocesses.jl`
- the particle stateful interface
- the phase space point interface
- the differential probability and cross section interface from `QEDprocesses.jl`

See https://github.com/QEDjl-project/QEDbase.jl/pull/68 for details.

### Maintenance

Beside the new interfaces, this release contains some maintenance and minor changes and
fixes

- pretty printing for particles and spin/polarization https://github.com/QEDjl-project/QEDbase.jl/pull/65 https://github.com/QEDjl-project/QEDbase.jl/pull/61
- scalar broadcasting for particles, directions, spins and polarizations https://github.com/QEDjl-project/QEDbase.jl/pull/62
- spin-/polarization multiplicity convenience functions https://github.com/QEDjl-project/QEDbase.jl/pull/63
- add `is_incoming` and `is_outgoing` to the exports https://github.com/QEDjl-project/QEDbase.jl/pull/60
- add `AbstractFourMomentum` to the exports https://github.com/QEDjl-project/QEDbase.jl/pull/66
- fix of bispinor mul https://github.com/QEDjl-project/QEDbase.jl/pull/64

## Version 0.1.6

This is a maintenance release, which resolves, among others, some issues with the git history.

### Breaking changes

No breaking changes.

### New features

No new features.

### Maintenance

- Bugfix in base state https://github.com/QEDjl-project/QEDbase.jl/issues/49
- Improve parameter coverage in unit test https://github.com/QEDjl-project/QEDbase.jl/pull/50
- Bugfix in Lorentz interface https://github.com/QEDjl-project/QEDbase.jl/pull/46
- cleanup of the CI https://github.com/QEDjl-project/QEDbase.jl/pull/41 https://github.com/QEDjl-project/QEDbase.jl/pull/47

## Version 0.1.5

[diff since 0.1.4](https://github.com/QEDjl-project/QEDbase.jl/compare/0c70f66...release-0.1.5)

### Breaking changes

no breaking changes

### New features

- Move particle definitions from QEDprocesses.jl to QEDbase.jl https://github.com/QEDjl-project/QEDbase.jl/pull/25
- Base state fix https://github.com/QEDjl-project/QEDbase.jl/pull/37

### Maintenance

- CompatHelper: bump compat for DocStringExtensions to 0.9, (keep existing compat) https://github.com/QEDjl-project/QEDbase.jl/pull/40
- add CompatHelper CI Job https://github.com/QEDjl-project/QEDbase.jl/pull/35
- run unit tests for Julia 1.6 until 1.9
  https://github.com/QEDjl-project/QEDbase.jl/pull/29
- add documentation build and deploy job
  https://github.com/QEDjl-project/QEDbase.jl/pull/28
- Belated review fixes on #25
  https://github.com/QEDjl-project/QEDbase.jl/pull/34
- remove GitLab CI formatter job
  https://github.com/QEDjl-project/QEDbase.jl/pull/27
- add formatter job to GitHub Actions
  https://github.com/QEDjl-project/QEDbase.jl/pull/19
- [FIX-21] building docs locally
  https://github.com/QEDjl-project/QEDbase.jl/pull/23
- remove Mainifest.toml https://github.com/QEDjl-project/QEDbase.jl/pull/18
- make format_all.jl path independent
  https://github.com/QEDjl-project/QEDbase.jl/pull/17
- add integration tests https://github.com/QEDjl-project/QEDbase.jl/pull/2
- ci: add unit tests https://github.com/QEDjl-project/QEDbase.jl/pull/13
- Update the gitignore to fix issue #6
  https://github.com/QEDjl-project/QEDbase.jl/pull/11
