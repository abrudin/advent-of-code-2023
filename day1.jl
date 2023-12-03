firstDigit(x) = match(r"(\d)", x)[1]
lastDigit(x) = match(r"(\d)[^\d]*$", x)[1]
parseNum(x) = parse(Int64, firstDigit(x) * lastDigit(x))

numNames = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

replaceWords(orig) = foldl(
    (str, k) -> replace(str, k[1] => k[1] * k[2] * k[1]),
    zip(numNames, string.(collect(0:9))),
    init=orig)

open("day1.txt", "r") do f
    lines = readlines(f)

    a = sum(parseNum.(lines))
    b = sum(parseNum.(replaceWords.(lines)))
    
    println((a, b))    
    @assert a == 55538
    @assert b == 54875
end