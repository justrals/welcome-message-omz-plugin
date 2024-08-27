#!/bin/bash

# Getting terminal width
term_width=$(tput cols)

# Text centering function
center_text() {
    local text="$1"
    local color="$2"
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))
    printf "%*s\e[%sm%s\e[0m\n" $padding "" "$color" "$text"
}

# Function to display system information
print_system_info() {
    # Colors
    os_color="34"
    kernel_color="32"
    uptime_color="33"
    shell_color="35"
    resolution_color="36"
    cpu_color="31"      

    # Getting system information
    os_info="OS: $(sw_vers -productName) $(sw_vers -productVersion)"
    kernel_info="Kernel: $(uname -r)"
    uptime_info="Uptime: $(uptime | awk -F'( |,|:)+' '{print $6" days, "$8" hours, "$9" mins"}')"
    shell_info="Shell: $($SHELL --version | head -n1)"
    cpu_info="CPU: $(sysctl -n machdep.cpu.brand_string)"

    # Getting and processing resolutions
    resolutions=$(system_profiler SPDisplaysDataType | grep "Resolution:" | awk '{print $2 " x " $4}' | head -n 2)

    # Checking if resolutions were found and formatting output
    if [ -n "$resolutions" ]; then
        resolution_info="Main: $(echo "$resolutions" | head -n1)"
        if [ $(echo "$resolutions" | wc -l) -eq 2 ]; then
            resolution_info="$resolution_info & Second: $(echo "$resolutions" | tail -n1)"
        fi
    else
        resolution_info="Resolution data not available."
    fi

    # Centering and displaying system information with color
    center_text "$os_info" "$os_color"
    center_text "$kernel_info" "$kernel_color"
    center_text "$uptime_info" "$uptime_color"
    center_text "$shell_info" "$shell_color"
    center_text "$resolution_info" "$resolution_color"
    center_text "$cpu_info" "$cpu_color"
}

# Main text for figlet
figlet_text="justrals"
figlet_font="larry3d"

# Creating text output using figlet
figlet_output=$(figlet -f "$figlet_font" "$figlet_text" | lolcat)

# Centering and displaying figlet text
echo "$figlet_output" | while IFS= read -r line; do
    center_text "$line" ""
done

# Function call for system info display
print_system_info
