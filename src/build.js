
import fs from "fs/promises";

const compileFile = async (fileName) => {
    let file = await fs.readFile(`./${fileName}`,'utf8');
    const matches = file.match(/require"\w+.lua"/g);
    if (!matches || !matches.length)
        return file;

    for (let match of matches){
        file = file.replace(match, await compileFile(match.slice('require"'.length, -1)));
    }
    return file;
};

const compileAndSaveFile = async (fileName, dest) => {
    await fs.writeFile(dest, await compileFile(fileName));
};

(async () => {
    compileAndSaveFile('pokerus.lua', '../Gen3/pokerus.lua');
    compileAndSaveFile('log_rng_advances.lua', '../Gen3/log_rng_advances.lua');
    compileAndSaveFile('log_modulo.lua', '../Gen3/log_modulo.lua');

    compileAndSaveFile('log_sweet_scent_cycle.lua', '../Gen3/log_sweet_scent_cycle.lua');
})();

