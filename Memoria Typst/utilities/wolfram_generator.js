// I can probably use bitmasking to make rules simper but it wasn't worthy for just a quick utility
function rule30(left, center, right) {
    if (left === 1 && center === 1 && right === 1) return 0;
    if (left === 1 && center === 1 && right === 0) return 0;
    if (left === 1 && center === 0 && right === 1) return 0;
    if (left === 1 && center === 0 && right === 0) return 1;
    if (left === 0 && center === 1 && right === 1) return 1;
    if (left === 0 && center === 1 && right === 0) return 1;
    if (left === 0 && center === 0 && right === 1) return 1;
    if (left === 0 && center === 0 && right === 0) return 0;
}

function generate_wolfram(iterations, separator, rule) {
    const rowLength = 3 + iterations * 2;
    let currentRow = Array(rowLength).fill(0);
    currentRow[Math.floor(rowLength / 2)] = 1; // Center cell is always 1

    for (let i = 0; i < iterations - 1; i++) {
        // Calc next cell state
        let nextRow = Array(rowLength).fill(0);
        for (let j = 1; j < rowLength - 1; j++) {
            let left = currentRow[j - 1];
            let center = currentRow[j];
            let right = currentRow[j + 1];

            let nextStateValue = rule(left, center, right);
            nextRow[j] = nextStateValue;
        }

        console.log(currentRow.join(separator) + separator); 
        currentRow = nextRow; 
    }
}

generate_wolfram(3, ',', rule30);
