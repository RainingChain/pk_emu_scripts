
const ISO = seed => (seed * BigInt(1103515245) + BigInt(24691)) % BigInt(4294967296);

const Random = seed => ISO(seed) >> 16n;

const Random_n = (seed,n) => {
   for(let i = 0; i < n; i++)
    seed = ISO(seed);
   return seed >> 16n;
};

const find = (seed, f) => {
    let list = [];
    for(let i = 0; i < 100000; i++){
        seed = ISO(seed);
        if (f(seed >> 16n))
            list.push([i, seed.toString(16), (seed >> 16n).toString(16)]);
    }
    if (list[0])
        console.log(list[0][0])
    return list;
};  

const print16 = (seed, min, max) => {
    for(let i = 0; i <= max; i++){
        seed = ISO(seed);
        if (i >= min)
            console.log((seed >> 16).toString(16))
    }
};

const print32 = (seed, min, max) => {
    for(let i = 0; i <= max; i++){
        seed = ISO(seed);
        if (i >= min)
            console.log(seed.toString(16))
    }
};

/*
Pokerus Emerald:
    find(0n, f => [0x4000n, 0x8000n, 0xC0000n].includes(f))
    66610

Pokerus R/S:
    find(0x5A0n, f => [0x4000n, 0x8000n, 0xC0000n].includes(f))
    26923

    4a5b
*/
