
local calc_modulo_cycle_u = function(dividend, divisor)
    if divisor <= 0 then
        return 0 -- error
    end

    -- Ensure unsigned 32-bit behavior
    dividend = dividend & 0xFFFFFFFF
    divisor = divisor & 0xFFFFFFFF

    if dividend < divisor then
        return 18
    end

    local cycles = 24
    local r0 = dividend
    local r1 = divisor
    local r3 = 1
    local r2
    local r12
    local r4 = 0x10000000

    -- First loop
    while true do
        if r1 >= r4 then
            cycles = cycles + 10
            break
        end
        if r1 >= r0 then
            cycles = cycles + 14
            break
        end
        r1 = (r1 << 4) & 0xFFFFFFFF
        r3 = (r3 << 4) & 0xFFFFFFFF
        cycles = cycles + 20
    end

    r4 = (r4 << 3) & 0xFFFFFFFF

    -- Second loop
    while true do
        if r1 >= r4 then
            cycles = cycles + 10
            break
        end
        if r1 >= r0 then
            cycles = cycles + 14
            break
        end
        r1 = (r1 << 1) & 0xFFFFFFFF
        r3 = (r3 << 1) & 0xFFFFFFFF
        cycles = cycles + 20
    end

    -- Main loop
    while true do
        r2 = 0
        cycles = cycles + 48
        if r0 >= r1 then
            r0 = r0 - r1
            cycles = cycles - 4
        end

        r4 = r1 >> 1
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = ((r3 << (32 - 1)) | (r3 >> 1)) & 0xFFFFFFFF
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r4 = r1 >> 2
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = ((r3 << (32 - 2)) | (r3 >> 2)) & 0xFFFFFFFF
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r4 = r1 >> 3
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = ((r3 << (32 - 3)) | (r3 >> 3)) & 0xFFFFFFFF
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r12 = r3
        if r0 == 0 then
            cycles = cycles + 12
            break
        end
        r3 = r3 >> 4
        if r3 == 0 then
            cycles = cycles + 16
            break
        end
        r1 = r1 >> 4
        cycles = cycles + 20
    end

    r2 = r2 & 0xE0000000
    if r2 == 0 then
        return cycles + 18
    end

    r3 = r12
    r3 = ((r3 << (32 - 3)) | (r3 >> 3)) & 0xFFFFFFFF
    if (r2 & r3) ~= 0 then
        r0 = r0 + (r1 >> 3)
        cycles = cycles - 2
    end

    r3 = r12
    r3 = ((r3 << (32 - 2)) | (r3 >> 2)) & 0xFFFFFFFF
    if (r2 & r3) ~= 0 then
        r0 = r0 + (r1 >> 2)
        cycles = cycles - 2
    end

    r3 = r12
    r3 = ((r3 << (32 - 1)) | (r3 >> 1)) & 0xFFFFFFFF
    if (r2 & r3) ~= 0 then
        -- r0 = r0 + (r1 >> 1)
        cycles = cycles - 2
    end

    return cycles + 75
end


local calc_modulo_cycle_s = function(dividend, divisor)
    local abs = math.abs
    -- Simulate 32-bit signed/unsigned
    local function to_u32(x) return x & 0xFFFFFFFF end

    local r1 = abs(divisor)
    local r0 = abs(dividend)
    local r3 = 1
    local r2, r4, r12
    local cycles = 10

    if divisor > 0 then
        cycles = cycles + 4
    end

    cycles = cycles + 10
    if dividend > 0 then
        cycles = cycles + 4
    end

    if r0 < r1 then
        if dividend > 0 then
            return cycles + 32
        end
        return cycles + 28
    end

    r4 = 0x10000000
    cycles = cycles + 8

    -- First loop
    while true do
        if r1 >= r4 then
            cycles = cycles + 10
            break
        end
        if r1 >= r0 then
            cycles = cycles + 14
            break
        end
        r1 = to_u32(r1 << 4)
        r3 = to_u32(r3 << 4)
        cycles = cycles + 20
    end

    r4 = to_u32(r4 << 3)
    cycles = cycles + 2

    -- Second loop
    while true do
        if r1 >= r4 then
            cycles = cycles + 10
            break
        end
        if r1 >= r0 then
            cycles = cycles + 14
            break
        end
        r1 = to_u32(r1 << 1)
        r3 = to_u32(r3 << 1)
        cycles = cycles + 20
    end

    -- Main loop
    while true do
        r2 = 0
        cycles = cycles + 48
        if r0 >= r1 then
            r0 = r0 - r1
            cycles = cycles - 4
        end

        r4 = r1 >> 1
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = to_u32((r3 << (32 - 1)) | (r3 >> 1))
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r4 = r1 >> 2
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = to_u32((r3 << (32 - 2)) | (r3 >> 2))
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r4 = r1 >> 3
        if r0 >= r4 then
            r0 = r0 - r4
            r12 = r3
            r3 = to_u32((r3 << (32 - 3)) | (r3 >> 3))
            r2 = r2 | r3
            r3 = r12
            cycles = cycles + 7
        end

        r12 = r3
        if r0 == 0 then
            cycles = cycles + 12
            break
        end
        r3 = r3 >> 4
        if r3 == 0 then
            cycles = cycles + 16
            break
        end
        r1 = r1 >> 4
        cycles = cycles + 20
    end

    r2 = r2 & 0xE0000000
    if r2 == 0 then
        if dividend >= 0 then
            return cycles + 36
        end
        return cycles + 32
    end
    cycles = cycles + 8

    r3 = r12
    cycles = cycles + 17
    r3 = to_u32((r3 << (32 - 3)) | (r3 >> 3))
    if (r2 & r3) ~= 0 then
        r0 = r0 + (r1 >> 3)
        cycles = cycles - 2
    end
    r3 = r12

    cycles = cycles + 17
    r3 = to_u32((r3 << (32 - 2)) | (r3 >> 2))
    if (r2 & r3) ~= 0 then
        r0 = r0 + (r1 >> 2)
        cycles = cycles - 2
    end
    r3 = r12

    cycles = cycles + 17
    r3 = to_u32((r3 << (32 - 1)) | (r3 >> 1))
    if (r2 & r3) ~= 0 then
        -- r0 = r0 + (r1 >> 1)
        cycles = cycles - 2
    end

    cycles = cycles + 18
    if dividend >= 0 then
        cycles = cycles + 4
    end
    return cycles
end
