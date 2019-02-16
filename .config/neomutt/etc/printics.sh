#!/bin/bash

khal printics --format "
+----------------+
| Calendar Event |
+----------------+
Event........{repeat-symbol}{title}
Location.....{location}
Start........{start-date-long} {start-time-full}
End..........{end-date-long} {end-time-full}
Status.......{status}
Description:
{description}
" ${1} | awk '{if (NR>2) print}'
