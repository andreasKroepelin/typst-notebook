function note
    if set -q argv[1]
        set -f title $argv[1]
    else
        set -f title (date "+%Y-%b-%d" | string lower)
    end

    set -f filename (echo $title | string lower | string replace " " "-")

    echo -e "\n#include \"$filename.typ\"" >> notebook.typ
    echo "= $title" > "$filename.typ"
end
