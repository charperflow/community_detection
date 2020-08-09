include("Q_in.jl")
include("Q_out.jl")
"""
    function max_Q!(community_list, A, avg_edge_val)

Permutes the provided `community_list` until no further permutations can increase
the modularity of `A`
"""
function max_Q!(community_list, A, avg_edge_val)

    N = size(community_list)[1]
    updates = Array{Tuple{Int64,Float64}}(undef,N,1)

    #=----------
    First we calculate the change in modularity by isolating element i from its
    community
    ----------=#
    for i = 1:N
        host_rm = community_list[i]
        Qout = Q_out(host_rm,i,community_list, A, avg_edge_val)

        max_q = (host_rm,0.0) #sets default change to current community with ΔQ = 0

        #=----------
        Now we calculate the modularity gained from placing node i into each of
        its neighbooring communities
        ----------=#
        for j = 1:N
            if A[i,j] != 0
                host_in = community_list[j]
                Qin = Q_in(host_in,i,community_list,A,avg_edge_val)
                if (Qin + Qout) > max_q[2]
                    max_q = (j,(Qin-Qout))
                end
            end
        end
        updates[i] = max_q
        #=----------
        This is where the community of node i is updated to its current largest
        reassignment
        ----------=#
        community_list[i] = community_list[max_q[1]]
    end
end
