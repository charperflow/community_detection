include("maximize_Q.jl")

"""
    function sherlock (A)
Sherlock takes a weighted adjacency matrix `A` and attempts to maximize
modularity by partitioning the nodes into different communities. By treating
each community as a singular node, a collapsed version of adacency matrix `A`
is returned as `collapsed network`.

`collapsed_network[i,i]` reresents the total edge value of community i, and
`collapsed_network[i,j]` reresents the total edge value between communities i
and j.

# Examples
```julia-repl
julia> A #A is a caveman graph with 25 nodes
25×25 Array{Float64,2}:

julia> sherlock(A) # noticed its condensed to the 5 communitites found
5×5 Array{Float64,2}:
 9.0  1.0  0.0  0.0  1.0
 1.0  9.0  1.0  0.0  0.0
 0.0  1.0  9.0  1.0  0.0
 0.0  0.0  1.0  9.0  1.0
 1.0  0.0  0.0  1.0  9.0
```

"""
function sherlock(A,avg_edge_val)

    #=----------
    N: the number of nodes

    community_list: keeps track of which node is in which community. Each node
                    starts off in its own community
    ----------=#
    N = size(A)[1]
    @show avg_edge_val
    community_list = [i for i ∈ 1:N]
    community_list_old = Array{Int64}(undef,N)
    count = 0

    #=----------
    max_Q!() assigns the nodes to communities in an attempt to maximize modularity.
    It sweeps through all of the nodes, N, until no more reassignments increase
    modularity
    ----------=#
    while (community_list_old[:] != community_list[:] && count < 1000)
        community_list_old[:] = community_list
        max_Q!(community_list, A, avg_edge_val)
        count = count + 1
        community_list
    end
    #=----------
    Relabels the communities as illustrated in the example below:

    community_list = [2, 2, 2, 2, 2, 8, 8, 8, 8, 8, 13, 13, 13, 13, 13, 18, 18,
     18, 18, 18, 23, 23, 23, 23, 23]
    community_list = [1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4,
    4, 5, 5, 5, 5, 5]
    ----------=#
    relabel!(community_list)

    #=----------
    This is where we construct the collapsed matrix. Edges_out generates the
    new edges. Edges_in generates the diagonal values
    ----------=#
    edges_out = edges_between(community_list,A)
    edges_in = edges_within(community_list,A)

    #=----------
    IMPORTANT: only turn on community variance when you need it, it is very slow
    remember to toggle return statement
    ----------=#
    #community_variance = comm_var(community_list,A)

    collapsed_network = edges_out + edges_in


    return collapsed_network, community_list

end
