# Shortcut style to use at the prompt. 'vi' or 'emacs'.
c.TerminalInteractiveShell.editing_mode = "vi"
c.TerminalInteractiveShell.prompt_includes_vi_mode = False
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False

from IPython.core.ultratb import VerboseTB
VerboseTB._tb_highlight = "bg:ansiyellow ansiblack"
