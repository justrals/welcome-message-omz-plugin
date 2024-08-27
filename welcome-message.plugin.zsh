#!/bin/bash

# Получаем ширину терминала
term_width=$(tput cols)

# Функция для центрирования текста
center_text() {
    local text="$1"
    local color="$2"
    local text_length=${#text}
    local padding=$(( (term_width - text_length) / 2 ))
    printf "%*s\e[%sm%s\e[0m\n" $padding "" "$color" "$text"
}

# Функция для вывода системной информации
print_system_info() {
    # Цвета
    os_color="34"       # Синий
    kernel_color="32"   # Зеленый
    uptime_color="33"   # Желтый
    shell_color="35"    # Магента
    resolution_color="36" # Голубой
    cpu_color="31"      # Красный

    # Получение системной информации
    os_info="OS: $(sw_vers -productName) $(sw_vers -productVersion)"
    kernel_info="Kernel: $(uname -r)"
    uptime_info="Uptime: $(uptime | awk -F'( |,|:)+' '{print $6" days, "$8" hours, "$9" mins"}')"
    shell_info="Shell: $($SHELL --version | head -n1)"
    cpu_info="CPU: $(sysctl -n machdep.cpu.brand_string)"

    # Получение и обработка разрешений
    resolutions=$(system_profiler SPDisplaysDataType | grep "Resolution:" | awk '{print $2 " x " $4}' | head -n 2)

    # Проверка, если разрешения были найдены и форматирование вывода
    if [ -n "$resolutions" ]; then
        resolution_info="Main: $(echo "$resolutions" | head -n1)"
        if [ $(echo "$resolutions" | wc -l) -eq 2 ]; then
            resolution_info="$resolution_info & Second: $(echo "$resolutions" | tail -n1)"
        fi
    else
        resolution_info="Resolution data not available."
    fi

    # Центрирование и вывод системной информации с цветом
    center_text "$os_info" "$os_color"
    center_text "$kernel_info" "$kernel_color"
    center_text "$uptime_info" "$uptime_color"
    center_text "$shell_info" "$shell_color"
    center_text "$resolution_info" "$resolution_color"
    center_text "$cpu_info" "$cpu_color"
}

# Основной текст для figlet
figlet_text="justrals"
figlet_font="larry3d"

# Создание текстового вывода с помощью figlet
figlet_output=$(figlet -f "$figlet_font" "$figlet_text" | lolcat)

# Центрирование и вывод текста figlet
echo "$figlet_output" | while IFS= read -r line; do
    center_text "$line" ""
done

# Вызов функции для вывода системной информации
print_system_info
