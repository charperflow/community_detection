using Statistics

"""
    function degreeof(V)
Takes a one-dimensional array `V` and returns the number of non-zero elements.
In a weighted edge matrix A, the degree of node i is found by passing A[i,:] into
this function.

# Examples

```julia-repl
julia> A = [[0,1,1.5,] [1,0,2] [1.5,2,0]]
3×3 Array{Float64,2}:
 0.0  1.0  1.5
 1.0  0.0  2.0
 1.5  2.0  0.0

julia> degreeof(A[1,:])
2
```
"""
function degreeof(V)

    N = size(V)[1]
    nonzeros = [1 for i = 1:N if V[i] != 0]
    degree = sum(nonzeros)

    return degree

end

function community_count(community_list)
    N = size(community_list)[1]
    community_tracker = Int64[]
    community_count = 0
    for i = 1:N
        if community_list[i] ∉ community_tracker
            push!(community_tracker,community_list[i])
            community_count = community_count + 1
        end
    end
    return community_count
end

function community_labels(community_list)
    N = size(community_list)[1]
    community_tracker = Int64[]
    for i = 1:N
        if community_list[i] ∉ community_tracker
            push!(community_tracker,community_list[i])
        end
    end
    return community_tracker
end

function community_sizes(community_list)
    N = size(community_list)[1]
    K = community_count(community_list)
    size_of_communities = zeros(K)
    for i = 1:N
        k = community_list[i]
        size_of_communities[k] = size_of_communities[k] + 1
    end
    return size_of_communities
end


function edges_between(community_list,A)
    N = size(community_list)[1]
    M = community_count(community_list)
    edges_out = zeros(M,M)
    for i = 1:N
        for j = 1:N
            if A[i,j] != 0 && community_list[i] != community_list[j]
                edges_out[community_list[i],community_list[j]] =
                edges_out[community_list[i],community_list[j]] + A[i,j]
            end
        end
    end

    return edges_out
end

function edges_within(community_list,A)
    N = size(community_list)[1]
    M = community_count(community_list)
    edges_in = zeros(M,M)
    for i = 1:N
        for j = i:N
            if A[i,j] != 0 && community_list[i] == community_list[j]
                i,j
                community_list[i],community_list[i]
                A[i,j]
                edges_in[community_list[i],community_list[i]] =
                edges_in[community_list[i],community_list[i]] + A[i,j]
            end
        end
    end
    return edges_in
end

function relabel!(community_list)
    N = size(community_list)[1]
    M = community_count(community_list)
    old_labels = community_labels(community_list)
    new_labels = [i for i ∈ 1:M ]
    for i = 1:M
        for j = 1:N
            if community_list[j] == old_labels[i]
                community_list[j] = new_labels[i]
            end
        end
    end
end


function avg_edge(A,γ)
    N = size(A)[1]
    count = 0
    total = 0
    for i = 1:N
        for j = i:N
            if A[i,j] != 0
                total = total + A[i,j]
                count = count +1
            end
        end
    end
    avg_edge_val = γ*(total/count)
    return avg_edge_val
end

function total_stdv(A)
    N = size(A)[1]

    contact_forces = Float64[]
    for i = 1:N
        for j = i:N
            if A[i,j] != 0
                push!(contact_forces,A[i,j])
            end
        end
    end

    standard_dev = std(contact_forces)
    return standard_dev
end

function particle_forces(A)
    N = size(A)[1]
    contact_forces = zeros(N)
    for i = 1:N
        for j = 1:N
            if A[i,j] !=0
                contact_forces[i] = contact_forces[i] + A[i,j]
            end
        end
    end
    return contact_forces
end



function total_value(A)
    N = size(A)[1]
    total = 0
    for i = 1:N
        for j = i:N
            total = total + A[i,j]
        end
    end
    return total
end

"""
returns community values for COLLAPSED matrix A
"""
function community_value(A)
    N = size(A)[1]
    values = Array{Float64}(undef,N)
    for i = 1:N
        values[i] = A[i,i]
    end
    return values
end

function comm_stdv(community_list, A)
    N = size(community_list)[1]
    M = community_count(community_list)

    community_stdv = zeros(M)
    list_of_list = Array[]
    current_value_list = Float64[]

    for i = 1:M
        for j = 1:N
            for k = i:N
                if A[j,k] != 0 && community_list[i] ==
                    community_list[j] == community_list[k]
                    push!(current_value_list,A[i,j])
                end
            end
        end
        push!(list_of_list,current_value_list)
        current_value_list = Float64[]
    end

    for i = 1:M
        community_stdv[i] = std(list_of_list[i])
    end

    return community_stdv

end
