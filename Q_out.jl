include("Q_helper_fxns.jl")

"""
    function Q_out(A, community_list, host, k, avg_edge_val)
Returns the change in modularity caused by isolatinf node `k` from community
`host`.

# Arguments
-   `A::Array{Float64,2}`: A two-dimensional array where A[i,j] is the edge weight
    between nodes 'i' and 'j'

-   `community_list::Array{Int64,1}`: a list of community assignments where A[i]
    is the community to which node i belongs

-   `host::Int64`: community from which 'k' is being removed

-   `k::Int64`: index of the the isolated node being removed from 'host'

-   `avg_edge_val::Float64`: is the average edge value in the network being
    represented by 'A'

"""
function Q_out(host, k, community_list, A, avg_edge_val)
    Ã           = copy(A)
    N           = size(Ã)[1]
    host_val    = 0 # total edge value in the host community after removing k
    host_ev     = 0 # expected value of the host community after removing k
    host_deg    = 0 # total edges incident to nodes in 'host' excluding node k
    host_k_share= 0 # the edges shared by k and host
    host_k_ev   = 0 # expected value of host community when it included k
    host_k_deg  = 0 # total edges incident to nodes in 'host' including k
    host_k_val  = 0 #total value of host including k
    k_deg       = degreeof(Ã[k,:])
    k_ev        = 0 # expected value of k
    k_cont      = 0 # contribution k makes to 'hosts' total value



    for i = 1:N
        #=----------
        checks if i is in community. If so it updates the host community degree
        count, and adds (if any) the value between this node and k to k_cont
        ----------=#
        if community_list[i] == host
            host_k_deg = host_k_deg + degreeof(Ã[i,:])
            k_cont = k_cont + Ã[k,i]
            #=----------
            If j is also in the community we have found a shared edge, so
            this updates the total host value
            ----------=#
            for j = 1:N
                if community_list[j] == host
                    host_k_val = host_k_val + Ã[i,j]
                    if j == k && A[i,j] != 0
                        #=----------
                        Takes special not of edges shared with k AND the host,
                        so we can subtract these out when we remove k
                        ----------=#
                        host_k_share = host_k_share + 1
                    end
                end
            end
            #=----------
            This ensures no doublecounting of edges
            ----------=#
            Ã[:,i] = zeros(N)
        end
    end


    host_k_ev = avg_edge_val * host_k_deg
    host_deg = host_k_deg - (k_deg - host_k_share)
    host_val = host_k_val - k_cont
    host_ev = avg_edge_val * host_deg

    k_val = A[k,k]
    k_ev = avg_edge_val * k_deg


    Qout = (host_val - host_ev + k_val - k_ev) - (host_k_val - host_k_ev)
end
