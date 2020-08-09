module G

using DataFrames
using CSV


df = DataFrame()
df = CSV.File("10xG_10xK.csv"; header = false) |> DataFrame!


N = size(df.Column8)[1]
partNum = 717
A = zeros(partNum,partNum)
x_pos = zeros(partNum)
y_pos = zeros(partNum)


for i = 1:N
    row     = df.Column8[i]
    column  = df.Column9[i]
    if row ≤ 717 && column ≤ 717
        magnitude    = sqrt(df.Column10[i]^2+df.Column11[i]^2)
        A[row,column] = magnitude
        x_pos[row]  = df.Column2[i]
        y_pos[row]  = df.Column3[i]
    end
end


n_forces = A + transpose(A)

avg_force = 0
total_force = 0
count = 0

for i = 1:partNum
    global total_force
    global count
    for j = 1:partNum
        if A[i,j] != 0
            total_force = total_force +A[i,j]
            count = count + 1
        end
    end
end

avg_force = total_force/count

nn_forces = copy(n_forces)

for i = 1:partNum
    for j =1:partNum
        nn_forces[i,j] = n_forces[i,j]/avg_force
    end
end

avg_force_n = 0
total_force_n = 0
count_n = 0

for i = 1:partNum
    global total_force_n
    global count_n
    for j = 1:partNum
        if nn_forces[i,j] != 0
            total_force_n = total_force_n + nn_forces[i,j]
            count_n = count_n + 1
        end
    end
end

avg_force_n = total_force_n/count_n

export nn_forces
export avg_force_n

c = maximum(n_forces[1,:])

show(c)

display(c)

end
