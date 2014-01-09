#!/usr/bin/env tclsh

set var(user) $env(USER)
set var(path) $env(PWD)
set var(home) $env(HOME)

# * Check if we're somewhere in /home
# Comment this out if you login as root
if {![string match -nocase "/home*" $var(path)] && ![string match -nocase "/usr/home*" $var(path)] } {
    return 0
}

# * Calculate last login
set lastlog [exec -- lastlog -u $var(user)]
set ll(1)  [lindex $lastlog 7]
set ll(2)  [lindex $lastlog 8]
set ll(3)  [lindex $lastlog 9]
set ll(4)  [lindex $lastlog 10]
set ll(5)  [lindex $lastlog 6]

# * Calculate current system uptime
set uptime    [exec -- /usr/bin/cut -d. -f1 /proc/uptime]
set up(days)  [expr {$uptime/60/60/24}]
set up(hours) [expr {$uptime/60/60%24}]
set up(mins)  [expr {$uptime/60%60}]
set up(secs)  [expr {$uptime%60}]

# * Calculate usage of home directory
set usage [lindex [exec -- /usr/bin/du -ms $var(home)] 0]

# * Calculate SSH logins:
set logins     [exec -- w -s]
set log(c)  [lindex $logins 5]

# * Calculate processes
set psu [lindex [exec -- ps U $var(user) h | wc -l] 0]
set psa [lindex [exec -- ps -A h | wc -l] 0]

# * Calculate current system load
set loadavg     [exec -- /bin/cat /proc/loadavg]
set sysload(1)  [lindex $loadavg 0]
set sysload(5)  [lindex $loadavg 1]
set sysload(15) [lindex $loadavg 2]

# * Calculate Memory
set memory  [exec -- free -m]
set mem(t)  [lindex $memory 7]
set mem(u)  [lindex $memory 8]
set mem(f)  [lindex $memory 9]
set mem(c)  [lindex $memory 16]
set mem(s)  [lindex $memory 19]

# * Get enabled sites
set sites [glob -nocomplain -types l -path /etc/apache2/sites-enabled/ *]

# * Fortune
set fortune [split [exec /usr/games/fortune -a] "\n"]

# * ascii head
# Make your text here: http://patorjk.com/software/taag/#p=display&f=Doom&t=
set head {
ASCII_ART
}

# * Print results
puts "\033\[01;31m$head\033\[0m"
puts "  Last Login....: $ll(1) $ll(2) $ll(3) $ll(4) from $ll(5)"
puts "  Uptime........: $up(days)days $up(hours)hours $up(mins)minutes $up(secs)seconds"
puts "  Load..........: $sysload(1) (1minute) $sysload(5) (5minutes) $sysload(15) (15minutes)"
puts "  Memory MB.....: $mem(t)  Used: $mem(u)  Free: $mem(f)  Free Cached: $mem(c)  Swap In Use: $mem(s)"
puts "  Disk Usage....: You're using ${usage}MB in $var(home)"
puts "  SSH Logins....: There are currently $log(c) users logged in."
puts "  Processes.....: You're running ${psu} which makes a total of ${psa} running"
puts "\n"
puts "  \033\[02;37mSITES ENABLED\033\[0m"
puts "\n"
foreach site $sites {
    puts "  [file tail $site]"
}
puts "\n  \033\[02;37mWISDOM\033\[0m"
puts "\n"
foreach line $fortune {
    puts "  $line"
}
puts "\n"

