What is it for?
Adobe used to use differently colored icons for their apps, but circa 2020, not anymore. This script allows to re-write the app shortcuts in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ (aka start menu) with custom icons (included). You can use your own icons of course.
I've only included the icons for apps I use myself, but you can modify the script and add icons. There are comments inside the script for clarity.

Activate:
- put the scripts and .ico files anywhere
- inside the script, the "links" variable lists all the apps to replace shortcuts for
- run "apply" script as administrator to apply icons
- don't delete/move .ico files, obviously, or the shortcuts will not show them anymore

Deactivate:
- run "restore_orig" script as administrator