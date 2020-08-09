include("Q_helper_fxns.jl")

"""
    function Q_in(A, community_list, host, k, avg_edge_val)
Returns the change in modularity from taking isolated node `k` and placing it in
community `host`

# Arguments
-   `A::Array{Float64,2}`: A two-dimensional array where A[i,j] is the edge weight
    between nodes 'i' and 'j'

-   `community_list::Array{Int64,1}`: a list of community assignments where A[i]
    is the community to which node i belongs

-   `host::Int64`: community to which 'k' is being joined

-   `k::Int64`: index of the the isolated node being merged with community 'host'

-   `avg_edge_val::Float64`: is the average edge value in the network being
    represented by 'A'
"""
function Q_in(host, k, community_list,A, avg_edge_val)
    Ã           = A[:,:]
    N           = size(Ã)[1]
    host_val    = 0 # total edge value in the host community
    host_ev     = 0 # expected value of the host community
    host_deg    = 0 # total edges incident to nodes in community 'host'
    host_k_share= 0 # the edges shared by k and host
    host_k_ev   = 0 # expected value of host community if it included k
    host_k_deg  = 0 #s same as host_deg asuumin 'k' was part of the community
    k_deg       = degreeof(Ã[k,:]) #degree of node k
    k_ev        = 0 # expected value of k (doubled becauses all edges counted 2x)
    k_val_in    = 0 # total value of edges ∈ host ∩ k

    for i = 1:N
        #=----------
        checks if i is in community. If so it updates the community degree
        count, fixes i, and checks j for two conditions
        ----------=#
        if community_list[i] == host
            host_deg = host_deg + degreeof(Ã[i,:])
            #=----------
            If j is also in host community we have found a community edge.
            If j is = k then we found an edge between the host and vertex k
            ----------=#
            for j=1:N
                if community_list[j] == host
                    host_val = host_val + Ã[i,j]
                elseif  j == k && Ã[i,j] != 0
                    k_val_in = k_val_in + Ã[i,j]
                    host_k_share = host_k_share + 1
                end
            end
            #=----------
            Ensures we don't double count edges
            ----------=#
            Ã[:,i] = zeros(N,1)
        end
    end

    host_k_val = host_val + k_val_in
    host_k_deg = host_deg + k_deg - host_k_share
    host_ev = (avg_edge_val * host_deg)
    host_k_ev = (avg_edge_val * host_k_deg)

    k_val = A[k,k]
    k_ev = avg_edge_val*k_deg

    host_k_val
    host_k_ev
    host_val
    host_ev
    k_val
    k_ev

    Qin = (host_k_val - host_k_ev) - (host_val - host_ev + k_val - k_ev)
end
