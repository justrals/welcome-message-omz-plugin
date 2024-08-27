#!/bin/bash

# Getting terminal width
term_width=$(tput cols)

# Text centering function
center_text() {
    local text="$1"
    local padding=$(( (term_width - ${#text}) / 2 ))
    printf "%*s%s\n" $padding "" "$text"
}

# Function to get OS type
get_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macOS"
            ;;
        Linux)
            echo "Linux"
            ;;
        MINGW*|MSYS*|MYSYS*)
            echo "Windows"
            ;;
        *)
            echo "Unknown"
            ;;
    esac
}

# Function to display system information
get_system_info() {
    os_type=$(get_os)

    case "$os_type" in
        "macOS")
            os_info="OS: $(sw_vers -productName) $(sw_vers -productVersion)"
            kernel_info="Kernel: $(uname -r)"
            uptime_info="Uptime: $(uptime -p | sed 's/^up //')"
            shell_info="Shell: $($SHELL --version | head -n1)"
            cpu_info="CPU: $(sysctl -n machdep.cpu.brand_string)"
            resolutions=$(system_profiler SPDisplaysDataType | grep "Resolution:" | awk '{print $2 " x " $4}' | head -n 2)
            ;;
        "Linux")
            os_info="OS: $(lsb_release -d | awk -F'\t' '{print $2}')"
            kernel_info="Kernel: $(uname -r)"
            uptime_info="Uptime: $(uptime -p | sed 's/^up //')"
            shell_info="Shell: $($SHELL --version | head -n1)"
            cpu_info="CPU: $(lscpu | grep 'Model name' | awk -F': ' '{print $2}' | xargs)"
            resolutions=$(xrandr | grep ' connected' | awk '{print $3}' | sed 's/[^x]*//;s/+.*//;s/,/ & /' | head -n 2)
            ;;
        "Windows")
            os_info="OS: $(cmd.exe /c ver | head -n1)"
            kernel_info="Kernel: $(uname -r)"
            uptime_info="Uptime: $(uptime -p | sed 's/^up //')"
            shell_info="Shell: $($SHELL --version | head -n1)"
            cpu_info="CPU: $(wmic cpu get Caption | tail -n +2)"
            resolutions="Resolution information not available."
            ;;
        *)
            os_info="OS: Unknown"
            kernel_info="Kernel: Unknown"
            uptime_info="Uptime: Unknown"
            shell_info="Shell: Unknown"
            cpu_info="CPU: Unknown"
            resolutions="Resolution information not available."
            ;;
    esac

    # Format resolution info
    if [ -n "$resolutions" ]; then
        if [ $(echo "$resolutions" | wc -l) -eq 1 ]; then
            resolution_info="Resolution: $(echo "$resolutions" | head -n1)"
        elif [ $(echo "$resolutions" | wc -l) -eq 2 ]; then
            resolution_info="Main: $(echo "$resolutions" | head -n1) & Second: $(echo "$resolutions" | tail -n1)"
        else
            resolution_info="Resolution data not available."
        fi
    else
        resolution_info="Resolution data not available."
    fi

    # Combine all info into a single string
    all_info="$(center_text "$os_info")
$(center_text "$kernel_info")
$(center_text "$uptime_info")
$(center_text "$shell_info")
$(center_text "$resolution_info")
$(center_text "$cpu_info")"
    echo "$all_info"
}

# Main text for figlet
figlet_text="justrals"
figlet_font="larry3d"

# Creating text output using figlet
figlet_output=$(figlet -f "$figlet_font" "$figlet_text")

# Split figlet output into lines and center each line
centered_figlet_output=$(echo "$figlet_output" | awk -v term_width=$term_width '{printf "%*s\n", (term_width+length($0))/2, $0}')

# Combine figlet output and system info into one string
combined_output="$centered_figlet_output

$(get_system_info)"

# Display the combined output with a single gradient
echo "$combined_output" | lolcat
