# Contributing to Good Morning Terminal

Thank you for your interest in contributing! Here's how you can help.

## Adding a Language

The easiest way to contribute is by adding a new language translation.

1. Copy the English language pack:
   ```bash
   cp lang/en.sh lang/your_lang_code.sh
   ```
2. Translate all `L_` variables in the new file
3. Keep command names (`gm add`, `gm go`, etc.) in English — these are not translated
4. Test with `GMT_LANG="your_lang_code" GMT_DIR="$(pwd)" bash -c 'source gmt.sh'`
5. Submit a PR

## Creating a Module

Modules live in `modules/` and follow a simple convention:

```bash
#!/usr/bin/env bash
# mymodule.sh — Description

_gmt_mymodule_render() {
  section_header "icon" "$L_MY_TITLE"
  # your rendering logic
}
```

Then add corresponding `L_` strings to all language packs.

## Development Setup

```bash
git clone https://github.com/user/gmt.git ~/gmt-dev
cd ~/gmt-dev
GMT_DIR="$(pwd)" bash -c 'source gmt.sh'
```

## Guidelines

- **Performance**: Keep startup under 300ms. Avoid subshells where bash builtins work
- **Compatibility**: Must work on bash 3.2+ (macOS default) and zsh 5.0+
- **Cross-platform**: Test on both macOS and Linux if possible
- **i18n**: All user-facing strings use `L_` variables. No hardcoded strings
- **No dependencies**: Pure shell. `curl` is the only optional external tool (for weather)

## Reporting Bugs

Please include:
- OS and version (`uname -a`)
- Shell and version (`$SHELL --version`)
- GMT version (`gm version`)
- Steps to reproduce
