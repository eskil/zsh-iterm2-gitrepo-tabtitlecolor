# Function to compute a consistent color for the current Git repository
zsh_iterm2_gitrepo_tabtitle_git_repo_color() {
    # Get the current Git repository name
    local repo_name
    if repo_name=$(git rev-parse --show-toplevel 2>/dev/null); then
	# Use the directory name of the repo as the identifier      
	repo_name=$(basename "$repo_name")
    else
	echo "LightGray #D3D3D3"
	return 1
    fi
    
    # Associative array of color names and hex values
    typeset -A colors
    colors=(
	"Black"         "#000000"
	"White"         "#FFFFFF"
	"Red"           "#FF0000"
	"LightRed"      "#FF6666"
	"DarkRed"       "#8B0000"
	"Green"         "#00FF00"
	"LightGreen"    "#90EE90"
	"DarkGreen"     "#006400"
	"Blue"          "#0000FF"
	"LightBlue"     "#ADD8E6"
	"DarkBlue"      "#00008B"
	"Yellow"        "#FFFF00"
	"LightYellow"   "#FFFFE0"
	    "DarkYellow"    "#FFD700"
	"Cyan"          "#00FFFF"
	"LightCyan"     "#E0FFFF"
	"DarkCyan"      "#008B8B"
	"Magenta"       "#FF00FF"
	"LightMagenta"  "#FF77FF"
	"DarkMagenta"   "#8B008B"
	"Gray"          "#808080"
	"DarkGray"      "#A9A9A9"
	"LightGray"     "#D3D3D3"
	"Orange"        "#FFA500"
	"LightOrange"   "#FFDAB9"
	"Pink"          "#FFC0CB"
	"HotPink"       "#FF69B4"
	"LightPink"     "#FFB6C1"
	"Purple"        "#800080"
	"DarkPurple"    "#4B0082"
	"Lavender"      "#E6E6FA"
	"Brown"         "#A52A2A"
	"DarkBrown"     "#8B4513"
	"Gold"          "#FFD700"
	"Silver"        "#C0C0C0"
	"Teal"          "#008080"
	"DarkTeal"      "#20B2AA"
	"Navy"          "#000080"
	"Lime"          "#00FF00"
	"Olive"         "#808000"
	"Beige"         "#F5F5DC"
	"Coral"         "#FF7F50"
	"Crimson"       "#DC143C"
	"Indigo"        "#4B0082"
	"Ivory"         "#FFFFF0"
	"Khaki"         "#F0E68C"
	"Mint"          "#98FF98"
	"Peach"         "#FFDAB9"
	"Plum"          "#DDA0DD"
	"Salmon"        "#FA8072"
	"Tan"           "#D2B48C"
	"Turquoise"     "#40E0D0"
	"Violet"        "#EE82EE"
    )
    
    # Get an array of color names
    local color_names=(${(k)colors})
    
    # Compute a hash of the repository name
    local hash=$(printf '%s' "$repo_name" | md5sum | awk '{print $1}')
    local hash_num=$((0x${hash:0:8})) # Use the first 8 hex digits as a number

    # Map the hash to a color name index
    local index=$((hash_num % ${#color_names[@]}))
    
    # Output the color name and hex value
    local color_name="${color_names[$index]}"
    echo "$color_name ${colors[$color_name]}"
}

# Function to set iTerm2 tab color and name based on the current Git repository
zsh_iterm2_gitrepo_tabtitle_set_iterm2_tab_color() {
  # Get the current Git repository name (e.g., "my-repo")
  local repo_name=$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null)
  
  if [[ $? -ne 0 ]]; then
    # Not in a Git repository, reset the tab color
    echo -e "\033]6;1;bg;*;default\a"
    return 0
  fi

  # Extract the repository name from the path
  repo_name=$(basename "$repo_name")

  # Uppercase the repo name
  local upper_repo_name="${repo_name:u}"

  # Extract the hex color from the output of `git_repo_color` function
  local repo_color=$(zsh_iterm2_gitrepo_tabtitle_git_repo_color)
  local hex_color="${repo_color##* }" # Get the last part after the space (#RRGGBB)

  # Validate the hex color format
  if [[ "$hex_color" != \#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9]) ]]; then
    echo "Invalid color format: $hex_color"
    echo "repo_color: $repo_color"
    echo "repo_name: $repo_name"
    return 1
  fi

  # Convert #RRGGBB to R, G, and B components using ${...:offset:length} slicing
  local r=$((16#${hex_color:1:2})) # Red component
  local g=$((16#${hex_color:3:2})) # Green component
  local b=$((16#${hex_color:5:2})) # Blue component

  # Set the tab color and tab name in iTerm2
  echo -ne "\033]6;1;bg;red;brightness;$r\a"
  echo -ne "\033]6;1;bg;green;brightness;$g\a"
  echo -ne "\033]6;1;bg;blue;brightness;$b\a"
  echo -ne "\033]1;${upper_repo_name}\a"  # Set the tab name to the uppercased repo name
}

# Hook to set the tab color on directory change
# precmd() {
#     set_iterm2_tab_color
# }

autoload -U add-zsh-hook

add-zsh-hook chpwd zsh_iterm2_gitrepo_tabtitle_set_iterm2_tab_color

# Set the initial background.
zsh_iterm2_gitrepo_tabtitle_set_iterm2_tab_color
