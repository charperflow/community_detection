using CSV, DataFrames, Plots, Colors, StatsBase, Distributions


st = DataFrame()

st = CSV.File("STATIC.csv"; header = false) |> DataFrame!
N = size(st.Column10)[1]

contact_forces = Float64[]

for i = 1:N
    row     = st.Column8[i]
    column  = st.Column9[i]
    if row ≤ 717 && column ≤ 717
        magnitude    = sqrt(st.Column10[i]^2+st.Column11[i]^2)
        push!(contact_forces, magnitude)
    end
end

n_contact_forces = similar(contact_forces)
avg_contact_force = mean(contact_forces)
N = length(contact_forces)

for i = 1:N
    n_contact_forces[i] = contact_forces[i]/avg_contact_force
end

h = fit(Histogram, n_contact_forces,nbins = 100)
M= size(h.weights)[1]

bins = [0.1*i for i ∈ 1:M]
w = h.weights
total = sum(w)
w_prob = w./total

plt = plot(
    bins,
    w_prob,
    xaxis= "normalized contact force",
    yaxis = "probability",
    label = "~pdf"
    )


test = fit_mle(Exponential,bins,w_prob)

#=
x   = [.001*i for i ∈ 1:6000 ]
exact = similar(x)
for i = 1:length(x)
    exact[i] = 1.05exp(-1.05*x[i])
end
plot!(x,exact)
=#
