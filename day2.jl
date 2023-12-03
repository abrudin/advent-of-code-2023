function parseline(line)
    game = split(split(line, ": ")[2], "; ")
    to_tuple = num_color -> (num_color[2], parse(Int64, num_color[1]))
    map(round -> Dict(to_tuple.(split.(round, " "))), split.(game, ", "))
end

match_criteria(game) = all(round -> get(round, "red", 0) <= 12, game) &&
                       all(round -> get(round, "green", 0) <= 13, game) &&
                       all(round -> get(round, "blue", 0) <= 14, game)

power(game) = maximum(round -> get(round, "red", 0), game) *
              maximum(round -> get(round, "green", 0), game) *
              maximum(round -> get(round, "blue", 0), game)

open("day2.txt", "r") do f
    lines = readlines(f)
    a = sum(map(x -> x[2], Iterators.filter(x -> match_criteria(x[1]), zip(parseline.(lines), 1:length(lines)))))
    b = sum(power.(parseline.(lines)))
    
    println((a, b))
    @assert a == 2685
    @assert b == 83707
end