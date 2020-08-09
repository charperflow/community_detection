include("Q_helper_fxns.jl")
include("sherlock.jl")
using .G
using DataFrames
using CSV
using TickTock


A = copy(G.nn_forces)
stdv_A = total_stdv(A)
old_A = copy(G.nn_forces)
@show total_value(A)
γ = 1
N = size(A)[1]
avg_edge_val = avg_edge(A,γ)
tick()
A_collapsed, final_assignment = sherlock(A,avg_edge_val)
@show total_value(A_collapsed)

while  A_collapsed !=  A
    global A, A_collapsed,final_assignment, avg_edge_val
    A = copy(A_collapsed)
    avg_edge_val = avg_edge(A,γ)

    A_collapsed, community_list = sherlock(A,avg_edge_val)

    @show total_value(A_collapsed)
    M = size(community_list)[1]
    for i = 1:M
        for j = 1:N
            if final_assignment[j] == i
                final_assignment[j] = community_list[i]
            end
        end
    end
end

tock()
list_of_communities     = community_labels(final_assignment)
size_of_communities     = community_sizes(final_assignment)
value_of_communities    = community_value(A_collapsed)
stdv_of_communities     = comm_stdv(final_assignment,old_A)
particle_F              = particle_forces(old_A)

@show stdv_A


pd = DataFrame()
pd.X = G.x_pos
pd.Y = G.y_pos
pd.Community = final_assignment
pd.ContactF = particle_F

gd = DataFrame()
gd.Community = list_of_communities
gd.Size = size_of_communities
gd.Value = value_of_communities
gd.Stdv = stdv_of_communities

CSV.write("particle_data.csv",pd)
CSV.write("community_data.csv",gd)












#=

Interesting way to calculate list of communities which is different
from the helper function I built


K = size(A_collapsed)[1]
list_of_communities = Array{Int64}(undef,K)
size_of_communities = zeros(K)
max = 0
count_c = 0

for i = 1:N
    global max, count_c
    if final_assignment[i] > max
        count_c = count_c + 1
        list_of_communities[count_c] = final_assignment[i]
        max = final_assignment[i]
    end
    k = final_assignment[i]
    size_of_communities[k] = size_of_communities[k]+1
end
=#
