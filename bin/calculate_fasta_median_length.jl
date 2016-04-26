#! /Applications/Julia-0.4.5.app/Contents/Resources/julia/bin/julia
# Geoffrey Hannigan
# Pat Schloss Lab
# University of Michigan

# Read in fasta file
fastain = open(ARGS[1], "r") # Read in the file

LengthArray = []

# println("Creaeting length array...")
for line in eachline(fastain)
	if !ismatch(r"^\>", line)
		newline = chomp(line)
		LineLength = length(newline)
		# println(LineLength)
		push!(LengthArray, LineLength)
	end
end

# println("Sorting array...")
SortedArray = sort(LengthArray)
# println(SortedArray)
ArrayLength = length(SortedArray)

# println("Calculating median length...")
if ArrayLength % 2 == 0
	result = SortedArray[div(ArrayLength,2)]
	println(result)
else
	one = SortedArray[div(ArrayLength,2)-1]
	two = SortedArray[div(ArrayLength,2)-1]
	result = div((one + two),2)
	println(result)
end

close(fastain)
