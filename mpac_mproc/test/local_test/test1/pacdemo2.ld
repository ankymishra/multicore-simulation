/* Default linker script, for normal executables */
OUTPUT_FORMAT("elf32-pacdsp", "",
	      "")
OUTPUT_ARCH(pacdsp)
ENTRY(__crt0_start__)
SEARCH_DIR("/home/pac/work/pacdsp/code/../install/linux/pacdsp-elf/lib");
MEMORY
{
  ram : ORIGIN = 0x30100000, LENGTH = 128M
}
SECTIONS
{
  . = 0x00100000;
  .text :
  {
    CREATE_OBJECT_SYMBOLS
    *(.text)
    etext = ALIGN(1);
  } > ram
  . = ALIGN(1);
  .data :
  {
    . = 4; /* Preserve space for NULL. */
    *(.data)
    CONSTRUCTORS
    edata  =  .;
    *(.sdata)
    *(.rodata)
    *(.bss)
    *(.sbss)
    *(COMMON)
    *(.tdata)
    . = ALIGN(4);
    end = .;
/*  _stack = . + 1M; */
  } > ram
  _stack = . + 4k;

  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
}
