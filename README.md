Coremark EEMBC Litex Wrapper
============================

This repository provides the utility files to port [CoreMark EEMBC](https://www.eembc.org/coremark/) to Litex.

### Requirements

  - Litex

### Setup

  - `git submodule update --init --recursive`
  - integrate into target file

```
    os.environ["COREMARK_MEM"] = "main_ram"
    src_dir = os.path.abspath("path/to/litex-coremark/litex_coremark")
    builder.add_software_package("coremark", src_dir)
```

  - Alternately set COREMARK_MEM to one of the other supported memory locations:
    see `litex-coremark/litex_coremark/litex/linker_{mem}.ld`