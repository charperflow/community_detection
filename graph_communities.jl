using CSV
using DataFrames
using Plots, Colors


pd = DataFrame()
gd = DataFrame()

pd = CSV.File("particle_data.csv") |> DataFrame!
gd = CSV.File("community_data.csv") |> DataFrame!

N = size(pd.X)[1]
M = size(gd.Community)[1]

function find_coords(c,pd)
    N = size(pd[:,1])[1]
    x = Float64[]
    y = Float64[]
    for i = 1:N
        if pd[i,3] == c
            push!(x,pd[i,1])
            push!(y,pd[i,2])
        end
    end
    return x, y
end

#=----------
generates a value normalised to some maximum
----------=#

value_per_edge = gd.Value./gd.Size
function norm_value_max!(cv)
    M = size(cv)[1]
    max = maximum(cv)
    #max = 1.07189
    for i = 1:M
        cv[i] = cv[i]/max
    end
end


#=----------
Here we're normalising by normal forces
----------=#

norm_values = copy(value_per_edge)
norm_value_max!(norm_values)

community_stdv = Array{Float64}(undef,M)
community_stdv[:] = gd.Stdv
norm_value_max!(community_stdv)


#=----------
set whether or not you want the heat map to show contact forces (the first line)
ofr variance
----------=#

c_index = Integer.(round.((100*norm_values),RoundNearest)) #contact forces
#c_index = Integer.(round.((100*community_stdv),RoundNearest)) #variance
#c_index = Integer.(round.((100*community_stdv/3.211),RoundNearest)) #variance



plt_c = scatter(
    1,
    xlim = (0,0.15),
    ylim = (0,0.15),
    title = "contact forces within communities",
    marker = 2,
    legend = false,
    aspect_ratio=:equal
)




C(g::ColorGradient) = RGB[g[z] for z = LinRange(0,1,101)]
g = :inferno
myGrad = (cgrad(g,) |> C)


#=
clibrary(:misc)
g = :rainbow
commGrad = (cgrad(g)|>C)
=#
community_colors = distinguishable_colors(M)


for i = 1:M
    X,Y = find_coords(i,pd)
    fill = myGrad[c_index[i]+1]
    #fill = community_colors[i]
    outline = rand(Float64,3)

    plt_c = scatter!(X,Y, colobar = myGrad; markercolor= fill, markerstrokecolor = :black, markersize = 6)

    #plt_c = scatter!(X,Y; markercolor= fill, markerstrokecolor =:black, markersize = 8)
end




#=
fig = figure()
title("community size ≥ 2")
D = findall(x->x>2,gd.Size)
M = size(D)[1]
for i = 1:M
    X,Y = find_coords(D[i],pd)
    color = rand(Float64,3)
    R = scatter(X,Y,c = color, s=40)
end
=#
