struct Part
    row::Int64
    col::Int64
    num::String
end

struct Point
    row::Int64
    col::Int64
    char::Char
    Point((row, col, char)) = new(row, col, char)
end

struct Parts
    partial::Bool
    parts
end

flatten(x) = reduce(vcat, x)
mapper(fn) = x -> map(fn, x)
get_partnumber(part) = parse(Int64, part.num)

function build_parts((; partial, parts), (; row, col, char))
    replace_last(elem) = vcat(collect(Iterators.take(parts, length(parts) - 1)), elem)
    append_partnumber(part, char) = Part(part.row, part.col, part.num * char)
    append_to_last_part() = Parts(true, replace_last(append_partnumber(last(parts), char)))
    append_as_new_part() = Parts(true, vcat(parts, Part(row, col, string(char))))
    if (isdigit(char))
        if (partial)
            append_to_last_part()
        else
            append_as_new_part()
        end
    else
        Parts(false, parts)
    end
end

get_parts(points) = foldl(build_parts, points, init=Parts(false, [])).parts

neighbor_coords((; row, col, num), dims) =
    flatten([(r, c) for r = max(row - 1, 1):min(row + 1, dims[1]), c = max(col - 1, 1):min(col + length(num), dims[2])])

neighbor_coords(row, col, dims) = neighbor_coords(Part(row, col, " "), dims)

function has_symbol_adjacent(part, arr, dims)
    is_symbol((r, c)) = !isdigit(arr[r][c].char) && arr[r][c].char != '.'
    any(is_symbol, neighbor_coords(part, dims))
end

part_number_coords((; row, col, num)) = [(row, c) for c = col:col+length(num)-1]

part_near_gear((row, col), dims) = part ->
    !isempty(findall(in(neighbor_coords(row, col, dims)), part_number_coords(part)))

open("day3.txt", "r") do f
    lines = readlines(f)
    dims = (length(lines), length(lines[1]))
    chars_with_coords = map(((row, line),) -> map(((col, char),) -> Point((row, col, char)), zip(1:length(line), line)), zip(1:length(lines), lines))

    potential_parts = flatten(get_parts.(chars_with_coords))
    real_parts = filter(part -> has_symbol_adjacent(part, chars_with_coords, dims), potential_parts)
    a = sum(get_partnumber.(real_parts))

    potential_gears = map(p -> (p.row, p.col), filter(c -> c.char == '*', flatten(chars_with_coords)))
    real_gears = filter(x -> length(x) == 2, map(gear -> filter(part_near_gear(gear, dims), potential_parts), potential_gears))
    gear_ratios = map(prod ∘ mapper(get_partnumber), real_gears)
    b = sum(gear_ratios)

    println((a, b))
    @assert a == 544433
    @assert b == 76314915
end