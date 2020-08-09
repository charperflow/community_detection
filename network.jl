module G


A = zeros(25,25)
for i = 1:5
    for j = 1:5
        A[i,j] = 1
    end
end

for i = 6:10
    for j = 6:10
        A[i,j] = 1
    end
end

for i = 11:15
    for j = 11:15
        A[i,j] = 1
    end
end

for i = 16:20
    for j = 16:20
        A[i,j] = 1
    end
end

for i = 21:25
    for j = 21:25
        A[i,j] = 1
    end
end

for i = 1:25
    A[i,i] = 0
end

A[4,5] = 0
A[5,4] = 0
A[5,6] = 1
A[6,5] = 1
A[6,7] = 0
A[7,6] = 0
A[10,11] = 1
A[11,10] = 1
A[11,12] = 0
A[12,11] = 0
A[15,16] = 1
A[16,15] = 1
A[16,17] = 0
A[17,16] = 0
A[20,21] = 1
A[21,20] = 1
A[21,22] = 0
A[22,21] = 0
A[25,4] = 1
A[4,25] = 1

avg_edge_val = 1

export A
export avg_edge_val



#=
A = zeros(16,16)



A[13,10]    = 4.0
A[9,13]     = 4
A[10,7]     = 4
A[7,11]     = 4
A[11,15]    = 4
A[7,3]      = 4

A[14,10]    = 2
A[10,6]     = 2
A[6,5]      = 2.0
A[5,1]      = 2

A[16,12]    = 2
A[12,8]     = 2
A[8,4]      = 2

A[10,14]    = 1
A[6,2]      = 1
A[9,5]      = 1
A[13,14]    = 1
A[14,15]    = 1
A[15,16]    = 1

A[:] = transpose(A) + A

avg_edge_val = sum(A)/38


#=
community_list = [2 for i ∈ 1:16]

community_list[1]   = 1
community_list[3]   = 3
community_list[4]   = 4
community_list[5]   = 1
community_list[6]   = 3
community_list[7]   = 3
community_list[8]   = 4
community_list[9]   = 3
community_list[10]  = 3
community_list[11]  = 3
community_list[12]  = 4
community_list[13]  = 3
community_list[15]  = 3
=#
export avg_edge_val

export A

=#

end
