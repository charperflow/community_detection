using CSV
using DataFrames
using Plots, Colors

pd = DataFrame()
gd = DataFrame()

pd = CSV.File("particle_data.csv") |> DataFrame!
gd = CSV.File("community_data.csv") |> DataFrame!

N = size(pd.X)[1]
M = size(gd.Community)[1]

C(g::ColorGradient) = RGB[g[z] for z = LinRange(0,1,101)]
g = :inferno
myGrad = (cgrad(g,) |> C)

function norm_particle_force!(x)
    M = size(x)[1]
    max = maximum(x)
    for i = 1:M
        x[i] = x[i]/max
    end
end


part_f = Array{Float64}(undef,N)
part_f[:] = pd.ContactF
norm_particle_force!(part_f)

c_index = Integer.(round.((100*part_f),RoundNearest)) #contact forces

plt_p = plot(
    1,
    xlim = (0,0.15),
    ylim = (0,0.15),
    title = "contact_forces",
    marker = 2,
    legend = false
)

cords=zeros(N,2)
for i = 1:N
    cords[i,1] = pd[i,1]
    cords[i,2] = pd[i,2]
end


plt_p = scatter!(pd[:,1], pd[:,2],
        m = myGrad,  # colors are defined by a gradient
        zcolor = c_index,
        markersize = 6,
        aspect_ratio=:equal
       )
