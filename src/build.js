
import fs from "fs/promises";

const compileFile = async (fileName) => {
    let file = await fs.readFile(`./${fileName}`,'utf8');
    const matches = file.match(/require"\w+.lua"/g);
    if (!matches || !matches.length)
        return file;

    for (let match of matches){
        file = file.replace(match, await compileFile(match.slice('require"'.length, -4)));
    }
    return file;
};

(async () => {
    const rseheader = await fs.readFile('./rse_header.lua','utf8');

    let pokerus = await fs.readFile('./pokerus.lua','utf8');
    pokerus = pokerus.replace('require"rse_header.lua"', rseheader);
    await fs.writeFile('../Gen3/pokerus.lua', pokerus);
    
    let log_rng_advances = await fs.readFile('./log_rng_advances.lua','utf8');
    log_rng_advances = log_rng_advances.replace('require"rse_header.lua"', rseheader);
    await fs.writeFile('../Gen3/log_rng_advances.lua', log_rng_advances);
})();

